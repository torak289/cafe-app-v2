import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/services/share_pref_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SharePrefService sharePrefService =
        Provider.of<SharePrefService>(context, listen: false);
    final pageController = PageController(viewportFraction: 1, keepPage: true);
    if (sharePrefService.isFirstLauncher) {
      return Positioned.fill(
        child: GestureDetector(
          onTap: () {
            sharePrefService.hasFirstLaunched();
          },
          child: Container(
            color: Colors.black54, // Dim background
            child: Center(
              child: AlertDialog(
                backgroundColor: CafeAppUI.backgroundColor,
                content: SizedBox(
                  height: 320,
                  width: 200,
                  child: PageView(
                    controller: pageController,
                    scrollDirection: Axis.horizontal,
                    pageSnapping: true,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/Cafe_Logo.png',
                            scale: 2,
                          ),
                          Padding(
                              padding: EdgeInsetsGeometry.all(
                                  CafeAppUI.buttonSpacingMedium)),
                          Text(
                              'Welcome to Robusta the community-powered coffee app built for independent coffee lovers.'),
                          Padding(
                            padding: EdgeInsetsGeometry.all(
                                CafeAppUI.buttonSpacingSmall),
                          ),
                        ],
                      ),
                      Center(
                        child: Text('Onboarding Page 2'),
                      ),
                      Center(
                        child: Text('Onboarding Page 3'),
                      ),
                      Center(
                        child: Text('Onboarding Page 4'),
                      ),
                    ],
                  ),
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  Column(
                    children: [
                      SmoothPageIndicator(
                        controller: pageController,
                        count: 4,
                        effect: const WormEffect(
                          activeDotColor: CafeAppUI.iconButtonIconColor,
                          dotColor: CafeAppUI.iconButtonIconColor,
                          paintStyle: PaintingStyle.stroke,
                          dotHeight: 8,
                          dotWidth: 8,
                          type: WormType.normal,
                        ),
                      ),
                      Padding(padding: EdgeInsetsGeometry.all(CafeAppUI.buttonSpacingSmall)),
                      TextButton(
                          onPressed: () {
                            sharePrefService.hasFirstLaunched();
                          },
                          child: Text('Skip Onboarding')),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
