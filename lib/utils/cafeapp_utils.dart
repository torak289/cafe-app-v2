import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:cafeapp_v2/data_models/roaster_model.dart';
import 'package:cafeapp_v2/widgets/map/markers/cafe_marker.dart';
import 'package:cafeapp_v2/widgets/map/markers/roaster_marker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';

class CafeappUtils {
  static List<CafeModel> cafesFromJson(List<Map<String, dynamic>> data) {
    try {
      List<CafeModel> cafes = List.empty(growable: true);
      for (int i = 0; i < data.length; i++) {
        cafes.add(CafeModel.fromJson(data[i]));
      }
      return cafes;
    } catch (e) {
      throw Exception(e);
    }
  }
  static Future<MarkerLayer> cafeMarkersLayer(Future<List<CafeMarker>> cafeMarkers, AnimatedMapController animatedMapController ) async {
    try {
      return MarkerLayer(markers: await cafeMarkers);
    } catch (e){
      throw Exception(e);
    }
  }
  static List<CafeMarker> cafesToMarkers(List<CafeModel> cafes, AnimatedMapController mapController) {
    try {
      List<CafeMarker> cafeMarkers = List.empty(growable: true);
      for (int i = 0; i < cafes.length; i++) {
        cafeMarkers
            .add(CafeMarker(cafe: cafes[i], mapController: mapController));
      }
      return cafeMarkers;
    } catch (e) {
      throw Exception(e);
    }
  }

  static List<RoasterMarker> roastersToMarkers(List<RoasterModel> roasters) {
    try {
      List<RoasterMarker> roasterMarkers = List.empty(growable: true);

      for (int i = 0; i < roasters.length; i++) {
        //TODO: Implement roaster to markers converstion...
      }
      return roasterMarkers;
    } catch (e) {
      throw Exception(e);
    }
  }
}
