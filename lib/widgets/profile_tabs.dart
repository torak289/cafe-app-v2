import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return Expanded(
      child: Column(
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
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                const Center(child: Text('Loyalty')),
                Center(
                    child: TextButton(
                        onPressed: () async {
                          
                        },
                        child: const Text("Scan Code"))),
                const Center(child: Text('Roaster')),
              ],
            ),
          )
        ],
      ),
    );
  }
}
