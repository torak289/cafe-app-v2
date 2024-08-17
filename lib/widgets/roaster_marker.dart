import 'package:cafeapp_v2/constants/app_colours.dart';
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RoasterMarker extends Marker {
  @override
  final LatLng point;
  final String roasterName;

  RoasterMarker({
    required this.point,
    required this.roasterName,
  }) : super(
          point: point,
          width: 192,
          alignment: Alignment.bottomRight,
          rotate: true,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  debugPrint("On Tap");
                },
                onDoubleTap: () {
                  debugPrint("On Double Tap");
                },
                child: const Icon(
                  Icons.location_on_sharp,
                  color: AppColours.roasterIconColor,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roasterName,
                    style: const TextStyle(
                      fontFamily: "Monospace",
                      fontWeight: FontWeight.bold,
                      fontSize: 8,
                      color: AppColours.secondaryColor,
                    ),
                  ),
                  const Text(
                    'Roaster',
                    style: TextStyle(
                      fontFamily: "Monospace",
                      fontWeight: FontWeight.bold,
                      fontSize: 8,
                      color: AppColours.secondaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
}
