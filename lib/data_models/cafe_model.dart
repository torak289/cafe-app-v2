import 'package:latlong2/latlong.dart';

class CafeModel {
  String? uid;
  DateTime? created_at;
  String name;
  String? description;
  List<String>? coffees;
  String? owner;
  LatLng location;
  double? rating;

  CafeModel({
    this.uid,
    //this.created_at,
    required this.name,
    this.description,
    //required this.coffees,
    this.owner,
    required this.location,
    this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      //'uid': uid,
      //'created_at': created_at,
      'name': name,
      'description': description,
      //'coffees': coffees,
      'location': 'POINT(${location.latitude} ${location.longitude})',
      'rating': rating,
    };
  }

  factory CafeModel.fromJson(Map<String, dynamic> data) {
    return CafeModel(
      uid: data['uid'],
      name: data['name'],
      description: data['description'],
      //coffees: data['coffees'],
      owner: data['owner'],
      location: LatLng(data['lat'], data['lng']),
    );
  }

  factory CafeModel.cafeMarkerFromJson(Map<String, dynamic> data) {
    return CafeModel(
      name: data['cafename'],
      location: LatLng(data['lat'], data['lng']),
    );
  }
}
