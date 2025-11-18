import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_app/core/helpers/snackbar.dart';

Future<LatLng?> getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    showSnackbar(
      'Error',
      'Location services are disabled. Please enable them.',
      true,
    );
    return null;
  }

  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      showSnackbar('Error', 'Location permissions are denied.', true);
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    showSnackbar(
      'Error',
      'Location permissions are permanently denied. Please enable them in settings.',
      true,
    );
    return null;
  }

  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  return LatLng(position.latitude, position.longitude);
}

Future<Map<String, double?>?> getCurrentLocationToRequestBody() async {
  LatLng? location = await getCurrentLocation();
  return {"latitude": location?.latitude, "longitude": location?.longitude};
}
