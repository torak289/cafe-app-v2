import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:provider/provider.dart';

class rating_popup extends StatefulWidget {
  rating_popup({
    super.key,
    required this.cafe,
  });
  CafeModel cafe;
  double coffeeRating = 0;
  double atmosphereRating = 0;
  double serviceRating = 0;

  @override
  State<rating_popup> createState() => _rating_popupState();
}

class _rating_popupState extends State<rating_popup> {
  @override
  Widget build(BuildContext context) {
    DatabaseService databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    return DraggableScrollableSheet(
        //initialChildSize: 1,
        expand: false,
        builder: (context, scrollController) {
          return SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                32,
                16,
                48,
                48,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      'Rate ${widget.cafe.name}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsGeometry.all(CafeAppUI.buttonSpacingMedium),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Coffee: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      StarRating(
                        size: 32,
                        rating: widget.coffeeRating,
                        allowHalfRating: false,
                        color: CafeAppUI.iconButtonIconColor,
                        borderColor: CafeAppUI.iconButtonIconColor,
                        onRatingChanged: (rating) => setState(() {
                          widget.coffeeRating = rating;
                        }),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsetsGeometry.all(CafeAppUI.buttonSpacingSmall),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Service: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      StarRating(
                        size: 32,
                        rating: widget.serviceRating,
                        allowHalfRating: false,
                        color: CafeAppUI.iconButtonIconColor,
                        borderColor: CafeAppUI.iconButtonIconColor,
                        onRatingChanged: (rating) => setState(() {
                          widget.serviceRating = rating;
                        }),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsetsGeometry.all(CafeAppUI.buttonSpacingSmall),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Atmosphere: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      StarRating(
                        size: 32,
                        rating: widget.atmosphereRating,
                        allowHalfRating: false,
                        color: CafeAppUI.iconButtonIconColor,
                        borderColor: CafeAppUI.iconButtonIconColor,
                        onRatingChanged: (rating) => setState(
                          () {
                            widget.atmosphereRating = rating;
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsetsGeometry.all(CafeAppUI.buttonSpacingLarge),
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        bool success = await databaseService.reviewCafe(
                          widget.cafe.uid!,
                          widget.coffeeRating,
                          widget.atmosphereRating,
                          widget.serviceRating,
                        );
                        debugPrint('On Pressed Review: $success');
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    },
                    child: Text('Review'),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
