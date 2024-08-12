import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> _determinePosition() async {
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
    return await Geolocator.getCurrentPosition();
  }
  Future<Position> getCurrentPosition() {
    return _determinePosition();
  }
  Future<Position> getPointPosition() {
    //Return the position of the center of the screen for passing when creating a cafe, roaster or etc...

    return _determinePosition(); //TODO: Replace with actual point position return.
  }
}
