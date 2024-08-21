import 'package:cafeapp_v2/constants/app_colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapControls extends StatelessWidget {
  const MapControls({
    super.key,
    required this.animatedMapController,
    required this.position,
  });

  final AnimatedMapController animatedMapController;
  final Position position;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, AppColours.screenHorizontal, AppColours.screenVertical * 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () {
              animatedMapController.animatedZoomOut();
            },
            icon: const Icon(
              Icons.zoom_out_rounded,
            ),
          ),
          IconButton(
            onPressed: () {
              animatedMapController.animatedZoomIn();
            },
            icon: const Icon(
              Icons.zoom_in_rounded,
            ),
          ),
          IconButton(
            onPressed: () {
              animatedMapController.animateTo(
                dest: LatLng(position.latitude,
                    position.longitude),
              );
            },
            icon: const Icon(
              Icons.my_location_rounded,
            ),
          ),
        ],
      ),
    );
  }
}