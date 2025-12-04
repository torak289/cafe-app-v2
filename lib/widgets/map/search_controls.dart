import 'package:cafeapp_v2/constants/cafe_app_ui.dart';
import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:cafeapp_v2/services/location_service.dart';
import 'package:cafeapp_v2/utils/cafeapp_utils.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class SearchControls extends StatefulWidget {
  final Future<MarkerLayer> markerLayer;
  final AnimatedMapController mapController;
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
  List<CafeModel> cafeResults = List.empty(growable: true);
  Position? pos;
  bool showSearch = false;
  // removed pointer-down guards and hide timer — dismissal only on keyboard submit
  @override
  void initState() {
    super.initState();
    database = Provider.of<DatabaseService>(context, listen: false);
    location = Provider.of<LocationService>(context, listen: false);
    // Show search only when the user interacts; keep collapsed by default.
    showSearch = false;

    _addSearchListener();
  }

  void _addSearchListener() {
    try {
      searchController.addListener(_search);
    } catch (_) {}
  }

  void _removeSearchListener() {
    try {
      searchController.removeListener(_search);
    } catch (_) {}
  }

  @override
  void dispose() {
    _removeSearchListener();
    searchController.dispose();
    super.dispose();
  }
  void _search() async {
    final text = searchController.text;
    try {
      // If search text is empty, clear results and keep search open.
      if (text.trim().isEmpty) {
        setState(() {
          cafeResults = List.empty(growable: true);
          showSearch = true;
        });
        return;
      }

      // Acquire current position once (may be cached by the LocationService).
      final current = await location.currentPosition;
      pos = current;

      searchDebounce.run(
        () async {
          final results = await database.semanticSearch(text, current);

          if (!mounted) return;
          setState(() {
            cafeResults = results;
            showSearch = true;
          });
        },
      );
    } catch (e) {
      // Keep UI stable on errors
      debugPrint('Search error: $e');
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
              Builder(builder: (context) {
                if (!showSearch) return Container();

                // Build result list
                if (cafeResults.isEmpty) {
                  return Container(
                    decoration: BoxDecoration(
                      color: CafeAppUI.backgroundColor,
                      border: Border.all(color: Colors.black, width: 1.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: const Text('No Result Found...'),
                    ),
                  );
                }

                return Material(
                  color: CafeAppUI.backgroundColor,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(cafeResults.length, (i) {
                        final cafe = cafeResults[i];
                        final distance = (pos != null)
                            ? (Geolocator.distanceBetween(
                                        pos!.latitude,
                                        pos!.longitude,
                                        cafe.location.latitude,
                                        cafe.location.longitude) /
                                    1000)
                                .toStringAsFixed(1)
                            : '-';

                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                widget.mapController.animateTo(
                                  duration: const Duration(milliseconds: 200),
                                  dest: cafe.location,
                                  zoom: widget.mapController
                                      .mapController.camera.zoom,
                                );

                                // Remove the listener while we programmatically
                                // set the controller text so it doesn't trigger a
                                // search. Re-add it shortly after.
                                _removeSearchListener();
                                searchController.text = cafe.name ?? '';
                                setState(() {
                                  cafeResults = List.empty(growable: true);
                                  showSearch = false;
                                });

                                Future.delayed(const Duration(milliseconds: 250), () {
                                  if (mounted) _addSearchListener();
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        cafe.name.toString(),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text('$distance km'),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          onPressed: () {
                                            // launch external maps
                                            CafeappUtils.launchMap(cafe.location);
                                          },
                                          icon: const Icon(
                                            Icons.explore,
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (i < cafeResults.length - 1)
                              const Divider(
                                height: 4,
                                thickness: 1.25,
                                color: Colors.black,
                              ),
                          ],
                        );
                      }),
                    ),
                  ),
                );
              }),
            ],
          ),
          const Padding(padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
          TextField(
            decoration: const InputDecoration(labelText: 'Search a cafe!'),
            //TODO: meh behavior improve...
            controller: searchController,
            onTap: () {
              setState(() {
                showSearch = true;
              });
            },
            onSubmitted: (_) {
              // Hide results and dismiss keyboard when user submits
              FocusScope.of(context).unfocus();
              setState(() {
                showSearch = false;
              });
            },
            // dismissal of results is only handled on keyboard submit (onSubmitted)
          )
        ],
      ),
    );
  }
}
