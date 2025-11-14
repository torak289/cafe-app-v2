import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:provider/provider.dart';

class rating_popup extends StatefulWidget {
  rating_popup({
    super.key,
    required this.cafe,
  });
  CafeModel cafe;
  double rating = 0;
  @override
  State<rating_popup> createState() => _rating_popupState();
}

class _rating_popupState extends State<rating_popup> {
  @override
  Widget build(BuildContext context) {
    DatabaseService databaseService =
        Provider.of<DatabaseService>(context, listen: false);
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
        TextButton(
            onPressed: () async {
              try {
                bool success = await databaseService.reviewCafe(
                    widget.cafe.uid!, widget.rating);
                debugPrint('On Pressed Review: $success');
                if (context.mounted) {
                  Navigator.pop(context);
                }
              } catch (e) {
                debugPrint(e.toString());
              }
            },
            child: Text('Review')),
      ],
    );
  }
}
