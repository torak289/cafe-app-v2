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

  CafeModel({
    this.uid,
    //this.created_at,
    required this.name,
    required this.location,
    this.description,
    this.coffees,
    this.owner,
    this.rating,
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
    };
  }

  factory CafeModel.fromJson(Map<String, dynamic> data) {
    return CafeModel(
      uid: data['uid'],
      name: data['name'],
      description: data['description'],
      //created_at: data['created_at'], TODO: Parse Date Time
      coffees: data['coffees'],
      owner: data['owner'],
      location: data['lat'] != null || data['lng'] != null
          ? LatLng(data['lat'], data['lng'])
          : const LatLng(0, 0),
    );
  }
  @override
  String toString() {
    return 'uid: $uid, name: $name, $location';
  }
}
