import 'package:cafeapp_v2/constants/Cafe_App_UI.dart';
import 'package:cafeapp_v2/constants/routes.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchControls extends StatefulWidget {
  SearchControls({
    super.key,
  });

  @override
  State<SearchControls> createState() => _SearchControlsState();
}

class _SearchControlsState extends State<SearchControls> {
  late TextEditingController searchController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController = TextEditingController();
  }

//TODO: Implement actual search... Will probably need access to map controller...
  @override
  Widget build(BuildContext context) {
    DatabaseService database =
        Provider.of<DatabaseService>(context, listen: false);

    return Positioned(
      left: CafeAppUI.screenHorizontal,
      right: CafeAppUI.screenHorizontal,
      bottom: CafeAppUI.screenVertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.addCafePage);
                },
                child: const Text("Add Cafe"),
              ),
              const Padding(
                  padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
              TextButton(
                onPressed: () => {
                  //TODO: FIND CAFE FUNCTIONALITY...
                  //This is going to be really really difficult...
                },
                child: const Text("Find Cafe"),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
          TextField(
            decoration: const InputDecoration(labelText: 'Search a cafe!'),
            controller: searchController,
            onTapOutside: (event) => FocusScope.of(context)
                .requestFocus(FocusNode()), //TODO: meh behavior improve...
            onSubmitted: (input) async {
              /*await database.search(searchController.text.trim());
              if(context.mounted){
              //TODO: Implement UI update actions...
              }*/
            },
          )
        ],
      ),
    );
  }
}
