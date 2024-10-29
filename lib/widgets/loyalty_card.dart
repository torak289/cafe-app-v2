import 'package:barcode_widget/barcode_widget.dart';
import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/constants/routes.dart';
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
      width: 86 * 4,
      height: 40 * 4,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/Cafe_Logo.png', scale: 6),
                const Text(
                  'Coffee bought: 400',
                  textAlign: TextAlign.left,
                ),
                Text(
                  '${user.email}',
                  textAlign: TextAlign.left,
                ),
              ],
            ),
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
