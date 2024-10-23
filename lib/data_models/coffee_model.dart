import 'package:flutter/foundation.dart';

class CoffeeModel {
  String name;
  String? description;

  CoffeeModel({required this.name, this.description});

  static List<CoffeeModel> coffeesFromJson(List<Map<String, dynamic>> data) {
    //TODO: Does it make sense to move this into the CoffeeModel?

    try {
      List<CoffeeModel> coffees = List.empty(growable: true);
      for (int i = 0; i < data.length; i++) {
        coffees.add(CoffeeModel.fromJson(data[i]));
      }
      return coffees;
    } catch (e) {
      debugPrint("Coffees From Json ERROR: $e");
      return List.empty();
    }
  }

  factory CoffeeModel.fromJson(Map<String, dynamic> data) {
    return CoffeeModel(
      name: data['name'],
      description: data['description'],
    );
  }
}
