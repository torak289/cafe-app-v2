import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:cafeapp_v2/services/location_service.dart';
import 'package:cafeapp_v2/utils/cafeapp_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:provider/provider.dart';

class SearchControls extends StatefulWidget {
  Future<MarkerLayer> markerLayer;
  AnimatedMapController mapController;

  SearchControls({
    super.key,
    required this.markerLayer,
    required this.mapController,
  });

  @override
  State<SearchControls> createState() => _SearchControlsState();
}

class _SearchControlsState extends State<SearchControls> {
  final TextEditingController searchController = TextEditingController();
  Debouncer searchDebounce = Debouncer(milliseconds: 250);
  late DatabaseService database;
  late LocationService location;
  late List<CafeModel> cafeResults = List.empty(growable: true);
  @override
  void initState() {
    super.initState();
    database = Provider.of<DatabaseService>(context, listen: false);
    location = Provider.of<LocationService>(context, listen: false);
    searchController.addListener(_search);
  }

//TODO: Implement hybrid search
  void _search() async {
    final text = searchController.text;
    final Position pos;
    try {
      pos = await location.currentPosition;

      searchDebounce.run(
        () async {
          final results = await database.search(text, pos);
          setState(() {
            cafeResults = results;
          });
        },
      );
    } catch (e) {
      Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: CafeAppUI.screenHorizontal,
      right: CafeAppUI.screenHorizontal,
      bottom: CafeAppUI.screenVertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
          TextButton(
            onPressed: () async {
              List<CafeModel> closestCafes = await database.getClosestCafe(
                  widget.mapController.mapController.camera.center);
              widget.mapController
                  .animateTo(dest: closestCafes[0].location, zoom: 18);
            },
            child: const Text("Find Cafe"),
          ),
          Container(
            width: 600,
            height: 200,
            decoration: const BoxDecoration(
              color: CafeAppUI.backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Builder(builder: (context) {
              if (cafeResults.isNotEmpty) {
                List<Widget> list = List.empty(growable: true);
                for (int i = 0; i < cafeResults.length; i++) {
                  list.add(
                    GestureDetector(
                      onTap: () {
                        widget.mapController.animateTo(
                          duration: const Duration(milliseconds: 200),
                          dest: cafeResults[i].location,
                          zoom: widget.mapController.mapController.camera.zoom,
                        );
                      },
                      child: Text(cafeResults[i].name.toString()),
                    ),
                  );
                }
                return Column(
                  children: list,
                );
              } else {
                return const Text("Empty");
              }
            }),
          ),
          const Padding(padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
          TextField(
            decoration: const InputDecoration(labelText: 'Search a cafe!'),
            controller: searchController,
            onTapOutside: (event) => FocusScope.of(context)
                .requestFocus(FocusNode()), //TODO: meh behavior improve...
          )
        ],
      ),
    );
  }
}
