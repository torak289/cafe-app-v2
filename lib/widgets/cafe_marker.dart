import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CafeMarker extends Marker {
  @override
  final LatLng point;
  final String cafeName;

  CafeMarker({
    required this.point,
    required this.cafeName,
  }) : super(
          point: point,
          width: 192,
          rotate: true,
          alignment: Alignment.bottomRight, //Bottom Right (1,1)
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
                  color: CafeAppUI.cafeMarkerColor,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cafeName,
                    style: const TextStyle(
                      fontFamily: "Monospace",
                      fontWeight: FontWeight.bold,
                      fontSize: 8,
                      color: CafeAppUI.secondaryColor,
                    ),
                  ),
                  const Text(
                    'Cafe',
                    style: TextStyle(
                      fontFamily: "Monospace",
                      fontWeight: FontWeight.bold,
                      fontSize: 8,
                      color: CafeAppUI.secondaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
}
