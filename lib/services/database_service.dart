import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:cafeapp_v2/data_models/roaster_model.dart';
import 'package:cafeapp_v2/widgets/cafe_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});
  SupabaseClient database = Supabase.instance.client;

  Future<void> addCafe(CafeModel cafe) async {
    await _add(path: 'cafes', data: cafe.toJson());
  }

  Future<void> deleteCafe(CafeModel cafe) async {
    //Delete Cafe
    await _remove(table: 'cafes', uid: cafe.uid!);
  }

  Future<List<CafeModel>> getCafes() async {
    List<CafeModel> cafes = List.empty();
    final data = await _select(table: 'cafes');

    for (int i = 0; i < data.length; i++) {
      cafes.add(CafeModel.fromJson(data[i]));
    }
    return cafes;
  }

  Future<MarkerLayer> getCafeMarkerLayer() async {
    List<CafeMarker> markers = List.empty();
    final data = await _select(table: 'cafes');

    debugPrint(data[0].toString());

    for (int i = 0; i < data.length; i++) {
      CafeModel cafe = CafeModel.fromJson(data[i]);
      markers.add(CafeMarker(point: cafe.location, cafeName: cafe.name));
      debugPrint(markers[i].toString());
    }
    return MarkerLayer(markers: markers);
  }

  Future<void> addRoaster(RoasterModel roaster) async {
    //Add Roaster
  }
  Future<void> deleteRoaster(RoasterModel roaster) async {
    //Delete Roaster
    //await _remove(table: 'roasters', uid: roaster.uid!);
  }

//Abstract Functions for all database access
  Future<void> _add(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = database.from(path);
    debugPrint('$path: $data');
    await reference.insert(data);
  }

  Future<void> _remove({required String table, required String uid}) async {
    await database.from(table).delete().eq('uid', uid);
  }

  Future<List<Map<String, dynamic>>> _select({required String table}) async {
    final data = await database.from(table).select('uid, name, description, owner, ST_Point(location::geometry) as location');
    debugPrint(data.toString());
    return data;
  }
}
