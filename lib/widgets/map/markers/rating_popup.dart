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
  bool showError = false;

  @override
  State<rating_popup> createState() => _rating_popupState();
}

class _rating_popupState extends State<rating_popup> {
  @override
  Widget build(BuildContext context) {
    DatabaseService databaseService =
        Provider.of<DatabaseService>(context, listen: false);

    final formKey = GlobalKey<FormState>();

    return DraggableScrollableSheet(
        initialChildSize: 1,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  32,
                  16,
                  48,
                  48,
                ),
                child: Form(
                  key: formKey,
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
                        padding: EdgeInsetsGeometry.all(
                            CafeAppUI.buttonSpacingMedium),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Coffee: ',
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
                        padding: EdgeInsetsGeometry.all(
                            CafeAppUI.buttonSpacingSmall),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Service: ',
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
                        padding: EdgeInsetsGeometry.all(
                            CafeAppUI.buttonSpacingSmall),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Atmosphere: ',
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
                        padding: EdgeInsetsGeometry.all(
                            CafeAppUI.buttonSpacingMedium),
                      ),
                      Row(
                        children: [
                          const Text(
                            'Review ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            ' Optional',
                            style: TextStyle(
                              color: Colors.pinkAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.all(
                            CafeAppUI.buttonSpacingSmall),
                      ),
                      TextFormField(
                        minLines: 10,
                        maxLines: 10,
                        maxLength: 256,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                        ),
                      ),
                      Builder(builder: (context) {
                        if (widget.showError) {
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsetsGeometry.all(
                                    CafeAppUI.buttonSpacingMedium),
                              ),
                              Text(
                                "You must review the Cafe! We don't submit 0 Stars",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: CafeAppUI.errorText,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.all(
                                    CafeAppUI.buttonSpacingLarge),
                              ),
                            ],
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsetsGeometry.all(
                                CafeAppUI.buttonSpacingLarge),
                          );
                        }
                      }),
                      TextButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            if (widget.atmosphereRating < 1 ||
                                widget.coffeeRating < 1 ||
                                widget.serviceRating < 1) {
                              setState(() {
                                widget.showError = true;
                                debugPrint(
                                    "You must review the cafe! We don't submit 0 Stars");
                              });
                              return;
                            }
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
                          }
                        },
                        child: Text('Review'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
