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
          //width: position.accuracy * 10,
          //height: position.accuracy * 10,
          alignment: Alignment.center,
          child: GestureDetector(
            onDoubleTap: () {
              controller.move(
                  LatLng(position.latitude, position.longitude), 18);
              debugPrint(position.accuracy.toString());
            },
            child: Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(50, 255, 64, 128),
                  border: BoxBorder.all(color: Colors.pinkAccent, width: 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(200),
                  )),
              child: Transform.rotate(
                angle: position.heading,
                child: const Icon(
                  Icons.navigation,
                  color: Colors.pinkAccent,
                  size: 20,
                ),
              ),
            ),
          ),
        );
}
