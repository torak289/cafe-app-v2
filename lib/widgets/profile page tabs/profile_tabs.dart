import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
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
            Padding(padding: EdgeInsets.all(2)), //TODO: Improve implementation of padding through the app...
            TabBar(
              isScrollable: false,
              tabs: [
                Tab(text: 'Loyalty', height:CafeAppUI.tabHeight),
                Tab(text: 'Cafe',height: CafeAppUI.tabHeight),
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
