import 'package:cafeapp_v2/constants/app_colours.dart';
import 'package:cafeapp_v2/constants/routes.dart';
import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:cafeapp_v2/services/auth_service.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:cafeapp_v2/services/location_service.dart';
import 'package:cafeapp_v2/widgets/cafe_marker.dart';
import 'package:cafeapp_v2/widgets/roaster_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MapPage extends StatelessWidget {
  MapPage({super.key});

  final List<Marker> markers = [
    CafeMarker(
        point: const LatLng(51.2283, -2.8088), cafeName: "The Swan Wedmore"),
    CafeMarker(point: const LatLng(51.2253, -2.8058), cafeName: "Test Cafe"),
    RoasterMarker(
        point: const LatLng(51.2200, -2.8000), roasterName: "Wedmore Roasters"),
  ];
  @override
  Widget build(BuildContext context) {
    final LocationService location =
        Provider.of<LocationService>(context, listen: false);
    final DatabaseService database =
        Provider.of<DatabaseService>(context, listen: false);
    final AuthService authService = Provider.of(context, listen: false);

    MapController mapController = MapController();
    return Scaffold(
      body: FutureBuilder<Position>(
        future: location.getCurrentPosition(),
        builder: (context, AsyncSnapshot<Position> snapshot) {
          if (snapshot.hasData) {
            return Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                //Map
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: LatLng(
                        snapshot.data!.latitude, snapshot.data!.longitude),
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
                      markers: markers,
                    ),
                  ],
                ),
                //State
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
            ));
          }
        },
      ),
    );
  }
}
