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
  num? rating;
  bool? verified;
  bool verificationRequested;
  int? claimAmount;
  String? instagram;
  int? totalReviews;

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
    this.claimAmount,
    this.verificationRequested = false,
    this.instagram,
    this.totalReviews,
  });

  Map<String, dynamic> toJson() {
    //TODO: Fix null issue in database when passed or create better toJson() functions...
    return {
      //'uid': uid,
      //'created_at': created_at,
      'name': name,
      'description': description,
      //'coffees': coffees,
      //'owner': owner,
      'location': 'POINT(${location.latitude} ${location.longitude})',
      'rating': rating,
      //'verified': verified,
      //'claim_amount': claimAmount,
    };
  }

  static cafesFromJson(List<Map<String, dynamic>> data) {
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

    //debugPrint(data.toString());
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
      claimAmount: data['claim_amount'] ?? -1,
      verificationRequested: data['verification_requested'] ?? false,
      instagram: data['instagram'],
      rating: data['rating'],
      totalReviews: data['total_reviews'],
    );
  }
  @override
  String toString() {
    return 'uid: $uid, name: $name, $location';
  }
}

class OpeningTimeDayModel {
  String day = "null";
  bool isOpen = true;
  DateTime from = DateTime.now();
  DateTime to = DateTime.now();
}

class OpeningTimesModel {
  OpeningTimeDayModel monday = OpeningTimeDayModel();
  OpeningTimeDayModel tuesday = OpeningTimeDayModel();
  OpeningTimeDayModel wednesday = OpeningTimeDayModel();
  OpeningTimeDayModel thursday = OpeningTimeDayModel();
  OpeningTimeDayModel friday = OpeningTimeDayModel();
  OpeningTimeDayModel saturday = OpeningTimeDayModel();
  OpeningTimeDayModel sunday = OpeningTimeDayModel();
}
