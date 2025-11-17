import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:cafeapp_v2/enum/app_states.dart';
import 'package:cafeapp_v2/services/auth_service.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:cafeapp_v2/utils/cafeapp_utils.dart';
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:cafeapp_v2/widgets/map/markers/rating_popup.dart';
import 'package:provider/provider.dart';

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
                  builder: (BuildContext context) {
                    DatabaseService databaseService =
                        Provider.of<DatabaseService>(context, listen: false);
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: Center(
                          child: Text(
                        cafe.name != null ? cafe.name! : "NO NAME",
                        textAlign: TextAlign.center,
                      )),
                      content: FutureBuilder(
                          future: databaseService.getCafeData(cafe.uid!),
                          builder: (BuildContext context, future) {
                            if (future.hasData) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Builder(builder: (context) {
                                      if (future.data!.totalReviews! > 0) {
                                        return Column(
                                          children: [
                                            StarRating(
                                              size: 32,
                                              color:
                                                  CafeAppUI.iconButtonIconColor,
                                              borderColor:
                                                  CafeAppUI.iconButtonIconColor,
                                              starCount: 5,
                                              rating:
                                                  future.data!.rating != null
                                                      ? future.data!.rating!
                                                          .round()
                                                          .toDouble()
                                                      : 0.0,
                                            ),
                                            Text(
                                                "${future.data!.rating?.round()}/5 from ${future.data!.totalReviews} reviews"), //This rounding needs to be improved... currently it rounds to .5 or .0
                                          ],
                                        );
                                      } else {
                                        return Text(
                                          'No Rating',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        );
                                      }
                                    }),
                                    Builder(builder: (context) {
                                      if (future.data!.description != null ||
                                          future.data!.description!.isEmpty) {
                                        return Column(
                                          children: [
                                            Padding(
                                                padding: EdgeInsetsGeometry.all(
                                                    CafeAppUI
                                                        .buttonSpacingMedium)),
                                            Text(
                                              future.data!.description!,
                                              textAlign: TextAlign.justify,
                                            ),
                                          ],
                                        );
                                      } else {
                                        return SizedBox.shrink();
                                      }
                                    }),
                                    Padding(
                                        padding: EdgeInsetsGeometry.all(
                                            CafeAppUI.buttonSpacingMedium)),
                                    Chip(
                                      label: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Laptop Friendly'),
                                          Builder(
                                            builder: (BuildContext context) {
                                              if (future.data!.isLaptopFriendly !=
                                                  null) {
                                                return future.data!.isLaptopFriendly!
                                                    ? Icon(
                                                        Icons.check_rounded,
                                                        color: CafeAppUI
                                                            .iconButtonIconColor,
                                                      )
                                                    : Icon(
                                                        Icons.close_rounded,
                                                        color: CafeAppUI
                                                            .iconButtonIconColor,
                                                      );
                                              } else {
                                                return Icon(
                                                  Icons.question_mark_rounded,
                                                  color: CafeAppUI
                                                      .iconButtonIconColor,
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Chip(
                                      label: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('WiFi'),
                                          Builder(
                                            builder: (BuildContext context) {
                                              if (future.data!.hasWifi !=
                                                  null) {
                                                return future.data!.hasWifi!
                                                    ? Icon(
                                                        Icons.check_rounded,
                                                        color: CafeAppUI
                                                            .iconButtonIconColor,
                                                      )
                                                    : Icon(
                                                        Icons.close_rounded,
                                                        color: CafeAppUI
                                                            .iconButtonIconColor,
                                                      );
                                              } else {
                                                return Icon(
                                                  Icons.question_mark_rounded,
                                                  color: CafeAppUI
                                                      .iconButtonIconColor,
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(
                                    color: CafeAppUI.iconButtonIconColor,
                                  ),
                                ],
                              );
                            }
                          }),
                      actionsAlignment: MainAxisAlignment.center,
                      actionsOverflowAlignment: OverflowBarAlignment.center,
                      actions: [
                        Builder(builder: (BuildContext context) {
                          AuthService authService =
                              Provider.of<AuthService>(context, listen: false);
                          if (authService.appState == AppState.Authenticated) {
                            return TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        rating_popup(
                                      cafe: cafe,
                                    ),
                                  );
                                },
                                child: Text('Review'));
                          } else {
                            return SizedBox.shrink();
                          }
                        }),
                        TextButton(
                            onPressed: () async {
                              CafeappUtils.launchMap(cafe.location);
                            },
                            child: Text('Navigate')),
                      ], //TODO: Null because not fetched from DB???
                    );
                  },
                ),
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
