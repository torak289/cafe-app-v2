import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:maps_launcher/maps_launcher.dart';

class CafeMarker extends Marker {
  final CafeModel cafe;
  final AnimatedMapController mapController;

  CafeMarker({required this.cafe, required this.mapController})
      : super(
          width: 200,
          point: cafe.location,
          rotate: true,
          alignment: Alignment
              .topRight, //This needs work to rotate around the marker point properly...
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  debugPrint(cafe.uid);
                },
                onDoubleTap: () {
                  mapController.animateTo(
                    dest: cafe.location,
                    zoom: 16,
                  );
                },
                onLongPress: (() {
                  MapsLauncher.launchCoordinates(cafe.location.latitude, cafe.location.longitude);
                }),
                child: const Icon(
                  Icons.location_on_sharp,
                  color: CafeAppUI.cafeMarkerColor,
                  size: 20,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    cafe.name.toString(),
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
