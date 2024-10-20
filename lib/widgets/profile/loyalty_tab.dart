import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/data_models/loyalty_card_model.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoyaltyTab extends StatelessWidget {
  const LoyaltyTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DatabaseService database = Provider.of(context, listen: false);
    return FutureBuilder<List<LoyaltyCardModel>>(
      //TODO: Change to Loyalty Model
      future: database.getLoyaltyData(),
      builder: (context, future) {
        if (future.hasData) {
          if (future.data!.isNotEmpty) {
            List<Widget> widgets = List.empty(growable: true);
            widgets.add(
              const Padding(
                  padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
            );
            widgets.add(
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text("Cafe"),
                Text("Current Count"),
                Text("Total Count")
              ],)
            );
            widgets.add(
              const Padding(
                  padding: EdgeInsets.all(CafeAppUI.buttonSpacingSmall)),
            );
            for (int i = 0; i < future.data!.length; i++) {
              widgets.add(Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(future.data![i].cafeName),
                  Text(future.data![i].currentCount.toString()),
                  Text(future.data![i].totalCount.toString()),
                ],
              ));
            }
            return Column(
              children: widgets,
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "You don’t have any loyalty points. Visit a cafe near you!",
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'Find a cafe near you!',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        }
      },
    );
  }
}
