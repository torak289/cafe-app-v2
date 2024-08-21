import 'package:cafeapp_v2/constants/app_colours.dart';
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppColours.screenHorizontal, 0,
          AppColours.screenHorizontal, AppColours.screenVertical),
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
                  child: const Text("Add Cafe")),
              TextButton(
                onPressed: () => {
                  //TODO: FIND CAFE FUNCTIONALITY...
                },
                child: const Text("Find Cafe"),
              ),
            ],
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Search a cafe!'),
            controller: searchController,
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
