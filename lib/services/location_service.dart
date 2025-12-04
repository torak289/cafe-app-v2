import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationService extends ChangeNotifier {
  final LocationFilter _locationFilter = LocationFilter();

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
    return Geolocator.getPositionStream(locationSettings: _locationSettings)
        .map((position) => _locationFilter.filterLocation(position));
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
  // Separate Kalman filters for latitude and longitude
  double _lastEstimateLat = 0.0;
  double _lastEstimateLng = 0.0;
  double _errorEstimateLat = 1.0;
  double _errorEstimateLng = 1.0;
  
  // Process noise (Q) - how much we expect the location to change
  final double _errorProcess = 0.01; // Reduced for smoother movement
  
  bool _isInitialized = false;

  Position filterLocation(Position location) {
    // Initialize the filter with the first location
    if (!_isInitialized) {
      _lastEstimateLat = location.latitude;
      _lastEstimateLng = location.longitude;
      _errorEstimateLat = 5.0;
      _errorEstimateLng = 5.0;
      _isInitialized = true;
      return location;
    }

    // Use GPS accuracy as measurement noise, with a minimum threshold
    final double measurementNoise = location.accuracy.clamp(3.0, 50.0);

    // Filter latitude
    final latResult = _filterCoordinate(
      location.latitude,
      _lastEstimateLat,
      _errorEstimateLat,
      measurementNoise,
    );
    _lastEstimateLat = latResult['estimate']!;
    _errorEstimateLat = latResult['error']!;

    // Filter longitude  
    final lngResult = _filterCoordinate(
      location.longitude,
      _lastEstimateLng,
      _errorEstimateLng,
      measurementNoise,
    );
    _lastEstimateLng = lngResult['estimate']!;
    _errorEstimateLng = lngResult['error']!;

    return Position(
      latitude: _lastEstimateLat,
      longitude: _lastEstimateLng,
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

  Map<String, double> _filterCoordinate(
    double measurement,
    double lastEstimate,
    double errorEstimate,
    double measurementNoise,
  ) {
    // Prediction step
    double predictedEstimate = lastEstimate;
    double predictedError = errorEstimate + _errorProcess;

    // Update step (Kalman gain)
    double kalmanGain = predictedError / (predictedError + measurementNoise);

    // Calculate new estimate
    double newEstimate = predictedEstimate + kalmanGain * (measurement - predictedEstimate);

    // Update error estimate for next iteration
    double newError = (1.0 - kalmanGain) * predictedError;

    return {
      'estimate': newEstimate,
      'error': newError,
    };
  }

  /// Reset the filter state (useful when starting a new tracking session)
  void reset() {
    _isInitialized = false;
    _lastEstimateLat = 0.0;
    _lastEstimateLng = 0.0;
    _errorEstimateLat = 1.0;
    _errorEstimateLng = 1.0;
  }
}
