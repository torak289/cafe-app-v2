import 'package:cafeapp_v2/constants/cafe_app_ui.dart';
import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:cafeapp_v2/enum/app_states.dart';
import 'package:cafeapp_v2/services/auth_service.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:cafeapp_v2/utils/cafeapp_utils.dart';
import 'package:cafeapp_v2/widgets/map/markers/rating_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:provider/provider.dart';

class CafeOverview extends StatelessWidget {
  const CafeOverview({
    super.key,
    required this.databaseService,
    required this.cafe,
  });

  final DatabaseService databaseService;
  final CafeModel cafe;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1,
      expand: false,
      builder: (context, scrollController) {
        return SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            controller: scrollController,
            child: FutureBuilder(
              future: databaseService.getCafeData(cafe.uid!),
              builder: (BuildContext context, future) {
                if (future.hasData) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(
                      32,
                      16,
                      48,
                      48,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            cafe.name != null ? cafe.name! : "NO NAME",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsGeometry.all(
                              CafeAppUI.buttonSpacingMedium),
                        ),
                        Builder(builder: (context) {
                          if (future.data!.totalReviews! > 0) {
                            return Column(
                              children: [
                                StarRating(
                                  size: 32,
                                  color: CafeAppUI.iconButtonIconColor,
                                  borderColor: CafeAppUI.iconButtonIconColor,
                                  starCount: 5,
                                  rating: future.data!.rating != null
                                      ? future.data!.rating!.toDouble()
                                      : 0.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${future.data!.rating?.toStringAsFixed(1)}/5 from ${future.data!.totalReviews} reviews", //TODO: Implement whole number trim of .0
                                    ),
                                    Padding(
                                      padding: EdgeInsetsGeometry.all(
                                          CafeAppUI.buttonSpacingSmall),
                                    ),
                                    Tooltip(
                                      message:
                                          'This is the average across all reviews. The average is calculated based on 3 factors, Coffee, Atmosphere & Service.',
                                      child: Icon(
                                        Icons.info_outline_rounded,
                                        color: Colors.black,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return Text(
                              'No Rating',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            );
                          }
                        }),
                        Builder(builder: (context) {
                          if (future.data!.description != null ||
                              future.data!.description!.isEmpty) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsetsGeometry.all(
                                      CafeAppUI.buttonSpacingMedium),
                                ),
                                Text(
                                  'About',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(padding: EdgeInsetsGeometry.all(1)),
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
                            CafeAppUI.buttonSpacingMedium,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: BoxBorder.all(
                              color: Colors.black,
                              width: 1.5,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: ExpansionTile(
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                              tilePadding: EdgeInsets.fromLTRB(
                                12,
                                0,
                                12,
                                0,
                              ),
                              iconColor: Colors.black,
                              collapsedIconColor: Colors.black,
                              childrenPadding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              minTileHeight: 0,
                              collapsedShape: BoxBorder.all(
                                color: Colors.transparent,
                                width: 0,
                              ),
                              shape: BoxBorder.all(
                                color: Colors.transparent,
                                width: 0,
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Opening Times',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'Open Now',
                                    style: TextStyle(
                                      color: Colors.pinkAccent,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Monday'),
                                    Text('10:00 - 17:00'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Tuesday'),
                                    Text('10:00 - 17:00'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Wednesday'),
                                    Text('10:00 - 17:00'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Thursday'),
                                    Text('10:00 - 17:00'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Friday'),
                                    Text('10:00 - 17:00'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Saturday'),
                                    Text('10:00 - 17:00'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Sunday'),
                                    Text('10:00 - 17:00'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsetsGeometry.all(1)),
                        Chip(
                          label: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Laptop Friendly'),
                              Builder(
                                builder: (BuildContext context) {
                                  if (future.data!.isLaptopFriendly != null) {
                                    return future.data!.isLaptopFriendly!
                                        ? Icon(
                                            Icons.check_rounded,
                                            color:
                                                CafeAppUI.iconButtonIconColor,
                                          )
                                        : Icon(
                                            Icons.close_rounded,
                                            color:
                                                CafeAppUI.iconButtonIconColor,
                                          );
                                  } else {
                                    return Icon(
                                      Icons.question_mark_rounded,
                                      color: CafeAppUI.iconButtonIconColor,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Chip(
                          label: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('WiFi'),
                              Builder(
                                builder: (BuildContext context) {
                                  if (future.data!.hasWifi != null) {
                                    return future.data!.hasWifi!
                                        ? Icon(
                                            Icons.check_rounded,
                                            color:
                                                CafeAppUI.iconButtonIconColor,
                                          )
                                        : Icon(
                                            Icons.close_rounded,
                                            color:
                                                CafeAppUI.iconButtonIconColor,
                                          );
                                  } else {
                                    return Icon(
                                      Icons.question_mark_rounded,
                                      color: CafeAppUI.iconButtonIconColor,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsGeometry.all(
                              CafeAppUI.buttonSpacingLarge),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Builder(builder: (BuildContext context) {
                              AuthService authService =
                                  Provider.of<AuthService>(context,
                                      listen: false);
                              if (authService.appState ==
                                  AppState.Authenticated) {
                                return TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      showModalBottomSheet<void>(
                                        showDragHandle: true,
                                        context: context,
                                        useSafeArea: true,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) =>
                                            rating_popup(
                                          cafe: cafe,
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Review'),
                                        Padding(
                                            padding: EdgeInsetsGeometry.all(2)),
                                        Icon(Icons.star_rounded)
                                      ],
                                    ));
                              } else {
                                return SizedBox.shrink();
                              }
                            }),
                            Padding(
                              padding: EdgeInsetsGeometry.all(
                                  CafeAppUI.buttonSpacingMedium),
                            ),
                            TextButton(
                              onPressed: () async {
                                CafeappUtils.launchMap(cafe.location);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Goto'),
                                  Padding(padding: EdgeInsetsGeometry.all(3)),
                                  Icon(Icons.assistant_navigation),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: CafeAppUI.iconButtonIconColor,
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
