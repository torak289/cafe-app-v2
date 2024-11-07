import 'dart:async';

import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:cafeapp_v2/data_models/coffee_model.dart';
import 'package:cafeapp_v2/data_models/loyalty_card_model.dart';
import 'package:cafeapp_v2/data_models/roaster_model.dart';
import 'package:cafeapp_v2/utils/cafeapp_utils.dart';
import 'package:cafeapp_v2/widgets/map/markers/cafe_marker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final String? uid;

  List<CafeModel> cafeMarkers = List<CafeModel>.empty(growable: true);
  int cafeMarkersLength = 50;

  /*List<RoasterModel> roaster = List<RoasterModel>.empty(
      growable: true); //TODO: Implement Roasters in App... */

  SupabaseClient database = Supabase.instance.client;

  DatabaseService({this.uid});

  Future<List<CafeModel>> search(String text, Position currentPos) async {
    List<CafeModel> results = List.empty(growable: true);

    try {
      String modifiedText = text.replaceAll(RegExp(r' '), '+');
      final data = await _selectUsingFunc(
        func: 'search_by_name',
        params: {
          'searchname': modifiedText,
          'lati': currentPos.latitude,
          'long': currentPos.longitude,
        },
      );
      for (int i = 0; i < data.length; i++) {
        results.add(CafeModel.fromJson(data[i]));
      }
      return results;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> validateLoyaltyCode(String uuid, int count) async {
    try {
      debugPrint("UUID: $uuid, COUNT: $count");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<LoyaltyCardModel>> getLoyaltyData() async {
    try {
      final data = await _selectUsingFunc(func: 'get_loyalty');
      debugPrint(data.toString());
      List<LoyaltyCardModel> loyaltyData = List.empty(growable: true);
      for (int i = 0; i < data.length; i++) {
        loyaltyData.add(LoyaltyCardModel.fromJson(data[i]));
      }
      return loyaltyData;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<CafeModel>> getCafeData() async {
    try {
      final data = await _selectUsingFunc(func: 'get_owned_cafes');
      debugPrint(data.toString());
      List<CafeModel> cafes = List.empty(growable: true);
      cafes = CafeModel.cafesFromJson(data);
      return cafes;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<String> editCafeName(String newName) async {
    try {
      await database.rpc('edit_cafe_name', params: {'new_name': newName});
      return "Success";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> editCafeDescription(String newDescription) async {
    return 'Success';
  }

  Future<void> addCafe(CafeModel cafe) async {
    await _add(path: 'cafes', data: cafe.toJson());
  }

  Future<List<CoffeeModel>> getCoffeeList() async {
    try {
      final data = await database.from('coffees').select('name');
      List<CoffeeModel> coffees = List.empty(growable: true);
      coffees = CoffeeModel.coffeesFromJson(data);

      return coffees;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<CafeModel>> getClosestCafe(LatLng currentPos) async {
    try {
      final data = await _selectUsingFunc(func: 'find_closest_cafe', params: {
        'lati': currentPos.latitude,
        'long': currentPos.longitude,
      });
      List<CafeModel> cafes = CafeModel.cafesFromJson(data);
      return cafes;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<MarkerLayer> getCafesInBounds(
      AnimatedMapController mapController) async {
    List<CafeMarker> markers = List.empty(growable: true);
    try {
      LatLngBounds bounds = mapController.mapController.camera.visibleBounds;
      List<CafeModel> cafes = List.empty(growable: true);
      final data = await _selectUsingFunc(func: 'cafes_in_bounds', params: {
        'min_lat': bounds.southWest.latitude,
        'min_long': bounds.southWest.longitude,
        'max_lat': bounds.northEast.latitude,
        'max_long': bounds.northEast.longitude,
      });
      cafes.clear();
      cafes = CafeModel.cafesFromJson(data);
      for (CafeModel c in cafes) {
        _addCafeToMarkerList(c);
      }
      markers = CafeappUtils.cafesToMarkers(cafeMarkers, mapController);

      return MarkerLayer(markers: markers);
    } catch (e) {
      debugPrint(e.toString());
      database.auth.refreshSession();
      return Future.error(e);
    }
  }

//Private Functions
  void _addCafeToMarkerList(CafeModel cafe) {
    //TODO: Verify if actual saved caching is required for this... on app reload?
    if (cafeMarkers.isEmpty) {
      cafeMarkers.add(cafe);
    } else {
      cafeMarkers.removeWhere((c) =>
          (c.uid != cafe.uid) && (cafeMarkers.length > cafeMarkersLength));

      for (int i = 0; i < cafeMarkers.length; i++) {
        if (cafeMarkers[i].uid == cafe.uid) {
          return;
        }
      }
      cafeMarkers.add(cafe);
    }
  }

//Abstract Functions for all database access
  Future<void> _add(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = database.from(path);
    debugPrint('$path: $data');
    await reference.insert(data);
  }

  Future<List<Map<String, dynamic>>> _selectUsingFunc(
      {required String func, Map<String, dynamic>? params}) async {
    final data = await database.rpc(func, params: params).select();
    return data;
  }
}
