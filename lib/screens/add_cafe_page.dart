import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:cafeapp_v2/enum/app_states.dart';
import 'package:cafeapp_v2/services/auth_service.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:cafeapp_v2/services/location_service.dart';
import 'package:cafeapp_v2/utils/systemui_utils.dart';
import 'package:cafeapp_v2/widgets/map/map_controls.dart';
import 'package:cafeapp_v2/widgets/map/markers/user_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class AddCafePage extends StatefulWidget {
  AddCafePage({super.key});
  bool? cafeOwner = false;
  @override
  State<AddCafePage> createState() => _AddCafePageState();
}

class _AddCafePageState extends State<AddCafePage>
    with TickerProviderStateMixin {
  late final AnimatedMapController animatedMapController =
      AnimatedMapController(vsync: this);
  TextEditingController cafeName = TextEditingController();
  TextEditingController cafeDescription = TextEditingController();
  TextEditingController cafeInstagram = TextEditingController();
  bool? laptopFriendly;
  bool? hasWifi;

  @override
  Widget build(BuildContext context) {
    final AddCafeArgs args =
        ModalRoute.of(context)?.settings.arguments as AddCafeArgs;
    final LocationService location =
        Provider.of<LocationService>(context, listen: false);
    final DatabaseService database =
        Provider.of<DatabaseService>(context, listen: false);
    final AuthService authService =
        Provider.of<AuthService>(context, listen: false);

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CafeAppUI.screenHorizontal,
              vertical: CafeAppUI.screenVertical),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: const Text(
                      'Add New Cafe',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Padding(
                      padding:
                          EdgeInsetsGeometry.all(CafeAppUI.buttonSpacingMedium)),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    height: 374,
                    child: FutureBuilder<LocationPermission>(
                      //Map Element
                      future: location.checkServices(),
                      builder: (context, locationData) {
                        if (locationData.data == LocationPermission.always ||
                            locationData.data ==
                                LocationPermission.whileInUse) {
                          return StreamBuilder<Position>(
                            stream: location.positionStream,
                            builder:
                                (context, AsyncSnapshot<Position> position) {
                              if (position.hasData) {
                                return Stack(
                                  alignment: AlignmentDirectional.topCenter,
                                  children: [
                                    //Map
                                    FlutterMap(
                                      mapController:
                                          animatedMapController.mapController,
                                      options: MapOptions(
                                        initialCenter: (args.cafePosition ==
                                                null)
                                            ? LatLng(position.data!.latitude,
                                                position.data!.longitude)
                                            : LatLng(
                                                args.cafePosition!.latitude,
                                                args.cafePosition!.longitude),
                                        initialZoom: 19,
                                        cameraConstraint:
                                            CameraConstraint.contain(
                                          bounds: LatLngBounds(
                                            const LatLng(-90, -180),
                                            const LatLng(90, 180),
                                          ),
                                        ),
                                      ),
                                      children: [
                                        TileLayer(
                                          urlTemplate:
                                              'https://api.maptiler.com/maps/dataviz-light/{z}/{x}/{y}@2x.png?key=9xI0Yb0PwYnKHuphfPNr',
                                          userAgentPackageName: 'io.cafe-app',
                                          maxZoom: 25,
                                        ),
                                        MarkerLayer(
                                          markers: [
                                            UserMarker(
                                              position: position.data!,
                                              controller: animatedMapController
                                                  .mapController,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    //Center locator
                                    const Center(
                                      child: Icon(
                                        Icons.location_searching_rounded,
                                        color: CafeAppUI.iconButtonIconColor,
                                      ),
                                    ),
                                    //Map Controls
                                    MapControls(
                                      animatedMapController:
                                          animatedMapController,
                                      position: position.data!,
                                      isAddCafePage: true,
                                    ),
                                  ],
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ),
                                );
                              }
                            },
                          );
                        } else {
                          return Center(
                            child: Column(
                              children: [
                                Text(locationData.error.toString()),
                                TextButton(
                                  onPressed: () {
                                    location.openLocationSetting();
                                  },
                                  child: const Text('Location Settings'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const Padding(
                      padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                  Row(
                    children: [
                      const Text(
                        'Name ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        ' Required',
                        style: TextStyle(
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  const Padding(
                      padding: EdgeInsets.all(CafeAppUI.buttonSpacingSmall)),
                  TextFormField(
                    controller: cafeName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Cafe Name';
                      }
                      return null;
                    },
                  ),
                  /*const Padding(
                      padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Instagram ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            ' Optional',
                            style: TextStyle(
                              color: Colors.pinkAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Tooltip(
                        //TODO: Move styling into theme
                        margin: EdgeInsets.all(32),
                        triggerMode: TooltipTriggerMode.tap,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 4,
                            )
                          ],
                        ),
                        padding: EdgeInsets.all(16),
                        textStyle: TextStyle(color: Colors.black),
                        message:
                            'If you know the Instagram for this Cafe, please add it. We can show photos!',
                        child: Icon(
                          Icons.info_outline_rounded,
                          color: Colors.black,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                      padding: EdgeInsets.all(CafeAppUI.buttonSpacingSmall)),
                  TextFormField(
                    controller: cafeInstagram,
                  ),*/
                  const Padding(
                      padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Is this Cafe Laptop Friendly? ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Checkbox(
                        tristate: true,
                        value: laptopFriendly,
                        onChanged: (value) {
                          setState(() {
                            laptopFriendly = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Does this Cafe have WiFi? ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Checkbox(
                        tristate: true,
                        value: hasWifi,
                        onChanged: (value) {
                          setState(() {
                            hasWifi = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const Padding(
                      padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Description ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            ' Required',
                            style: TextStyle(
                              color: Colors.pinkAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Tooltip(
                        //TODO: Move styling into theme
                        margin: EdgeInsets.all(32),
                        triggerMode: TooltipTriggerMode.tap,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 4,
                            )
                          ],
                        ),
                        padding: EdgeInsets.all(16),
                        textStyle: TextStyle(color: Colors.black),
                        message:
                            'Tell us about this cafe! We require this so that everyone knows how good it is!',
                        child: Icon(
                          Icons.info_outline_rounded,
                          color: Colors.black,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                      padding: EdgeInsets.all(CafeAppUI.buttonSpacingSmall)),
                  TextFormField(
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return "Please enter a cafe description";
                      }
                      return null;
                    },
                    controller: cafeDescription,
                    minLines: 5,
                    maxLines: 5,
                    maxLength: 256,
                    keyboardType: TextInputType.text,
                    autocorrect: true,
                  ),
                  /*args.isOwner!
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Do you own this Cafe?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Checkbox(
                              //TODO: Implement a fix when coming from Add Owner Cafe...
                              value: widget.cafeOwner,
                              onChanged: (value) {
                                setState(() {
                                  widget.cafeOwner = value!;
                                  debugPrint(widget.cafeOwner.toString());
                                });
                              },
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),*/
                  const Padding(
                      padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: const SizedBox(
                          height: 32,
                          width: 32,
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: CafeAppUI.iconButtonIconColor,
                            size: 32,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                          onPressed: () async {
                            if (authService.appState == AppState.Authenticated) {
                              if (formKey.currentState!.validate()) {
                                CafeModel newCafe = CafeModel(
                                  name: cafeName.text.trim(),
                                  description: cafeDescription.text.trim(),
                                  location: animatedMapController
                                      .mapController.camera.center,
                                  isLaptopFriendly: laptopFriendly,
                                  hasWifi: hasWifi,
                                );
                                await database.addCafe(newCafe);
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              }
                            }
                          },
                          child: const Text("Submit")),
                      const SizedBox(
                        height: 32,
                        width: 32,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
