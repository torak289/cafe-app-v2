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
  bool? laptopFriendly;
  bool? hasWifi;
  final formKey = GlobalKey<FormState>();
  TextEditingController contentTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    DatabaseService databaseService =
        Provider.of<DatabaseService>(context, listen: false);

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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Is this Cafe Laptop Friendly? ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Checkbox(
                            tristate: true,
                            value: laptopFriendly,
                            onChanged: (value) {
                              setState(() {
                                laptopFriendly = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Does this Cafe have WiFi? ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Checkbox(
                            tristate: true,
                            value: hasWifi,
                            onChanged: (value) {
                              setState(() {
                                hasWifi = value;
                              });
                            },
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
                        controller: contentTextController,
                        minLines: 10,
                        maxLines: 10,
                        maxLength: 256,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.5),
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.5),
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.pinkAccent, width: 1.5),
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: CafeAppUI.errorText, width: 1.5),
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.5),
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
                                "Oops! Please rate all categories with at least 1 star before submitting.",
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
                              });
                              return;
                            }
                            try {
                              bool success = await databaseService.reviewCafe(
                                widget.cafe.uid!,
                                widget.coffeeRating,
                                widget.atmosphereRating,
                                widget.serviceRating,
                                hasWifi,
                                laptopFriendly,
                                contentTextController.text.trim(),
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
