import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({required this.uid}) : assert(uid != null);

  Future<void> addCafe(CafeModel cafe) async {
    //Add Cafe
  }
  Future<void> deleteCafe(CafeModel cafe) async {
    //Delete Cafe
  }
  Future<void> addRoaster() async {
    //Add Roaster
  }
  Future<void> deleteRoaster() async {
    //Delete Roaster
  }

}
