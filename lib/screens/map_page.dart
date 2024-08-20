import 'package:cafeapp_v2/constants/app_colours.dart';
import 'package:cafeapp_v2/constants/routes.dart';
import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:cafeapp_v2/services/auth_service.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:cafeapp_v2/services/location_service.dart';
import 'package:cafeapp_v2/widgets/cafe_marker.dart';
import 'package:cafeapp_v2/widgets/roaster_marker.dart';
import 'package:cafeapp_v2/widgets/user_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  late final AnimatedMapController animatedMapController =
      AnimatedMapController(vsync: this);
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animatedMapController.dispose();
  }

  List<Marker> getMarkers(List<CafeModel> cafeModelList) {
    List<CafeModel> cafes = cafeModelList;
    List<Marker> markers = List<Marker>.empty();
    for (int i = 0; i < cafes.length; i++) {
      markers
          .add(CafeMarker(point: cafes[i].location, cafeName: cafes[i].name));
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final LocationService location =
        Provider.of<LocationService>(context, listen: false);
    final DatabaseService database =
        Provider.of<DatabaseService>(context, listen: false);
    final AuthService authService = Provider.of(context, listen: false);

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
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      //Map
                      FlutterMap(
                        mapController: animatedMapController.mapController,
                        options: MapOptions(
                          initialCenter: LatLng(position.data!.latitude,
                              position.data!.longitude),
                          initialZoom: 14.5,
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
                                controller: animatedMapController.mapController,
                              ),
                            ],
                          ),
                        ],
                      ),
                      //Map Controls
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              animatedMapController.animatedZoomOut();
                            },
                            icon: const Icon(
                              Icons.zoom_out_rounded,
                              color: AppColours.cafeIconColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              animatedMapController.animatedZoomIn();
                            },
                            icon: const Icon(
                              Icons.zoom_in_rounded,
                              color: AppColours.cafeIconColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              animatedMapController.animateTo(
                                dest: LatLng(position.data!.latitude,
                                    position.data!.longitude),
                              );
                            },
                            icon: const Icon(
                              Icons.my_location_rounded,
                              color: AppColours.cafeIconColor,
                            ),
                          ),
                        ],
                      ),
                      //Profile
                      GestureDetector(
                        child: Column(
                          children: [
                            Text('${authService.appState}'),
                            const Icon(
                              Icons.person,
                              color: AppColours.cafeIconColor,
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, Routes.loginPage);
                        },
                      )
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
