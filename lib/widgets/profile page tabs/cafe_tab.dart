import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/constants/routes.dart';
import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:cafeapp_v2/data_models/coffee_model.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:cafeapp_v2/utils/systemui_utils.dart';
import 'package:cafeapp_v2/widgets/profile%20page%20tabs/edit_large_text_field.dart';
import 'package:cafeapp_v2/widgets/profile%20page%20tabs/editable_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CafeTab extends StatefulWidget {
  const CafeTab({super.key});

  @override
  State<CafeTab> createState() => _CafeTabState();
}

class _CafeTabState extends State<CafeTab> {
  @override
  Widget build(BuildContext context) {
    final DatabaseService database =
        Provider.of<DatabaseService>(context, listen: false);

    Future<List<CafeModel>> databaseFuture = database.getCafeData();

    void callbackState() {
      setState(() {
        databaseFuture = database.getCafeData();
      });
    }

    return FutureBuilder<List<CafeModel>>(
      future: databaseFuture,
      builder: (context, cafeData) {
        if (cafeData.hasData) {
          if (cafeData.data!.isNotEmpty) {
            return Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                        padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        EditableCafeNameField(
                          cafe: cafeData.data![0],
                          callback: callbackState,
                        ),
                      ],
                    ),
                    const Padding(
                        padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                    const Text(
                      "Description",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Padding(
                        padding: EdgeInsets.all(CafeAppUI.buttonSpacingSmall)),
                    EditLargeTextField(
                      cafe: cafeData.data![0],
                      callback: callbackState,
                    ),
                    const Padding(
                        padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                    const Text(
                      'Loyalty Card',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Padding(
                        padding: EdgeInsets.all(CafeAppUI.buttonSpacingSmall)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Text('Coffee Count'),
                            Padding(padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                            Tooltip(
                              //TODO: Move styling into theme
                              margin: EdgeInsets.all(32),
                              triggerMode: TooltipTriggerMode.tap,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 4,
                                  )
                                ],
                              ),
                              padding: EdgeInsets.all(16),
                              textStyle: TextStyle(color: Colors.black),
                              message:
                                  'This is the number of Coffees that a user has to purchase for a free coffee!',
                              child: Icon(
                                Icons.info_outline_rounded,
                                color: Colors.black,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            (cafeData.data![0].claimAmount != -1) ? Text(cafeData.data![0].claimAmount
                                .toString()) : const Text("N/A"), //TODO: Implement claim amount
                            const Padding(padding: EdgeInsets.all(8)),
                            const Icon(
                              Icons.edit_rounded,
                              color: Colors.black,
                              size: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Padding(
                        padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Coffees',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: null,
                          child: const Icon(
                            Icons.edit_rounded,
                            size: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                        padding: EdgeInsets.all(CafeAppUI.buttonSpacingSmall)),
                    FutureBuilder<List<CoffeeModel>>(
                        future: database.getCoffeeList(),
                        builder: (context, coffeesData) {
                          if (coffeesData.hasData) {
                            List<Widget> list = List.empty(growable: true);
                            Color color = Colors.white;
                            for (int i = 0; i < coffeesData.data!.length; i++) {
                              for (int j = 0;
                                  j < cafeData.data![0].coffees!.length;
                                  j++) {
                                if (cafeData.data![0].coffees![j] ==
                                    coffeesData.data![i].name) {
                                  color = Colors.pinkAccent;
                                  break;
                                } else {
                                  color = CafeAppUI.buttonBackgroundColor;
                                }
                              }
                              list.add(
                                TextButton(
                                  onPressed: null,
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll(color),
                                  ),
                                  child: Text(
                                    coffeesData.data![i].name,
                                    style: const TextStyle(
                                      color: CafeAppUI.primaryColor,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio: (140/24),
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: list,
                            );
                          } else {
                            return const Center(
                              child: Text("Error"),
                            );
                          }
                        }),
                    const Padding(
                        padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                    const Text(
                      'Locations',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Builder(
                      //TODO: Implement business logic for locations
                      builder: (context) {
                        return Text(cafeData.data![0].location.toString());
                      },
                    ),
                    Builder(
                      builder: (context) {
                        if (!cafeData.data![0].verified!) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Padding(
                                  padding: EdgeInsets.all(
                                      CafeAppUI.buttonSpacingMedium)),
                              const Text(
                                "Verify your Cafe!",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const Padding(
                                  padding: EdgeInsets.all(
                                      CafeAppUI.buttonSpacingSmall)),
                              cafeData.data![0].verificationRequested
                                  ? const Text(
                                      "Verification Pending! Please wait for us to review your request.")
                                  : TextButton(
                                      onPressed: () async {
                                        bool res =
                                            await database.requestVerification(
                                                cafeData.data![0].uid!);
                                        if (res) {
                                          setState(() {});
                                        }
                                      },
                                      child: const Text("Verify"),
                                    ),
                            ],
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Own a Cafe? Add it to our map!"),
                  const Padding(
                      padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      Routes.addCafePage,
                      arguments: AddCafeArgs(
                        isOwner: true,
                      ),
                    ),
                    child: const Text("Add Cafe"),
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
