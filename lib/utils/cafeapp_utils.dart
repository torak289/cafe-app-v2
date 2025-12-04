import 'dart:async';
import 'dart:io';

import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:cafeapp_v2/data_models/roaster_model.dart';
import 'package:cafeapp_v2/widgets/map/markers/cafe_marker.dart';
import 'package:cafeapp_v2/widgets/map/markers/roaster_marker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class CafeappUtils {
  static List<String> stringListFromJson(List<dynamic> data) {
    try {
      List<String> strings = List.from(data);
      return strings;
    } catch (e) {
      debugPrint("String List From Json ERROR: $e");
      return List.empty();
    }
  }

  static Future<MarkerLayer> cafeMarkersLayer(
      Future<List<CafeMarker>> cafeMarkers,
      AnimatedMapController animatedMapController) async {
    try {
      return MarkerLayer(markers: await cafeMarkers);
    } catch (e) {
      debugPrint("Cafes Markers Layer ERROR: $e");
      throw Exception(e);
    }
  }

  static List<CafeMarker> cafesToMarkers(List<CafeModel> cafes,
      AnimatedMapController mapController) {
    try {
      List<CafeMarker> cafeMarkers = List.empty(growable: true);
      for (int i = 0; i < cafes.length; i++) {
        cafeMarkers.add(CafeMarker(
            cafe: cafes[i], mapController: mapController));
      }
      return cafeMarkers;
    } catch (e) {
      debugPrint("Cafes To Markers ERROR: $e");
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

  static void launchMap(LatLng position) async {
    if (Platform.isAndroid) {
      try {
        const String markerLabel = 'Here';
        final url = Uri.parse(
            'geo:${position.latitude},${position.longitude}?q=${position.latitude},${position.longitude}($markerLabel)');
        await launchUrl(url);
      } catch (e) {
        rethrow;
      }
    } else if (Platform.isIOS) {
      try {
        final url = Uri.parse(
            'maps:${position.latitude},${position.longitude}?q=${position.latitude},${position.longitude}');
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          throw 'Could not launch $url';
        }
      } catch (e) {
        rethrow;
      }
    }
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});
  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
