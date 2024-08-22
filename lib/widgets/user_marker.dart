import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class UserMarker extends Marker {
  final Position position;
  final MapController controller;
  UserMarker({
    required this.position,
    required this.controller,
  }) : super(
          point: LatLng(position.latitude, position.longitude),
          alignment: Alignment.center,
          child: GestureDetector(
            onDoubleTap: () {
              controller.move(LatLng(position.latitude, position.longitude), controller.camera.zoom);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                /*Icon(
                    Icons.circle,
                    color: const Color.fromARGB(125, 0, 0, 0),
                    size: position.accuracy,
                  ),*/
                Transform.rotate(
                  angle: position.heading,
                  child: const Icon(
                    Icons.navigation,
                    color: CafeAppUI.secondaryColor,
                    size: 20,
                  ),
                )
              ],
            ),
          ),
        );
}
