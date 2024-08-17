import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:cafeapp_v2/data_models/roaster_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});
  SupabaseClient database = Supabase.instance.client;

  Future<void> addCafe(CafeModel cafe) async {
    await _add(path: 'cafes', data: cafe.toJson());
    //Add Cafe
  }

  Future<void> deleteCafe(CafeModel cafe) async {
    //Delete Cafe
  }
  Future<List<CafeModel>> getCafes() async {
    List<CafeModel> cafes;
    final data = _select(path: 'cafes');
    return cafes;
  }

  Future<void> addRoaster(RoasterModel roaster) async {
    //Add Roaster
  }
  Future<void> deleteRoaster() async {
    //Delete Roaster
  }

//Abstract Functions for all database access
  Future<void> _add(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = database.from(path);
    debugPrint('$path: $data');
    await reference.insert(data);
  }

  Future<List<Map<String, dynamic>>> _select({required String path}) async {
    final reference = database.from(path);

    return await reference.select();
  }
}
