import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/constants/routes.dart';
import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:cafeapp_v2/data_models/coffee_model.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CafeTab extends StatelessWidget {
  const CafeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseService database =
        Provider.of<DatabaseService>(context, listen: false);
    return FutureBuilder<List<CafeModel>>(
      future: database.getCafeData(),
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
                        Row(
                          children: [
                            Text('${cafeData.data![0].name}'),
                            const Padding(padding: EdgeInsets.all(8)),
                            GestureDetector(
                              onTap: () async {
                                //TODO: Implement Edit UI state change for name
                                debugPrint(await database.editCafeName('_'));
                              },
                              child: const Icon(
                                Icons.edit_rounded,
                                size: 16,
                                color: Colors.black,
                              ),
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
                          'Description',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () async {
                            //TODO: Implement Edit UI state change for description
                            debugPrint(await database.editCafeDescription('_'));
                          },
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
                    Text('${cafeData.data![0].description}'),
                    /*const Row(
                        children: [
                          Expanded(
                            child: TextField(
                              minLines: 5,
                              maxLines: 5,
                            ),
                          ),
                        ],
                      ),*/
                    const Padding(
                        padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                    const Text(
                      'Coffee Card',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Padding(
                        padding: EdgeInsets.all(CafeAppUI.buttonSpacingSmall)),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Coffee Count'),
                        Row(
                          children: [
                            Text('6'),
                            Padding(padding: EdgeInsets.all(8)),
                            Icon(
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
                    const Text(
                      'Coffees',
                      style: TextStyle(fontWeight: FontWeight.bold),
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
                                  color = Colors.pink;
                                  break;
                                } else {
                                  color = Colors.white;
                                }
                              }
                              list.add(
                                SizedBox(
                                  width: 140,
                                  child: TextButton(
                                    onPressed: null,
                                    child: Text(
                                      coffeesData.data![i].name,
                                      style: TextStyle(
                                        color: color,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Wrap(
                              runSpacing: 8,
                              alignment: WrapAlignment.spaceBetween,
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
                  ],
                ),
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Own a Cafe? Add it to our map!"),
                const Padding(
                    padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, Routes.addCafePage),
                  child: const Text("Add Cafe"),
                ),
              ],
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
