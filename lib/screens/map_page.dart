import 'dart:async';

import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/constants/routes.dart';
import 'package:cafeapp_v2/enum/app_states.dart';
import 'package:cafeapp_v2/services/auth_service.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:cafeapp_v2/services/location_service.dart';
import 'package:cafeapp_v2/utils/cafeapp_utils.dart';
import 'package:cafeapp_v2/widgets/map/map_controls.dart';
import 'package:cafeapp_v2/widgets/profile.dart';
import 'package:cafeapp_v2/widgets/map/search_controls.dart';
import 'package:cafeapp_v2/widgets/map/markers/user_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

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
    return Scaffold(
      body: FutureBuilder<LocationPermission>(
        future: location.checkServices(),
        builder: (context, locationData) {
          if (locationData.data == LocationPermission.always ||
              locationData.data == LocationPermission.whileInUse) {
            return StreamBuilder<Position>(
              stream: location.positionStream,
              builder: (context, AsyncSnapshot<Position> position) {
                if (position.hasData) {
                  return Stack(
                    children: [
                      FlutterMap(
                        mapController: animatedMapController.mapController,
                        options: MapOptions(
                          onMapEvent: (event) => setState(
                            () {
                              //TODO: Improve Debounce... >>> Movement based Debounce >>> Location based Debounce
                              //TODO: Implement Caching...
                              String evtName = _eventName(event, markerLayer);
                              final id = AnimationId.fromMapEvent(event);
                              if (id != null) {
                                if (id.moveId == AnimatedMoveId.finished) {
                                  _inBoundsDebouncer.run(() {
                                    markerLayer = database.getCafesInBounds(
                                        animatedMapController);
                                  });
                                }
                              }
                              if (evtName == 'MapEventMoveEnd' ||
                                  evtName == 'MapEventFlingAnimationEnd' ||
                                  evtName == 'MapEventNonRotatedSizeChange') {
                                _inBoundsDebouncer.run(() {
                                  markerLayer = database
                                      .getCafesInBounds(animatedMapController);
                                });
                              }
                            },
                          ),
                          onLongPress: (tapPos, latlng) {
                            if (authService.appState ==
                                AppState.Authenticated) {
                              Navigator.pushNamed(context, Routes.addCafePage,
                                  arguments: latlng);
                            } else {
                              debugPrint("Not Authenticated");
                            }
                          },
                          initialCenter: LatLng(position.data!.latitude,
                              position.data!.longitude),
                          initialZoom: 16,
                          maxZoom: 21,
                          interactionOptions: const InteractionOptions(
                            flags:
                                InteractiveFlag.all & ~InteractiveFlag.rotate,
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
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'io.cafe-app',
                            maxZoom: 25,
                          ),
                          MarkerLayer(
                            markers: [
                              UserMarker(
                                position: position.data!,
                                controller: animatedMapController.mapController,
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
                              })
                        ],
                      ),
                      //Map Controls
                      MapControls(
                          animatedMapController: animatedMapController,
                          position: position.data!),
                      //Debug
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          '${authService.appState}',
                          style: const TextStyle(color: CafeAppUI.errorText),
                        ),
                      ),
                      //Profile
                      const Profile(),
                      SearchControls(
                        markerLayer: markerLayer,
                        mapController: animatedMapController,
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
            );
          } else {
            return Center(
              child: Column(
                children: [
                  Text(locationData.error.toString()),
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
