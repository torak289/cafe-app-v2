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

    return Padding(
      padding: const EdgeInsets.fromLTRB(CafeAppUI.screenHorizontal, 0,
          CafeAppUI.screenHorizontal, CafeAppUI.screenVertical),
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
          Padding(padding: EdgeInsets.all(8)),
          TextField(
            decoration: const InputDecoration(labelText: 'Search a cafe!'),
            controller: searchController,
            onTapOutside: (event) => FocusScope.of(context).requestFocus(new FocusNode()), //TODO: meh behavior improve...
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
