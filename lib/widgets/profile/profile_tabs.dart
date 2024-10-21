import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/widgets/profile/cafe_tab.dart';
import 'package:cafeapp_v2/widgets/profile/loyalty_tab.dart';
import 'package:cafeapp_v2/widgets/profile/tab_content_view.dart';
import 'package:flutter/material.dart';

class ProfileTabs extends StatefulWidget {
  const ProfileTabs({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileTabs();
}

class _ProfileTabs extends State<ProfileTabs>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  final String _scanBarcode = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TabBar(
              isScrollable: false,
              tabs: [
                Tab(text: 'Loyalty'),
                Tab(text: 'Cafe'),
                //Tab(text: 'Roaster'),
              ],
            ),
            SingleChildScrollView(
              child: TabContentView(
                children: [
                  LoyaltyTab(),
                  CafeTab(),
                  //const Center(child: Text('Roaster')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
