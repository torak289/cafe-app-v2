import 'dart:async';

import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:cafeapp_v2/data_models/coffee_model.dart';
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

  List<CafeModel> cafes = List<CafeModel>.empty(growable: true);
  List<RoasterModel> roaster = List<RoasterModel>.empty(
      growable: true); //TODO: Implement Roasters in App...

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

  Future<bool> getCafeData() async {
    return false;
  }

  Future<void> addCafe(CafeModel cafe) async {
    await _add(path: 'cafes', data: cafe.toJson());
  }

  Future<List<CoffeeModel>> getCoffeeList() async {
    try {
      final data = await database.from('coffees').select('name');
      List<CoffeeModel> coffees = List.empty(growable: true);
      coffees = CafeappUtils.coffeesFromJson(data);

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
      List<CafeModel> cafes = CafeappUtils.cafesFromJson(data);
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
      cafes = CafeappUtils.cafesFromJson(data);

      markers = CafeappUtils.cafesToMarkers(cafes, mapController);

      return MarkerLayer(markers: markers);
    } catch (e) {
      debugPrint(e.toString());
      database.auth.refreshSession();
      return Future.error(e);
    }
  }

//Abstract Functions for all database access
  Future<void> _add(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = database.from(path);
    debugPrint('$path: $data');
    await reference.insert(data);
  }

  Future<void> _removebyUID(
      {required String table, required String uid}) async {
    await database.from(table).delete().eq('uid', uid);
  }

  Future<List<Map<String, dynamic>>> _select({required String table}) async {
    final data = await database.from(table).select();
    return data;
  }

  Future<List<Map<String, dynamic>>> _selectUsingFunc(
      {required String func, Map<String, dynamic>? params}) async {
    final data = await database.rpc(func, params: params).select();
    return data;
  }
}
