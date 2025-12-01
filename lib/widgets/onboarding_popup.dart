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
                  height: 348,
                  width: 200,
                  child: PageView(
                    controller: pageController,
                    scrollDirection: Axis.horizontal,
                    pageSnapping: true,
                    children: [
                      //Welcome Page
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
                      //Basic Usage Page
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: CafeAppUI.buttonSpacingLarge,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Maps & Icons',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Padding(
                              padding: EdgeInsetsGeometry.all(
                                CafeAppUI.buttonSpacingLarge,
                              ),
                            ),
                            Column(
                              children: [
                                //Verified Section
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      width: 170,
                                      child: Text(
                                        'Cafés with the verified icon have been reviewed by us or an ambassador',
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsetsGeometry.all(
                                            CafeAppUI.buttonSpacingMedium)),
                                    Icon(
                                      Icons.verified_rounded,
                                      color: Colors.pinkAccent,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsetsGeometry.all(
                                    CafeAppUI.buttonSpacingMedium,
                                  ),
                                ),
                                //Map Icon
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_sharp,
                                      color: CafeAppUI.cafeMarkerColor,
                                      size: 28,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Robusta Café',
                                          style: const TextStyle(
                                            fontFamily: "Monospace",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: CafeAppUI.secondaryColor,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              'Cafe',
                                              style: TextStyle(
                                                fontFamily: "Monospace",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: CafeAppUI.secondaryColor,
                                              ),
                                            ),
                                            const Padding(
                                                padding: EdgeInsets.all(2)),
                                            const Icon(
                                              Icons.verified,
                                              color: Colors.pinkAccent,
                                              size: 12,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsetsGeometry.all(
                                    CafeAppUI.buttonSpacingSmall,
                                  ),
                                ),
                                Text(
                                  "Tap the Café icon to open its overview, view its rating, and add your own review. You’ll need to be logged in to add a review.",
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      //Add Cafe Page
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: CafeAppUI.buttonSpacingLarge,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Adding a Café',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsGeometry.all(
                                CafeAppUI.buttonSpacingLarge,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text('Add a Café by doing either:'),
                                Padding(
                                  padding: EdgeInsetsGeometry.all(
                                    CafeAppUI.buttonSpacingSmall,
                                  ),
                                ),
                                Text(
                                  '- Long-Press on the map to add a Café.',
                                  textAlign: TextAlign.start,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 160,
                                      child: Text(
                                        ' - Alternatively, use the add button in the map controls.',
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsGeometry.all(
                                        CafeAppUI.buttonSpacingSmall,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: null,
                                      icon: const Icon(
                                        Icons.add_rounded,
                                        color: CafeAppUI.iconButtonIconBGColor,
                                      ),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                  Colors.black)),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsetsGeometry.all(
                                    CafeAppUI.buttonSpacingSmall,
                                  ),
                                ),
                                Text(
                                  'Note: You’ll need an account to add a café.',
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      //Login/Create Account Page
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: CafeAppUI.buttonSpacingLarge,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Create your Account',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsGeometry.all(
                                CafeAppUI.buttonSpacingLarge,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 170,
                                      child: Text(
                                          'Press the profile icon to Register an Account'),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsGeometry.all(
                                        CafeAppUI.buttonSpacingSmall,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: const Color.fromARGB(
                                                    117, 0, 0, 0),
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
                                Padding(
                                  padding: EdgeInsetsGeometry.all(
                                    CafeAppUI.buttonSpacingMedium,
                                  ),
                                ),
                                Text('Login with email & password'),
                                Padding(
                                  padding: EdgeInsetsGeometry.all(
                                    CafeAppUI.buttonSpacingSmall,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        64,
                                      ),
                                    ),
                                    border: BoxBorder.all(
                                      color: Colors.black,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 16),
                                    child: Text('jane.doe@robusta.com'),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsetsGeometry.all(
                                        CafeAppUI.buttonSpacingSmall)),
                                Container(
                                  width: double.infinity,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        64,
                                      ),
                                    ),
                                    border: BoxBorder.all(
                                      color: Colors.black,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 16),
                                    child: Text('********'),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsetsGeometry.all(
                                        CafeAppUI.buttonSpacingSmall)),
                                const Row(
                                  children: [
                                    Expanded(
                                        child: Divider(color: Colors.black)),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: CafeAppUI.screenHorizontal,
                                          right: CafeAppUI.screenHorizontal),
                                      child: Text("Or",
                                          textAlign: TextAlign.center),
                                    ),
                                    Expanded(
                                        child: Divider(color: Colors.black)),
                                  ],
                                ),
                                Padding(
                                    padding: EdgeInsetsGeometry.all(
                                        CafeAppUI.buttonSpacingSmall)),
                                TextButton(
                                  onPressed: () {
                                    _dismissOnboarding(sharePrefService);
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.login_rounded,
                                        size: 24,
                                      ),
                                      Padding(padding: EdgeInsets.all(8)),
                                      Text("Login with SSO"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
