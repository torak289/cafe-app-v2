import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:cafeapp_v2/utils/cafeapp_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
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

  @override
  void initState() {
    super.initState();
    database = Provider.of<DatabaseService>(context, listen: false);
    searchController.addListener(_search);
  }

//TODO: Implement actual search... Will probably need access to map controller...
  void _search() async {
    final text = searchController.text;

    searchDebounce.run(() {
      database.search(text);
    });
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
          /*Container(
            width: 600,
            height: 200,
            decoration: const BoxDecoration(
              color: CafeAppUI.backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),*/
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
