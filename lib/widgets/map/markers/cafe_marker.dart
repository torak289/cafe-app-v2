import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:cafeapp_v2/utils/cafeapp_utils.dart';
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:cafeapp_v2/widgets/map/markers/rating_popup.dart';

class CafeMarker extends Marker {
  final CafeModel cafe;
  final AnimatedMapController mapController;
  final BuildContext context;

  CafeMarker(
      {required this.cafe, required this.mapController, required this.context})
      : super(
          width: 200,
          height: 22,
          point: cafe.location,
          rotate: true,
          alignment: const Alignment(0.88, -1), //TODO: This works-ish...
          child: Row(
            children: [
              GestureDetector(
                onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Center(
                              child: Text(
                                  cafe.name != null ? cafe.name! : "NO NAME")),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                children: [
                                  StarRating(
                                    size: 32,
                                    color: CafeAppUI.iconButtonIconColor,
                                    borderColor: CafeAppUI.iconButtonIconColor,
                                    starCount: 5,
                        
                                    rating:
                                        cafe.rating != null ? cafe.rating! : 0,
                                  ),
                                  Text(cafe.rating != null
                                      ? '(${cafe.rating!})'
                                      : '(No Rating)'),
                                ],
                              ),
                              Builder(builder: (context) {
                                if (cafe.description != null ||
                                    cafe.description!.isEmpty) {
                                  return Column(
                                    children: [
                                      Padding(
                                          padding: EdgeInsetsGeometry.all(
                                              CafeAppUI.buttonSpacingMedium)),
                                      Text(cafe.description!),
                                    ],
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              })
                            ],
                          ),
                          actionsAlignment: MainAxisAlignment.center,
                          actionsOverflowAlignment: OverflowBarAlignment.center,
                          actions: [
                            TextButton(
                                onPressed: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          rating_popup(
                                        cafe: cafe,
                                      ),
                                    ),
                                child: Text('Review')),
                            TextButton(
                                onPressed: () async {
                                  CafeappUtils.launchMap(cafe.location);
                                },
                                child: Text('Navigate')),
                          ], //TODO: Null because not fetched from DB???
                        )),
                onDoubleTap: () {
                  mapController.animateTo(
                    dest: cafe.location,
                    zoom: 16,
                  );
                },
                onLongPress: () async {
                  CafeappUtils.launchMap(cafe.location);
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
                      cafe.verified!
                          ? const Icon(
                              Icons.verified,
                              color: Colors.pinkAccent,
                              size: 8,
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
}
