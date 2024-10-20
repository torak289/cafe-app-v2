import 'package:cafeapp_v2/widgets/profile/cafe_tab.dart';
import 'package:cafeapp_v2/widgets/profile/loyalty_tab.dart';
import 'package:flutter/material.dart';

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
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  final String _scanBarcode = 'Unknown';

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
            //Tab(text: 'Roaster'),
          ],
        ),
        SizedBox(
          height: 400,
          child: TabBarView(
            controller: tabController,
            children: const [
              LoyaltyTab(),
              CafeTab(),
              //const Center(child: Text('Roaster')),
            ],
          ),
        )
      ],
    );
  }
}
