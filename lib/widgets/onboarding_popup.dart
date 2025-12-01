import 'package:cafeapp_v2/constants/cafe_app_ui.dart';
import 'package:cafeapp_v2/services/share_pref_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPopup extends StatefulWidget {
  @override
  State<OnboardingPopup> createState() => _OnboardingPopupState();
}

class _OnboardingPopupState extends State<OnboardingPopup> {
  bool _isDismissing = false;

  Future<void> _dismissOnboarding(SharePrefService sharePrefService) async {
    setState(() {
      _isDismissing = true;
    });
    await sharePrefService.hasFirstLaunched();
  }

  @override
  Widget build(BuildContext context) {
    final SharePrefService sharePrefService =
        Provider.of<SharePrefService>(context, listen: false);
    final pageController = PageController(viewportFraction: 1, keepPage: true);
    if (sharePrefService.isFirstLaunch && !_isDismissing) {
      return Positioned.fill(
        child: GestureDetector(
          onTap: () {
            _dismissOnboarding(sharePrefService);
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified_rounded,
                                color: Colors.pinkAccent,
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.all(
                                    CafeAppUI.buttonSpacingSmall),
                              ),
                              Text(
                                'Verified',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Tap the Café icon on the map to open its overview page. From here, you can read existing reviews or add your own. Please note that you’ll need to be logged in to leave a review.',
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Create account by clicking the profile icon'),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                boxShadow: [
                                  BoxShadow(
                                      color: const Color.fromARGB(117, 0, 0, 0),
                                      blurRadius: 8)
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Icon(Icons.person,
                                  color: Colors.black, size: 28),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Long-press on the map to add a café.',
                          ),
                          Text(
                            'Alternatively, use the add button in the map controls.',
                          ),
                          Text(
                            'You’ll need an account to add a café.',
                          ),
                        ],
                      )
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
                      Padding(
                          padding: EdgeInsetsGeometry.all(
                              CafeAppUI.buttonSpacingSmall)),
                      TextButton(
                          onPressed: () {
                            _dismissOnboarding(sharePrefService);
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
