import 'package:barcode_widget/barcode_widget.dart';
import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/data_models/loyalty_card_model.dart';
import 'package:cafeapp_v2/data_models/user_model.dart';
import 'package:cafeapp_v2/services/auth_service.dart';
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
    final UserModel user = Provider.of(context, listen: false);

    double tableHeight = 40;

    return FutureBuilder<List<LoyaltyCardModel>>(
      //TODO: Change to Loyalty Model
      future: database.getLoyaltyData(),
      builder: (context, future) {
        if (future.hasData) {
          if (future.data!.isNotEmpty) {
            List<TableRow> widgets = List.empty(growable: true);

            for (int i = 0; i < future.data!.length; i++) {
              widgets.add(
                TableRow(
                  decoration: BoxDecoration(
                    border: (i != future.data!.length - 1)
                        ? const Border(
                            bottom: BorderSide(width: 1.5),
                          )
                        : const Border(),
                  ),
                  children: [
                    //TODO: Implement padding on TableRow...
                    SizedBox(
                        height: tableHeight,
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(future.data![i].cafeName))),
                    SizedBox(
                      height: tableHeight,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          future.data![i].currentCount.toString(),
                        ),
                      ),
                    ),
                    future.data![i].hasCoffeeClaim
                        ? SizedBox(
                            height: tableHeight,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => showDialog<String>(
                                    //TODO: Implement Async Stream to listen to database events fired on Scan from Cafe Account...
                                    //TODO: Implement this for both available QR Codes...
                                    //TODO: Pop context and update UI state on Scan...
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                ' ${future.data![i].cafeName}, Claim your coffee!', //TODO: Reword text...
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Padding(
                                                  padding: EdgeInsets.all(
                                                      CafeAppUI
                                                          .buttonSpacingMedium)),
                                              BarcodeWidget(
                                                data: user.uid,
                                                barcode: Barcode.qrCode(),
                                                width: 200,
                                                height: 200,
                                              ),
                                            ],
                                          ),
                                        )),
                                child: const Text('Claim'),
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 40,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                future.data![i].totalCount.toString(),
                              ),
                            ),
                          ),
                  ],
                ),
              );
            }
            return Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                      padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Cafe",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Current Count",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Total Count",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Padding(
                      padding: EdgeInsets.all(CafeAppUI.buttonSpacingSmall)),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Table(
                        children: widgets,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Expanded(
              child: Column(
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
              ),
            );
          }
        } else {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          );
        }
      },
    );
  }
}
