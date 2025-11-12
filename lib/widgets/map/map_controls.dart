import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/constants/routes.dart';
import 'package:cafeapp_v2/enum/app_states.dart';
import 'package:cafeapp_v2/services/auth_service.dart';
import 'package:cafeapp_v2/services/location_service.dart';
import 'package:cafeapp_v2/utils/systemui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapControls extends StatelessWidget {
  const MapControls({
    super.key,
    required this.animatedMapController,
    required this.position,
  });

  final AnimatedMapController animatedMapController;
  final Position position;

  @override
  Widget build(BuildContext context) {
    AuthService user = Provider.of(context, listen: false);
    final LocationService location =
        Provider.of<LocationService>(context, listen: false);

    return Positioned(
      right: CafeAppUI.mapControlsRightPadding,
      bottom: CafeAppUI.mapControlsBottomPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () {
              animatedMapController.animatedZoomOut();
            },
            icon: const Icon(
              Icons.zoom_out_rounded,
            ),
          ),
          const Padding(padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
          IconButton(
            onPressed: () {
              animatedMapController.animatedZoomIn();
            },
            icon: const Icon(
              Icons.zoom_in_rounded,
            ),
          ),
          const Padding(padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
          IconButton(
            onPressed: () {
              animatedMapController.animateTo(
                dest: LatLng(position.latitude, position.longitude),
              );
            },
            icon: const Icon(
              Icons.my_location_rounded,
            ),
          ),
          Builder(builder: (context) {
            //TODO: Reimplement Loyalty System
            if (user.appState == AppState.Authenticated) {
              //TODO: Implement a Cafe Owner database check to display.
              return Column(
                children: [
                  const Padding(
                      padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
                  StreamBuilder(
                    stream: location.positionStream,
                    builder: (context, snapshot) {
                      return IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            Routes.addCafePage,
                            arguments: AddCafeArgs(
                              cafePosition: LatLng(snapshot.data!.latitude,
                                  snapshot.data!.longitude),
                              isOwner: false,
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.add_rounded,
                          color: CafeAppUI.iconButtonIconBGColor,
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.black)),
                      );
                    },
                  ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          })
        ],
      ),
    );
  }
}
