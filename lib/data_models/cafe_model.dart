import 'package:cafeapp_v2/utils/cafeapp_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

class CafeModel {
  String? uid;
  //DateTime? created_at;
  String? name;
  String? description;
  List<String>? coffees;
  String? owner;
  LatLng location;
  double? rating;
  bool? verified;

  CafeModel({
    this.uid,
    //this.created_at,
    required this.name,
    required this.location,
    this.description,
    this.coffees,
    this.owner,
    this.rating,
    this.verified,
  });

  Map<String, dynamic> toJson() {
    //TODO: Fix null issue in database when passed or create better toJson() functions...
    return {
      //'uid': uid,
      //'created_at': created_at,
      'name': name,
      'description': description,
      'coffees': coffees,
      'owner': owner,
      'location': 'POINT(${location.latitude} ${location.longitude})',
      'rating': rating,
      'verified': verified,
    };
  }

  static cafesFromJson(List<Map<String, dynamic>> data) {
    //TODO: Does it make sense to move this into the CafeModel?
    try {
      List<CafeModel> cafes = List.empty(growable: true);
      for (int i = 0; i < data.length; i++) {
        cafes.add(CafeModel.fromJson(data[i]));
      }
      return cafes;
    } catch (e) {
      debugPrint("Cafes From Json ERROR: $e");
      return List.empty();
    }
  }

  factory CafeModel.fromJson(Map<String, dynamic> data) {
    return CafeModel(
      uid: data['uid'],
      name: data['name'],
      description: data['description'],
      //created_at: data['created_at'], TODO: Parse Date Time
      coffees: data['coffeeslist'] != null
          ? CafeappUtils.stringListFromJson(data['coffeeslist'])
          : List.empty(),
      owner: data['owner'],
      location: data['lat'] != null || data['lng'] != null
          ? LatLng(data['lat'], data['lng'])
          : const LatLng(0, 0),
      verified: data['verified'] ?? false,
    );
  }
  @override
  String toString() {
    return 'uid: $uid, name: $name, $location';
  }
}
