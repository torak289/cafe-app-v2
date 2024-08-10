import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(51.2288, -2.8111),
              initialZoom: 12,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'io.cafe-app',
                maxZoom: 19,
              ),
              const MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(51.2288, -2.8111),
                    child: Icon(
                      Icons.location_on_sharp,
                      color: Colors.black,
                    ),
                  ),
                ],
              )
            ],
          ),
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
