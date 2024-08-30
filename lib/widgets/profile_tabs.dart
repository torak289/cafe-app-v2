import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

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
          height: 400,
          child: TabBarView(
            controller: tabController,
            children: const [
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
                  Text('Coffees'),
                  const Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      TextButton(onPressed: null, child: Text('Coffee')),
                      TextButton(onPressed: null, child: Text('Coffee')),
                      TextButton(onPressed: null, child: Text('Coffee')),
                      TextButton(onPressed: null, child: Text('Coffee')),
                      TextButton(onPressed: null, child: Text('Coffee')),
                      TextButton(onPressed: null, child: Text('Coffee')),
                      TextButton(onPressed: null, child: Text('Coffee')),
                      TextButton(onPressed: null, child: Text('Coffee')),
                      TextButton(onPressed: null, child: Text('Coffee')),
                    ],
                  ),
                  Text('Locations'),
                ],
              ),
              Center(child: Text('Roaster')),
            ],
          ),
        )
      ],
    );
  }
}
