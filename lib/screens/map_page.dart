import 'dart:async';
import 'dart:io';

import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/constants/routes.dart';
import 'package:cafeapp_v2/enum/app_states.dart';
import 'package:cafeapp_v2/services/auth_service.dart';
import 'package:cafeapp_v2/services/connectivity_service.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:cafeapp_v2/services/location_service.dart';
import 'package:cafeapp_v2/utils/cafeapp_utils.dart';
import 'package:cafeapp_v2/utils/systemui_utils.dart';
import 'package:cafeapp_v2/widgets/map/map_controls.dart';
import 'package:cafeapp_v2/widgets/profile.dart';
import 'package:cafeapp_v2/widgets/map/search_controls.dart';
import 'package:cafeapp_v2/widgets/map/markers/user_marker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:path_provider/path_provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  late final AnimatedMapController animatedMapController =
      AnimatedMapController(vsync: this);

  late DatabaseService database;
  late Future<MarkerLayer> markerLayer =
      database.getCafesInBounds(animatedMapController);

  final Future<CacheStore> _cacheStoreFuture = _getCacheStore();

  /// Get the CacheStore as a Future. This method needs to be static so that it
  /// can be used to initialize a field variable.
  static Future<CacheStore> _getCacheStore() async {
    final dir = await getTemporaryDirectory();
    // Note, that Platform.pathSeparator from dart:io does not work on web,
    // import it from dart:html instead.
    return FileCacheStore('${dir.path}${Platform.pathSeparator}MapTiles');
  }

  @override
  void dispose() {
    super.dispose();
    animatedMapController.dispose();
  }

  final _inBoundsDebouncer = Debouncer(milliseconds: 200);
  @override
  Widget build(BuildContext context) {
    final LocationService location =
        Provider.of<LocationService>(context, listen: false);
    final AuthService authService = Provider.of(context, listen: false);
    database = Provider.of<DatabaseService>(context, listen: false);
    final ConnectivityService connectivity =
        Provider.of(context, listen: false);
    return Scaffold(
      body: FutureBuilder<LocationPermission>(
        future: location.checkServices(),
        builder: (context, locationData) {
          if (locationData.data == LocationPermission.always ||
              locationData.data == LocationPermission.whileInUse) {
            return Stack(children: [
              StreamBuilder<List<ConnectivityResult>>(
                  stream: connectivity.connectivityStream,
                  builder: (context, snapshot) {
                    final isConnected =
                        !(snapshot.data?.contains(ConnectivityResult.none) ??
                            true);
                    if (!isConnected) {
                      return SizedBox.shrink();
                    } else {
                      return Container(
                        height: 64,
                        color: Colors.pinkAccent,
                        child: Center(
                          child: Text(
                            'Check your network connection...',
                            style: TextStyle(color: CafeAppUI.buttonTextColor),
                          ),
                        ),
                      );
                    }
                  }),
              StreamBuilder<Position>(
                stream: location.positionStream,
                builder: (context, AsyncSnapshot<Position> position) {
                  if (position.hasData) {
                    return Stack(
                      children: [
                        FutureBuilder(
                          future: _cacheStoreFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final cacheStore = snapshot.data!;
                              return FlutterMap(
                                mapController:
                                    animatedMapController.mapController,
                                options: MapOptions(
                                  onMapEvent: (event) => setState(
                                    () {
                                      //TODO: Improve Debounce... >>> Movement based Debounce >>> Location based Debounce
                                      //TODO: Implement Caching...
                                      String evtName =
                                          _eventName(event, markerLayer);
                                      final id =
                                          AnimationId.fromMapEvent(event);
                                      if (id != null) {
                                        if (id.moveId ==
                                            AnimatedMoveId.finished) {
                                          _inBoundsDebouncer.run(() {
                                            markerLayer =
                                                database.getCafesInBounds(
                                                    animatedMapController);
                                          });
                                        }
                                      }
                                      if (evtName == 'MapEventMoveEnd' ||
                                          evtName ==
                                              'MapEventFlingAnimationEnd' ||
                                          evtName ==
                                              'MapEventNonRotatedSizeChange') {
                                        _inBoundsDebouncer.run(() {
                                          markerLayer =
                                              database.getCafesInBounds(
                                                  animatedMapController);
                                        });
                                      }
                                    },
                                  ),
                                  onLongPress: (tapPos, latlng) {
                                    //This fails silently when location issues appear...
                                    if (authService.appState ==
                                        AppState.Authenticated) {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.addCafePage,
                                        arguments: AddCafeArgs(
                                          cafePosition: latlng,
                                          isOwner: false,
                                        ),
                                      );
                                    } else {
                                      debugPrint("Not Authenticated");
                                    }
                                  },
                                  initialCenter: LatLng(position.data!.latitude,
                                      position.data!.longitude),
                                  initialZoom: 16,
                                  maxZoom: 21,
                                  interactionOptions: const InteractionOptions(
                                    flags: InteractiveFlag.all &
                                        ~InteractiveFlag.rotate,
                                  ),
                                  cameraConstraint: CameraConstraint.contain(
                                    bounds: LatLngBounds(
                                      const LatLng(-90, -180),
                                      const LatLng(90, 180),
                                    ),
                                  ),
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://api.maptiler.com/maps/dataviz-light/{z}/{x}/{y}@2x.png?key=9xI0Yb0PwYnKHuphfPNr',
                                    userAgentPackageName: 'io.cafe-app',
                                    maxZoom: 25,
                                    tileProvider: CachedTileProvider(
                                      store: cacheStore,
                                      maxStale: const Duration(days: 2),
                                    ),
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      UserMarker(
                                        position: position.data!,
                                        controller:
                                            animatedMapController.mapController,
                                      ),
                                    ],
                                  ),
                                  FutureBuilder(
                                    future: markerLayer,
                                    builder: (context, cafeMarkers) {
                                      if (cafeMarkers.hasData) {
                                        return cafeMarkers.data!;
                                      } else {
                                        return const MarkerLayer(markers: []);
                                      }
                                    },
                                  )
                                ],
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                        SafeArea(
                          child: Stack(
                            children: [
                              //Map Controls
                              MapControls(
                                  animatedMapController: animatedMapController,
                                  position: position.data!),
                              //Profile
                              const Profile(),
                              SearchControls(
                                markerLayer: markerLayer,
                                mapController: animatedMapController,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    );
                  }
                },
              ),
            ]);
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: CafeAppUI.screenHorizontal,
                vertical: CafeAppUI.screenVertical,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    locationData.error.toString(),
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(8)),
                  TextButton(
                    onPressed: () {
                      location.openLocationSetting();
                    },
                    child: const Text('Location Settings'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  String _eventName(MapEvent? event, Future<MarkerLayer> markerLayer) {
    debugPrint(event.toString());

    switch (event) {
      case MapEventTap():
        return 'MapEventTap';
      case MapEventSecondaryTap():
        return 'MapEventSecondaryTap';
      case MapEventLongPress():
        return 'MapEventLongPress';
      case MapEventMove():
        return 'MapEventMove';
      case MapEventMoveStart():
        return 'MapEventMoveStart';
      case MapEventMoveEnd():
        return 'MapEventMoveEnd';
      case MapEventFlingAnimation():
        return 'MapEventFlingAnimation';
      case MapEventFlingAnimationNotStarted():
        return 'MapEventFlingAnimationNotStarted';
      case MapEventFlingAnimationStart():
        return 'MapEventFlingAnimationStart';
      case MapEventFlingAnimationEnd():
        return 'MapEventFlingAnimationEnd';
      case MapEventDoubleTapZoom():
        return 'MapEventDoubleTapZoom';
      case MapEventScrollWheelZoom():
        return 'MapEventScrollWheelZoom';
      case MapEventDoubleTapZoomStart():
        return 'MapEventDoubleTapZoomStart';
      case MapEventDoubleTapZoomEnd():
        return 'MapEventDoubleTapZoomEnd';
      case MapEventRotate():
        return 'MapEventRotate';
      case MapEventRotateStart():
        return 'MapEventRotateStart';
      case MapEventRotateEnd():
        return 'MapEventRotateEnd';
      case MapEventNonRotatedSizeChange():
        return 'MapEventNonRotatedSizeChange';
      case null:
        return 'null';
      default:
        return 'Unknown';
    }
  }
}
