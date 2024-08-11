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
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<Position>(
              future: location.determinePosition(),
              builder: (context, AsyncSnapshot<Position> snapshot) {
                if (snapshot.hasData) {
                  return FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(
                          snapshot.data!.latitude, snapshot.data!.longitude),
                      initialZoom: 15,
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
                          const Marker(
                            point: LatLng(51.2283, -2.8088),
                            child: Icon(Icons.location_on_sharp,
                                color: Colors.black),
                          ),
                          Marker(
                            point: LatLng(snapshot.data!.latitude,
                                snapshot.data!.longitude),
                            child: const Icon(Icons.location_on_sharp,
                                color: Colors.black),
                          ),
                        ],
                      )
                    ],
                  );
                } else {
                  return Text("${snapshot.error}");
                }
              }),
          Column(
            children: [
              TextButton(onPressed: () => {}, child: const Text("Zoom Out!")),
              TextButton(onPressed: () => {}, child: const Text("Zoom In!"))
            ],
          ),
        ],
      ),
    );
  }
}
