import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/constants/routes.dart';
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: CafeAppUI.screenHorizontal,
            vertical: CafeAppUI.screenVertical),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.hardEdge,
                height: 374,
                child: FutureBuilder<LocationPermission>(
                  //Map Element
                  future: location.checkServices(),
                  builder: (context, locationData) {
                    if (locationData.data == LocationPermission.always ||
                        locationData.data == LocationPermission.whileInUse) {
                      return FutureBuilder<Position>(
                        future: location.currentPosition,
                        builder: (context, AsyncSnapshot<Position> position) {
                          if (position.hasData) {
                            return Stack(
                              alignment: AlignmentDirectional.topCenter,
                              children: [
                                //Map
                                FlutterMap(
                                  mapController:
                                      animatedMapController.mapController,
                                  options: MapOptions(
                                    initialCenter: (args.cafePosition == null)
                                        ? LatLng(position.data!.latitude,
                                            position.data!.longitude)
                                        : LatLng(args.cafePosition!.latitude,
                                            args.cafePosition!.longitude),
                                    initialZoom: 19,
                                    cameraConstraint: CameraConstraint.contain(
                                      bounds: LatLngBounds(
                                        const LatLng(-90, -180),
                                        const LatLng(90, 180),
                                      ),
                                    ),
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                                  animatedMapController: animatedMapController,
                                  position: position.data!,
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
              const Padding(padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
              const Text(
                'Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Padding(padding: EdgeInsets.all(CafeAppUI.buttonSpacingSmall)),
              TextField(
                controller: cafeName,
              ),
              const Padding(padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
              const Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Padding(padding: EdgeInsets.all(CafeAppUI.buttonSpacingSmall)),
              TextField(
                controller: cafeDescription,
                minLines: 5,
                maxLines: 5,
                maxLength: 256,
              ),
              args.isOwner!
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
                  : const SizedBox.shrink(),
              const Padding(padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
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
                          CafeModel newCafe = CafeModel(
                              name: cafeName.text.trim(),
                              description: cafeDescription.text.trim(),
                              location: animatedMapController
                                  .mapController.camera.center);
                          await database.addCafe(newCafe, widget.cafeOwner!);
                          if (context.mounted) {
                            Navigator.pop(context);
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
    );
  }
}
