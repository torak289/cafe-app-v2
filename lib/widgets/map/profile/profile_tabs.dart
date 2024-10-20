import 'package:cafeapp_v2/data_models/coffee_model.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:cafeapp_v2/widgets/map/profile/cafe_tab.dart';
import 'package:cafeapp_v2/widgets/map/profile/loyalty_tab.dart';
import 'package:flutter/material.dart';
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
          height: 420,
          child: TabBarView(
            controller: tabController,
            children: [
              LoyaltyTab(),
              CafeTab(),
              const Center(child: Text('Roaster')),
            ],
          ),
        )
      ],
    );
  }
}
