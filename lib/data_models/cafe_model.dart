import 'package:latlong2/latlong.dart';

class CafeModel {
  String uid;
  String owner;
  String name;
  String description;
  LatLng location;
  List<String> coffees;

  CafeModel({
    required this.uid,
    required this.owner,
    required this.name,
    required this.description,
    required this.location,
    required this.coffees,
  });
}
