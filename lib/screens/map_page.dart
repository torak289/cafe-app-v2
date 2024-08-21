import 'package:cafeapp_v2/constants/app_colours.dart';
import 'package:cafeapp_v2/constants/routes.dart';
import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:cafeapp_v2/services/auth_service.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:cafeapp_v2/services/location_service.dart';
import 'package:cafeapp_v2/widgets/cafe_marker.dart';
import 'package:cafeapp_v2/widgets/map_controls.dart';
//import 'package:cafeapp_v2/widgets/roaster_marker.dart';
import 'package:cafeapp_v2/widgets/search_controls.dart';
import 'package:cafeapp_v2/widgets/user_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    return Scaffold(
      body: FutureBuilder<LocationPermission>(
        future: location.checkServices(),
        builder: (context, locationData) {
          if (locationData.data == LocationPermission.always ||
              locationData.data == LocationPermission.whileInUse) {
            return FutureBuilder(
                future: database.getCafeMarkerLayer(),
                builder: (context, cafeMarkerLayer) {
                  return StreamBuilder<Position>(
                    stream: location.positionStream,
                    builder: (context, AsyncSnapshot<Position> position) {
                      if (position.hasData) {
                        return Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            //Map
                            FlutterMap(
                              mapController:
                                  animatedMapController.mapController,
                              options: MapOptions(
                                initialCenter: LatLng(position.data!.latitude,
                                    position.data!.longitude),
                                initialZoom: 14.5,
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
                                  maxZoom: 21,
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
                                if (cafeMarkerLayer.hasData)
                                  cafeMarkerLayer.data!,
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
                                style: const TextStyle(
                                    color: AppColours.errorText),
                              ),
                            ),
                            //Profile
                            GestureDetector(
                              child: const Icon(
                                Icons.person,
                                color: AppColours.cafeIconColor,
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, Routes.loginPage);
                              },
                            ),
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
                });
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
