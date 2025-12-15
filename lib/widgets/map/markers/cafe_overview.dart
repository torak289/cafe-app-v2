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
                // Use fetched data if available, otherwise fall back to marker data
                final displayCafe = future.hasData ? future.data! : cafe;
                final isOffline = future.hasError ||
                    (!future.hasData &&
                        future.connectionState == ConnectionState.done);

                if (future.connectionState == ConnectionState.waiting &&
                    cafe.rating == null) {
                  // Only show spinner if we have no data at all
                  return Center(
                    child: CircularProgressIndicator(
                      color: CafeAppUI.iconButtonIconColor,
                    ),
                  );
                }

                // Display cafe data (from detailed fetch or fallback to marker data)
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
                      // Show offline indicator if using cached data
                      if (isOffline)
                        Chip(
                          label: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Offline - Showing cached data',
                              ),
                              Icon(Icons.wifi_off,
                                  size: 18, color: CafeAppUI.secondaryText),
                            ],
                          ),
                        ),
                      Center(
                        child: Text(
                          displayCafe.name != null
                              ? displayCafe.name!
                              : "NO NAME",
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
                        if (displayCafe.totalReviews != null &&
                            displayCafe.totalReviews! > 0) {
                          return Column(
                            children: [
                              StarRating(
                                size: 32,
                                color: CafeAppUI.iconButtonIconColor,
                                borderColor: CafeAppUI.iconButtonIconColor,
                                starCount: 5,
                                rating: displayCafe.rating != null
                                    ? displayCafe.rating!.toDouble()
                                    : 0.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${displayCafe.rating?.toStringAsFixed(1)}/5 from ${displayCafe.totalReviews} reviews", //TODO: Implement whole number trim of .0
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
                          return Center(
                            child: Text(
                              'No Rating',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                      }),
                      Builder(builder: (context) {
                        if (displayCafe.description != null &&
                            displayCafe.description!.isNotEmpty) {
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
                                displayCafe.description!,
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
                      Chip(
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Laptop Friendly'),
                            Builder(
                              builder: (BuildContext context) {
                                if (displayCafe.isLaptopFriendly != null) {
                                  return displayCafe.isLaptopFriendly!
                                      ? Icon(
                                          Icons.check_rounded,
                                          color: CafeAppUI.iconButtonIconColor,
                                        )
                                      : Icon(
                                          Icons.close_rounded,
                                          color: CafeAppUI.iconButtonIconColor,
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
                                if (displayCafe.hasWifi != null) {
                                  return displayCafe.hasWifi!
                                      ? Icon(
                                          Icons.check_rounded,
                                          color: CafeAppUI.iconButtonIconColor,
                                        )
                                      : Icon(
                                          Icons.close_rounded,
                                          color: CafeAppUI.iconButtonIconColor,
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
                            AuthService authService = Provider.of<AuthService>(
                                context,
                                listen: false);
                            if (authService.appState ==
                                    AppState.Authenticated &&
                                !isOffline) {
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
              },
            ),
          ),
        );
      },
    );
  }
}
