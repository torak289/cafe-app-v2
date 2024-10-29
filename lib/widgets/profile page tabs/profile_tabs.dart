import 'package:cafeapp_v2/widgets/profile%20page%20tabs/cafe_tab.dart';
import 'package:cafeapp_v2/widgets/profile%20page%20tabs/loyalty_tab.dart';
import 'package:cafeapp_v2/widgets/profile%20page%20tabs/tab_content_view.dart';
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
            TabContentView(
              children: [
                LoyaltyTab(),
                CafeTab(),
                //const Center(child: Text('Roaster')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
