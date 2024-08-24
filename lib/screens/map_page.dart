import 'dart:async';

import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/constants/routes.dart';
import 'package:cafeapp_v2/services/auth_service.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:cafeapp_v2/services/location_service.dart';
import 'package:cafeapp_v2/widgets/map_controls.dart';
import 'package:cafeapp_v2/widgets/profile.dart';
import 'package:cafeapp_v2/widgets/search_controls.dart';
import 'package:cafeapp_v2/widgets/user_marker.dart';
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

  @override
  void dispose() {
    super.dispose();
    animatedMapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LocationService location =
        Provider.of<LocationService>(context, listen: false);
    final AuthService authService = Provider.of(context, listen: false);
    final DatabaseService database =
        Provider.of<DatabaseService>(context, listen: false);

    Future<MarkerLayer> markerLayer =
        database.getCafeMarkerLayer(animatedMapController);

    Stream cafesStream =
        database.database.from('cafes').stream(primaryKey: ['uid']);
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
                      //Map
                      FlutterMap(
                        mapController: animatedMapController.mapController,
                        options: MapOptions(
                          onLongPress: (tapPos, latlng) {
                            debugPrint(latlng.toString());
                            Navigator.pushNamed(context, Routes.addCafePage, arguments: latlng);
                          },
                          initialCenter: LatLng(position.data!.latitude,
                              position.data!.longitude),
                          initialZoom: 14.5,
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
                      Profile(),
                      SearchControls(),
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
}
