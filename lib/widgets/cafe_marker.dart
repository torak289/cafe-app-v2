import 'package:cafeapp_v2/constants/app_colours.dart';
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CafeMarker extends Marker {
  LatLng point;
  String cafeName;

  CafeMarker({
    required this.point,
    required this.cafeName,
  }) : super(
          point: point,
          width: 192,
          rotate: true,
          alignment: Alignment.bottomRight,
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
                  color: AppColours.cafeIconColor,
                ),
              ),
              Text(
                cafeName,
                style: const TextStyle(
                  fontFamily: "Monospace",
                  fontWeight: FontWeight.bold,
                  fontSize: 8,
                  color: AppColours.secondaryColor,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 4),
              ),
              const Icon(
                Icons.circle,
                size: 8,
                color: AppColours.secondaryColor,
              ),
            ],
          ),
        );
}
