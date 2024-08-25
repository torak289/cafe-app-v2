import 'dart:async';

import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:cafeapp_v2/data_models/roaster_model.dart';
import 'package:cafeapp_v2/utils/cafeapp_utils.dart';
import 'package:cafeapp_v2/widgets/map/markers/cafe_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final String? uid;

  List<CafeModel> cafes = List<CafeModel>.empty(growable: true);
  List<RoasterModel> roaster = List<RoasterModel>.empty(
      growable: true); //TODO: Implement Roasters in App...

  SupabaseClient database = Supabase.instance.client;

  DatabaseService({this.uid});

  Future<void> addCafe(CafeModel cafe) async {
    await _add(path: 'cafes', data: cafe.toJson());
  }

  Future<List<CafeModel>> getCafes() async {
    List<CafeModel> cafes = List.empty();
    final data = await _select(table: 'cafes');

    for (int i = 0; i < data.length; i++) {
      cafes.add(CafeModel.fromJson(data[i]));
    }
    return cafes;
  }

  Future<MarkerLayer> getCafeMarkerLayer(
      AnimatedMapController mapController) async {
    //This function gets called 3 times on app start?
    List<CafeMarker> markers = List.empty(growable: true);
    try {
      final data = await _selectUsingFunc(func: 'select_cafe_latlng');

      cafes.clear();
      cafes = CafeappUtils.cafesFromJson(data);

      markers = CafeappUtils.cafesToMarkers(
          cafes, mapController); //TODO: Move to map page...
    } catch (e) {
      debugPrint(e.toString());
    }
    return MarkerLayer(markers: markers);
  }

  Future<MarkerLayer> getCafesInBounds(AnimatedMapController mapController) async {
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
      debugPrint(data.toString());
      cafes.clear();
      cafes = CafeappUtils.cafesFromJson(data);

      markers = CafeappUtils.cafesToMarkers(cafes, mapController);

      return MarkerLayer(markers: markers);
    } catch (e) {
      debugPrint(e.toString());
      return Future.error(e);
    }
  }
  Future<MarkerLayer> getCafesInBoundsCamera(MapCamera camera, AnimatedMapController mapController) async {
    List<CafeMarker> markers = List.empty(growable: true);
    try {
      LatLngBounds bounds = camera.visibleBounds;
      List<CafeModel> cafes = List.empty(growable: true);
      final data = await _selectUsingFunc(func: 'cafes_in_bounds', params: {
        'min_lat': bounds.southWest.latitude,
        'min_long': bounds.southWest.longitude,
        'max_lat': bounds.northEast.latitude,
        'max_long': bounds.northEast.longitude,
      });
      debugPrint(data.toString());
      cafes.clear();
      cafes = CafeappUtils.cafesFromJson(data);

      markers = CafeappUtils.cafesToMarkers(cafes, mapController);

      return MarkerLayer(markers: markers);
    } catch (e) {
      debugPrint(e.toString());
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
