import 'package:cafeapp_v2/services/location_service.dart';
import 'package:cafeapp_v2/widgets/cafe_marker.dart';
import 'package:cafeapp_v2/widgets/roaster_marker.dart';
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
                        CafeMarker(
                          point: const LatLng(51.2283, -2.8088),
                          cafeName: "The Swan Wedmore",
                        ),
                        RoasterMarker(
                          point: const LatLng(51.2200, -2.8000),
                          roasterName: "Wedmore Roasters",
                        ),
                      ],
                    )
                  ],
                ),
                //Map Search
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => {},
                        child: const Text("Find Cafe"),
                      ),
                      const TextField(
                        decoration: InputDecoration(
                          hintText: "Search",
                        ),
                      ),
                    ],
                  ),
                ),
                //Map Controls
                Column(
                  children: [
                    IconButton(
                      onPressed: () => {},
                      icon: const Icon(
                        Icons.zoom_out_rounded,
                      ),
                    ),
                    IconButton(
                      onPressed: () => {},
                      icon: const Icon(
                        Icons.zoom_in_rounded,
                      ),
                    ),
                    IconButton(
                      onPressed: () => {},
                      icon: const Icon(
                        Icons.my_location_rounded,
                      ),
                    ),
                  ],
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
