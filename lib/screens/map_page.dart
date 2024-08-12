import 'package:cafeapp_v2/constants/routes.dart';
import 'package:cafeapp_v2/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LocationService location =
        Provider.of<LocationService>(context, listen: false);

    MapController mapController = MapController();
    return Scaffold(
      body: FutureBuilder<Position>(
        future: location.getCurrentPosition(),
        builder: (context, AsyncSnapshot<Position> snapshot) {
          if (snapshot.hasData) {
            return Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: LatLng(
                        snapshot.data!.latitude, snapshot.data!.longitude),
                    initialZoom: 12,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'io.cafe-app',
                      maxZoom: 21,
                    ),
                    const MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(51.2283, -2.8088),
                          child: Icon(
                            Icons.location_on_sharp,
                            color: Colors.black,
                          ),
                        ),
                        Marker(
                          point: LatLng(51.2200, -2.8000),
                          child: Icon(
                            Icons.location_on_sharp,
                            color: Colors.pinkAccent,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    TextButton(
                      onPressed: () => {
                        //TODO: implement zoom out
                        Navigator.pushNamed(context, Routes.registrationPage)
                      },
                      child: const Text("Zoom Out!"),
                    ),
                    TextButton(
                      onPressed: () => {
                        //TODO: implement zoom in
                        Navigator.pushNamed(context, Routes.loginPage)
                      },
                      child: const Text("Zoom In!"),
                    ),
                    TextButton(
                      onPressed: () => {},
                      child: Text("Center!"),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => {},
                        child: Text("Find Cafe"),
                      ),
                      TextField(),
                    ],
                  ),
                ),
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
