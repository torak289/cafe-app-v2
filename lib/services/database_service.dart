import 'dart:async';
import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:cafeapp_v2/data_models/coffee_model.dart';
import 'package:cafeapp_v2/data_models/loyalty_card_model.dart';
import 'package:cafeapp_v2/utils/cafeapp_utils.dart';
import 'package:cafeapp_v2/widgets/map/markers/cafe_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  List<CafeModel> cafeMarkers = List<CafeModel>.empty(
      growable: true); //TODO: look to move out of here and into a provider
  int cafeMarkersLength = 50;

  /*List<RoasterModel> roaster = List<RoasterModel>.empty(
      growable: true); //TODO: Implement Roasters in App... */

  final SupabaseClient _database = Supabase.instance.client;

  DatabaseService();

  Future<bool> deleteSelf() async {
    //TODO: Implment edge function
    try {
      final res = await _database.functions.invoke('delete_user');
      final data = res.data;
      if (data) {
        return data; //TODO: Implement bool in edge function return...
      } else {
        return false;
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<CafeModel>> semanticSearch(
    String text,
    Position currentPos, {
    List<double>? embedding, // pass null to skip semantic scoring
    int radiusM = 2500,
    int maxResults = 5,
  }) async {
    try {
      final data = await _selectUsingFunc(
        func: 'search_cafes_hybrid',
        params: {
          'q_text': text,
          'q_embedding': embedding, // List<double>? or null
          'user_lon': currentPos.latitude, // <-- correct param names
          'user_lat': currentPos
              .longitude, //Weirdness for lat long storage in the DB???
          'radius_m': radiusM,
          'max_results': maxResults,
        },
      );

      return (data as List)
          .map((row) => CafeModel.fromJson(row as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> reviewCafe(String uuid, double coffeeScore, atmosphereScore,
      serviceScore, bool? wifi, bool? laptopFriendly, String? content) async {
    try {
      await _selectUsingFunc(func: 'add_cafe_review', params: {
        'p_cafe_id': uuid,
        'p_score': coffeeScore,
        'p_atmosphere_score': atmosphereScore,
        'p_service_score': serviceScore,
        'p_wifi': wifi,
        'p_laptop_friendly': laptopFriendly,
        'p_content': content,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> validateLoyaltyCode(String uuid, int count) async {
    try {
      debugPrint("UUID: $uuid, COUNT: $count");
      //TODO: Call and pass args to edge function
      //TODO: return success or fail from edge function...

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

  Future<List<CafeModel>> getOwnedCafeData() async {
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
      await _database.rpc('edit_cafe_name', params: {'new_name': newName});
      return "Success";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> editCafeDescription(String newDescription) async {
    return 'Success';
  }

  Future<void> addCafe(CafeModel cafe) async {
    try {
      bool res = await _database
          .rpc('create_new_cafe', params: {'cafe': cafe.toJson()});
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> requestVerification(String uid) async {
    try {
      bool res = await _database.rpc(
        "request_cafe_verification",
        params: {'cafe_uid': uid},
      );
      return res;
    } catch (e) {
      return Future.error(e);
    }

    // return true;
  }

  Future<List<CoffeeModel>> getCoffeeList() async {
    try {
      final data = await _database.from('coffees').select('name');
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
      AnimatedMapController mapController, BuildContext context) async {
    List<CafeMarker> markers = List.empty(growable: true);
    try {
      // Wait for the map controller to be ready by polling
      int attempts = 0;
      const maxAttempts = 50; // 5 seconds total with 100ms delays
      LatLngBounds? bounds;
      
      while (bounds == null && attempts < maxAttempts) {
        try {
          bounds = mapController.mapController.camera.visibleBounds;
          break;
        } catch (e) {
          attempts++;
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }
      
      if (bounds == null) {
        throw Exception('MapController camera failed to initialize');
      }
      
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
      markers =
          CafeappUtils.cafesToMarkers(cafeMarkers, mapController, context);

      return MarkerLayer(markers: markers);
    } catch (e) {
      debugPrint(e.toString());
      _database.auth.refreshSession();
      return Future.error(e);
    }
  }

  Future<CafeModel?> getCafeData(String uuid) async {
    try {
      final result =
          await _selectSingleUsingFunc(func: 'get_cafe_by_uuid', params: {
        'uuid': uuid,
      });

      return CafeModel.fromJson(result);
    } catch (e) {
      debugPrint(e.toString());
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
    final reference = _database.from(path);
    debugPrint('$path: $data');
    await reference.insert(data);
  }

  Future<List<Map<String, dynamic>>> _selectUsingFunc(
      {required String func, Map<String, dynamic>? params}) async {
    final data = await _database.rpc(func, params: params).select();
    return data;
  }

  Future<Map<String, dynamic>> _selectSingleUsingFunc(
      {required String func, Map<String, dynamic>? params}) async {
    final data = await _database.rpc(func, params: params);
    return data as Map<String, dynamic>;
  }
}
