import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';

class CafeMarker extends Marker {
  @override
  final LatLng point;
  final String cafeName;
  final AnimatedMapController mapController;

  CafeMarker(
      {required this.point,
      required this.cafeName,
      required this.mapController})
      : super(
          point: point,
          rotate: true,
          alignment: Alignment.topCenter, //Bottom Right (1,1)
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  debugPrint("On Tap");
                },
                onDoubleTap: () {
                  mapController.animateTo(dest: point, zoom: 16);
                },
                child: const Expanded(
                  child: Icon(
                    Icons.location_on_sharp,
                    color: CafeAppUI.cafeMarkerColor,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
