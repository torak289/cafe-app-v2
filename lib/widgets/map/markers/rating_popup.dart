import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

class rating_popup extends StatefulWidget {
  rating_popup({
    super.key,
    required this.cafe,
  });
  CafeModel cafe;
  double rating = 1;
  @override
  State<rating_popup> createState() => _rating_popupState();
}

class _rating_popupState extends State<rating_popup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text('Rate ${widget.cafe.name}'),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StarRating(
            size: 32,
            rating: widget.rating,
            allowHalfRating: false,
            color: CafeAppUI.iconButtonIconColor,
            borderColor: CafeAppUI.iconButtonIconColor,
            onRatingChanged: (rating) => setState(() {
              widget.rating = rating;
            }),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(onPressed: null, child: Text('Review')),
      ],
    );
  }
}
