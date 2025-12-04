import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationService extends ChangeNotifier {
  Future<LocationPermission> checkServices() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return permission;
  }

  Stream<Position> get positionStream {
    return Geolocator.getPositionStream(locationSettings: _locationSettings);
  }

  Future<Position> get currentPosition {
    return Geolocator.getCurrentPosition();
  }

  void openLocationSetting() {
    Geolocator.openAppSettings();
  }

  LocationSettings get _locationSettings {
    if (Platform.isAndroid) {
      return AndroidSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 5,
        forceLocationManager: false,
        intervalDuration: const Duration(seconds: 2),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText:
              'Robusta is using your location to show nearby cafés.',
          notificationTitle: 'Robusta is active',
          enableWakeLock: false,
        ),
      );
    }

    if (Platform.isIOS) {
      return AppleSettings(
        accuracy: LocationAccuracy.best,
        activityType: ActivityType.other,
        distanceFilter: 5,
        pauseLocationUpdatesAutomatically: false,
      );
    }

    return const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 5,
    );
  }
}

class LocationFilter {
  double _lastEstimate = 0.0;
  double _kalmanGain = 0.0;
  final double _errorMeasure = 0.1;
  final double _errorProcess = 0.01;

  List<double> filterCoordinates(List<double> rawValues) {
    List<double> filteredValues = [];

    for (double currentMeasurement in rawValues) {
      // Prediction step
      double prediction = _lastEstimate;
      _errorEstimate = _errorEstimate + _errorProcess;

      // Update step
      _kalmanGain = _errorEstimate / (_errorEstimate + _errorMeasure);
      double currentEstimate =
          prediction + _kalmanGain * (currentMeasurement - prediction);
      _errorEstimate = (1.0 - _kalmanGain) * _errorEstimate;

      // Save for next iteration
      _lastEstimate = currentEstimate;
      filteredValues.add(currentEstimate);
    }

    return filteredValues;
  }

  Position filterLocation(Position location) {
    final filteredLat = filterCoordinates([location.latitude])[0];
    final filteredLng = filterCoordinates([location.longitude])[0];

    return Position(
      longitude: filteredLat,
      latitude: filteredLng,
      timestamp: location.timestamp,
      accuracy: location.accuracy,
      altitude: location.altitude,
      altitudeAccuracy: location.altitudeAccuracy,
      heading: location.heading,
      headingAccuracy: location.headingAccuracy,
      speed: location.speed,
      speedAccuracy: location.speedAccuracy,
    );
  }
}
