import 'package:cafeapp_v2/data_models/coffee_model.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

class ProfileTabs extends StatefulWidget {
  const ProfileTabs({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileTabs();
}

class _ProfileTabs extends State<ProfileTabs>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  String _scanBarcode = 'Unknown';

  @override
  Widget build(BuildContext context) {
    final DatabaseService database =
        Provider.of<DatabaseService>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        TabBar(
          isScrollable: false,
          controller: tabController,
          tabs: const [
            Tab(text: 'Loyalty'),
            Tab(text: 'Cafe'),
            Tab(text: 'Roaster'),
          ],
        ),
        SizedBox(
          height: 440,
          child: TabBarView(
            controller: tabController,
            children: [
              const Center(child: Text('Loyalty')),
              Column(
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
                      builder: (context, data) {
                        if (data.hasData) {
                          List<Widget> list = List.empty(growable: true);

                          for (int i = 0; i < data.data!.length; i++) {
                            list.add(TextButton(
                                onPressed: null,
                                child: Text(data.data![i].name)));
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
              ),
              const Center(child: Text('Roaster')),
            ],
          ),
        )
      ],
    );
  }
}
