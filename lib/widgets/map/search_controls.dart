import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:cafeapp_v2/services/location_service.dart';
import 'package:cafeapp_v2/utils/cafeapp_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class SearchControls extends StatefulWidget {
  final Future<MarkerLayer> markerLayer;
  final AnimatedMapController mapController;

  bool showSearch = false;
  bool hasSearchResults = false;

  SearchControls({
    super.key,
    required this.markerLayer,
    required this.mapController,
  });

  @override
  State<SearchControls> createState() => _SearchControlsState();
}

class _SearchControlsState extends State<SearchControls> {
  Debouncer searchDebounce = Debouncer(milliseconds: 250);
  final TextEditingController searchController = TextEditingController();

  late DatabaseService database;
  late LocationService location;
  late List<CafeModel> cafeResults = List.empty(growable: true);
  late Position pos;
  @override
  void initState() {
    super.initState();
    database = Provider.of<DatabaseService>(context, listen: false);
    location = Provider.of<LocationService>(context, listen: false);
  }

//TODO: Implement hybrid search backend only???
  void _search() async {
    final text = searchController.text;
    try {
      pos = await location.currentPosition;
      searchDebounce.run(
        () async {
          final results = await database.search(text, pos);

          setState(() {
            cafeResults = results;
            widget.showSearch = true;
            widget.hasSearchResults = true;
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
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              TextButton(
                onPressed: () async {
                  List<CafeModel> closestCafes = await database.getClosestCafe(
                      widget.mapController.mapController.camera.center);
                  widget.mapController
                      .animateTo(dest: closestCafes[0].location, zoom: 18);
                },
                child: const Text("Find Cafe"),
              ),
              Builder(
                builder: (context) {
                  if (widget.showSearch) {
                    List<Widget> list = List.empty(growable: true);
                    if (cafeResults.isEmpty) {
                      list.add(
                        Container(
                          //This is being used to make the hit target the full bar
                          color: Colors.transparent,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "No Result Found...",
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    for (int i = 0; i < cafeResults.length; i++) {
                      list.add(
                        GestureDetector(
                          onTap: () {
                            widget.mapController.animateTo(
                              duration: const Duration(milliseconds: 200),
                              dest: cafeResults[i].location,
                              zoom: widget
                                  .mapController.mapController.camera.zoom,
                            );
                            setState(
                              () {
                                searchController.text = cafeResults[i].name!;
                                cafeResults = List.empty();
                                widget.showSearch = false;
                              },
                            );
                          },
                          child: Container(
                            //This is being used to make the hit target the full bar
                            height: 24,
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  cafeResults[i].name.toString(),
                                ),
                                Row(
                                  children: [
                                    Text(
                                        '${(Geolocator.distanceBetween(pos.latitude, pos.longitude, cafeResults[i].location.latitude, cafeResults[i].location.longitude) / 1000).toStringAsFixed(1)} km'),
                                    const Padding(padding: EdgeInsets.all(4)),
                                    GestureDetector(
                                      child: Icon(Icons.explore, color: Colors.black,),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                      if (!(i >= cafeResults.length - 1)) {
                        list.add(
                          const Divider(
                            height: 4,
                            thickness: 1.25,
                            color: Colors.black,
                          ),
                        );
                      }
                    }
                    return Flexible(
                      fit: FlexFit.loose,
                      child: Container(
                        decoration: BoxDecoration(
                          color: CafeAppUI.backgroundColor,
                          border: Border.all(
                            color: Colors.black,
                            width: 1.5,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          child: Column(
                            children: list,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
          TextField(
            decoration: const InputDecoration(labelText: 'Search a cafe!'),
            //TODO: meh behavior improve...
            controller: searchController,
            onSubmitted: (value) {
              debugPrint("onSubmitted");
            },
            onChanged: (value) => _search(),
          )
        ],
      ),
    );
  }
}
