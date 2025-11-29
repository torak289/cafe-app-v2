import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

class IndividualReview extends StatelessWidget {
  const IndividualReview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
        border: BoxBorder.all(
          color: Colors.black,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: [
            Text(
              '28th Nov 2025',
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry
                  .all(CafeAppUI
                      .buttonSpacingMedium),
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
              children: [
                Text('Coffee: '),
                StarRating(
                  allowHalfRating: true,
                  starCount: 5,
                  rating: 2,
                  size: 24,
                  color: Colors.black,
                  borderColor:
                      Colors.black,
                ),
              ],
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
              children: [
                Text('Service: '),
                StarRating(
                  allowHalfRating: true,
                  starCount: 5,
                  rating: 4,
                  size: 24,
                  color: Colors.black,
                  borderColor:
                      Colors.black,
                ),
              ],
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
              children: [
                Text('Atmosphere: '),
                StarRating(
                  allowHalfRating: true,
                  starCount: 5,
                  rating: 5,
                  size: 24,
                  color: Colors.black,
                  borderColor:
                      Colors.black,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsetsGeometry
                  .all(CafeAppUI
                      .buttonSpacingMedium),
            ),
            Text(
              'Review',
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            Text(
              'I had a great coffee and pastry here. I tried a new Almond & Chocolate Croissant I have not had before. I highly recommend if it is available when you go!',
              overflow:
                  TextOverflow.ellipsis,
                  maxLines: 3,
            )
          ],
        ),
      ),
    );
  }
}