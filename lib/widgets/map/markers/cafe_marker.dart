import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';

class CafeMarker extends Marker {
  final CafeModel cafe;
  final AnimatedMapController mapController;

  CafeMarker({required this.cafe, required this.mapController})
      : super(
          width: 200,
          height: 22,
          point: cafe.location,
          rotate: true,
          alignment: const Alignment(0.88, -1), //TODO: This works-ish...
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
                child: const Icon(
                  Icons.location_on_sharp,
                  color: CafeAppUI.cafeMarkerColor,
                  size: 22,
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
                  Row(
                    children: [
                      const Text(
                        'Cafe',
                        style: TextStyle(
                          fontFamily: "Monospace",
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                          color: CafeAppUI.secondaryColor,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(2)),
                      cafe.verified! ? 
                      const Icon(
                        Icons.verified,
                        color: Colors.pinkAccent,
                        size: 8,
                      ) : const SizedBox.shrink(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
}
