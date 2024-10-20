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
        builder: (context, future) {
          if (future.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  children: [
                    Text('Name'),
                    Expanded(
                      child: TextField(),
                    ),
                  ],
                ),
                const Text('Description'),
                const Row(
                  children: [
                    Expanded(
                      child: TextField(
                        minLines: 5,
                        maxLines: 5,
                      ),
                    ),
                  ],
                ),
                const Text('Coffees'),
                FutureBuilder<List<CoffeeModel>>(
                    future: database.getCoffeeList(),
                    builder: (context, future) {
                      if (future.hasData) {
                        List<Widget> list = List.empty(growable: true);

                        for (int i = 0; i < future.data!.length; i++) {
                          list.add(TextButton(
                              onPressed: null,
                              child: Text(future.data![i].name)));
                        }
                        return Wrap(
                          spacing: 0,
                          runSpacing: 16,
                          alignment: WrapAlignment.start,
                          children: list,
                        );
                      } else {
                        return const Center(
                          child: Text("Error"),
                        );
                      }
                    }),
                const Text('Locations'),
              ],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Own a Cafe? Add it to our map!"),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, Routes.addCafePage),
                  child: const Text("Add Cafe"),
                ),
              ],
            );
          }
        });
  }
}
