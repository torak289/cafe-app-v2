import 'package:cafeapp_v2/constants/app_colours.dart';
import 'package:cafeapp_v2/constants/routes.dart';
import 'package:flutter/material.dart';

class SearchControls extends StatelessWidget {
  const SearchControls({
    super.key,
  });

//TODO: Implement actual search & map control... Will probably need access to map controller...
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppColours.screenHorizontal, 0, AppColours.screenHorizontal, AppColours.screenVertical),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(onPressed: () {
            Navigator.pushNamed(context, Routes.addCafePage);
          }, child: const Text("Add Cafe")),
          TextButton(
            onPressed: () => {},
            child: const Text("Find Cafe"),
          ),
          TextField()
        ],
      ),
    );
  }
}