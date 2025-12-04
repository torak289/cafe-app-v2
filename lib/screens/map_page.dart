import 'dart:async';
import 'dart:io';

import 'package:cafeapp_v2/constants/cafe_app_ui.dart';
import 'package:cafeapp_v2/constants/routes.dart';
import 'package:cafeapp_v2/enum/app_states.dart';
import 'package:cafeapp_v2/services/auth_service.dart';
import 'package:cafeapp_v2/services/connectivity_service.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:cafeapp_v2/services/location_service.dart';
import 'package:cafeapp_v2/utils/cafeapp_utils.dart';
import 'package:cafeapp_v2/utils/systemui_utils.dart';
import 'package:cafeapp_v2/widgets/map/map_controls.dart';
import 'package:cafeapp_v2/widgets/onboarding_popup.dart';
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

class _MapPageState extends State<MapPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimatedMapController animatedMapController =
      AnimatedMapController(vsync: this);

  late DatabaseService database;
  Future<MarkerLayer>? _markerLayer;
  bool _isMarkerLayerInitialized = false;

  // Key to rebuild only the marker FutureBuilder, not the entire map
  final ValueNotifier<int> _markerUpdateNotifier = ValueNotifier<int>(0);

  // Track permission changes
  final ValueNotifier<int> _permissionCheckNotifier = ValueNotifier<int>(0);

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _markerUpdateNotifier.dispose();
    _permissionCheckNotifier.dispose();
    animatedMapController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // When app resumes, re-check permissions
    if (state == AppLifecycleState.resumed) {
      debugPrint('App resumed - rechecking location permissions');
      _permissionCheckNotifier.value++;
    }
  }

  Future<MarkerLayer> get markerLayer {
    if (!_isMarkerLayerInitialized) {
      _markerLayer = database.getCafesInBounds(animatedMapController);
      _isMarkerLayerInitialized = true;
    }
    return _markerLayer!;
  }

  set markerLayer(Future<MarkerLayer> value) {
    _markerLayer = value;
  }

  final _inBoundsDebouncer = Debouncer(milliseconds: 200);

  // Default location (e.g., San Francisco) used when location services are disabled
  static const LatLng _defaultLocation = LatLng(51.5072, 0.1276);

  @override
  Widget build(BuildContext context) {
    final LocationService location =
        Provider.of<LocationService>(context, listen: true);
    final AuthService authService = Provider.of(context, listen: true);
    database = Provider.of<DatabaseService>(context, listen: false);
    final ConnectivityService connectivity = Provider.of(context, listen: true);

    return Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: _permissionCheckNotifier,
        builder: (context, value, child) {
          return FutureBuilder<LocationPermission>(
            future: location.checkServices(),
            builder: (context, locationData) {
              // Check if location services are enabled
              // Handle both successful permission grants and errors/denials
              final bool hasLocationPermission =
                  locationData.connectionState == ConnectionState.done &&
                      !locationData.hasError &&
                      (locationData.data == LocationPermission.always ||
                          locationData.data == LocationPermission.whileInUse);

              // Show loading only on initial load
              if (locationData.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return Stack(children: [
                StreamBuilder<List<ConnectivityResult>>(
                    stream: connectivity.connectivityStream,
                    builder: (context, snapshot) {
                      final results = snapshot.data ?? [];
                      final isDisconnected = results.isEmpty ||
                          results.contains(ConnectivityResult.none);
                      if (isDisconnected) {
                        return Container(
                          height: 96,
                          color: Colors.pinkAccent,
                          padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                          child: Center(
                            child: Text(
                              'Check your network connection...',
                              style: const TextStyle(
                                  color: CafeAppUI.buttonTextColor),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                // Build the map with or without location
                hasLocationPermission
                    ? StreamBuilder<Position>(
                        stream: location.positionStream,
                        builder: (context, AsyncSnapshot<Position> position) {
                          if (position.hasData) {
                            return _buildMapContent(
                              context,
                              authService,
                              LatLng(position.data!.latitude,
                                  position.data!.longitude),
                              position.data,
                            );
                          } else if (position.hasError) {
                            // If there's an error getting position, fallback to default location
                            debugPrint(
                                'Position stream error: ${position.error}');
                            return _buildMapContent(
                              context,
                              authService,
                              _defaultLocation,
                              null,
                            );
                          } else {
                            // Use FutureBuilder as fallback to get initial position
                            return FutureBuilder<Position>(
                              future: location.currentPosition,
                              builder: (context, futurePosition) {
                                if (futurePosition.hasData) {
                                  return _buildMapContent(
                                    context,
                                    authService,
                                    LatLng(futurePosition.data!.latitude,
                                        futurePosition.data!.longitude),
                                    futurePosition.data,
                                  );
                                } else if (futurePosition.hasError) {
                                  // If we can't get position, use default location
                                  debugPrint(
                                      'Current position error: ${futurePosition.error}');
                                  return _buildMapContent(
                                    context,
                                    authService,
                                    _defaultLocation,
                                    null,
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            );
                          }
                        },
                      )
                    : _buildMapContent(
                        context,
                        authService,
                        _defaultLocation,
                        null, // No position available
                      ),
              ]);
            },
          );
        },
      ),
    );
  }

  Widget _buildMapContent(
    BuildContext context,
    AuthService authService,
    LatLng centerLocation,
    Position? userPosition,
  ) {
    return Stack(
      children: [
        FutureBuilder(
          future: _cacheStoreFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final cacheStore = snapshot.data!;
              return FlutterMap(
                mapController: animatedMapController.mapController,
                options: MapOptions(
                  onMapEvent: (event) {
                    // Don't call setState here - it causes map to flicker
                    // Update markers when map movement ends
                    final id = AnimationId.fromMapEvent(event);
                    final shouldUpdate = (id?.moveId == AnimatedMoveId.finished) ||
                        event is MapEventMoveEnd ||
                        event is MapEventFlingAnimationEnd ||
                        event is MapEventNonRotatedSizeChange;
                    
                    if (shouldUpdate) {
                      _inBoundsDebouncer.run(() {
                        markerLayer = database.getCafesInBounds(
                            animatedMapController);
                        _markerUpdateNotifier.value++;
                      });
                    }
                  },
                  onLongPress: (tapPos, latlng) {
                    if (authService.appState == AppState.Authenticated) {
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
                  initialCenter: centerLocation,
                  initialZoom: userPosition != null ? 16 : 12,
                  maxZoom: 21,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
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
                  // Wrap markers in ValueListenableBuilder to rebuild only markers, not entire map
                  ValueListenableBuilder<int>(
                    valueListenable: _markerUpdateNotifier,
                    builder: (context, value, child) {
                      return FutureBuilder(
                        future: markerLayer,
                        builder: (context, cafeMarkers) {
                          if (cafeMarkers.hasData) {
                            return cafeMarkers.data!;
                          } else {
                            return const MarkerLayer(markers: []);
                          }
                        },
                      );
                    },
                  ),
                  if (userPosition != null)
                    MarkerLayer(
                      markers: [
                        UserMarker(
                          position: userPosition,
                          controller: animatedMapController.mapController,
                        ),
                      ],
                    ),
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
              //Map Controls - only show location button if position is available
              if (userPosition != null)
                MapControls(
                  animatedMapController: animatedMapController,
                  position: userPosition,
                  isAddCafePage: false,
                ),
              //Profile
              const Profile(),
              SearchControls(
                markerLayer: markerLayer,
                mapController: animatedMapController,
              ),
            ],
          ),
        ),
        OnboardingPopup(),
      ],
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
