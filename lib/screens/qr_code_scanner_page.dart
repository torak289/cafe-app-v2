import 'package:cafeapp_v2/constants/cafe_app_ui.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class QrCodeScannerPage extends StatefulWidget {
  QrCodeScannerPage({super.key});

  @override
  State<QrCodeScannerPage> createState() => _QrCodeScannerPageState();
}

class _QrCodeScannerPageState extends State<QrCodeScannerPage> {
  String qrCode = "";
  int coffeeCount = 1;
  @override
  Widget build(BuildContext context) {
    MobileScannerController mobileScannerController = MobileScannerController(
      autoStart: true,
      //detectionSpeed: DetectionSpeed.noDuplicates,
      formats: [BarcodeFormat.qrCode],
    );
    final DatabaseService database =
        Provider.of<DatabaseService>(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: CafeAppUI.screenVertical,
            horizontal: CafeAppUI.screenHorizontal),
        child: Builder(builder: (context) {
          if (qrCode.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  "Scan customer QR code",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Padding(padding: EdgeInsets.all(8)),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 250,
                    width: 250,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: const BoxDecoration(
                      color: Colors.pinkAccent,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: MobileScanner(
                      controller: mobileScannerController,
                      overlayBuilder: (context, constraints) {
                        return Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.pinkAccent,
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                          ),
                        );
                      },
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        RegExp uuid = RegExp(
                            "[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}");
                        for (final barcode in barcodes) {
                          if (uuid.hasMatch(barcode.rawValue!)) {
                            database.validateLoyaltyCode(barcode.rawValue!,
                                coffeeCount); //TODO: Implement debounce
                            setState(() {
                              qrCode = barcode.rawValue!;
                            });
                          }
                        }
                      },
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(40)),
                const Text('How many coffees?'),
                const Padding(padding: EdgeInsets.all(8)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          if (coffeeCount > 1) {
                            coffeeCount--;
                          }
                        });
                      },
                      child: const Icon(Icons.arrow_left_rounded),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        '$coffeeCount',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            if (coffeeCount < 6) {
                              coffeeCount++;
                            }
                          });
                        },
                        child: const Icon(Icons.arrow_right_rounded)),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(32)),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 32,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(child: Text("QR Code scanned!")),
                const Padding(padding: EdgeInsets.all(8)),
                FutureBuilder(
                  future: null,
                  builder: (context, data) {
                    if (data.hasData) {
                      return Container();
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      );
                    }
                  },
                )
              ],
            );
          }
        }),
      ),
    );
  }
}
