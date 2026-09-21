import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position?> getCurrentLocation() async {
    // Check whether location service is enabled
    bool serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return null;
    }

    // Check permission
    LocationPermission permission =
        await Geolocator.checkPermission();

    // Request permission
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Permission permanently denied
    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    // Permission denied
    if (permission == LocationPermission.denied) {
      return null;
    }

    // Get current location
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }
}