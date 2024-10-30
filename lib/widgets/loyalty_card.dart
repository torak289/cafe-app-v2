import 'package:barcode_widget/barcode_widget.dart';
import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/data_models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoyaltyCard extends StatelessWidget {
  const LoyaltyCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserModel>(context, listen: false);
    return Container(
      decoration: const BoxDecoration(
        color: CafeAppUI.backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: CafeAppUI.buttonShadowColor,
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${user.email}'),
                  Table(
                    children: const [
                      TableRow(
                        children: [Text("Stat"), Text("Data")],
                      ),
                      TableRow(
                        children: [Text("Stat"), Text("Data")],
                      ),
                      TableRow(
                        children: [Text("Stat"), Text("Data")],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.all(8)),
            BarcodeWidget(
              data: user.uid,
              barcode: Barcode.qrCode(),
              width: 120,
              height: 120,
            ),
          ],
        ),
      ),
    );
  }
}
