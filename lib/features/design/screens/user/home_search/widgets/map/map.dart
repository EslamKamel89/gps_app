import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_app/core/helpers/snackbar.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Position? _currentLocation;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(27.6648, 81.5158),
    zoom: 14,
  );

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showSnackbar('Location services', 'Location services are disabled', true);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showSnackbar(
          'Location permissions',
          'Location permissions are denied',
          true,
        );
      }
    }
    if (permission == LocationPermission.deniedForever) {
      showSnackbar(
        'Location permissions',
        'Location permissions are permanently denied, we cannot request permissions.',
        true,
      );
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition();

      log("latitude: ${position.latitude.toString()}");
      log("longitude: ${position.longitude.toString()}");
      // showSnackbar('Location permissions', 'Location permissions are granted', false);
    }
    return await Geolocator.getCurrentPosition();
  }

  final _eagerGestures = <Factory<OneSequenceGestureRecognizer>>{
    Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
  };

  @override
  void initState() {
    getCurrentLocation().then((p) {
      _currentLocation = p;
      _maybeGoToCurrent();
    });
    super.initState();
  }

  Future<void> _maybeGoToCurrent() async {
    if (_currentLocation == null) return;
    if (!_controller.isCompleted) return;

    final GoogleMapController controller = await _controller.future;
    final target = LatLng(
      _currentLocation!.latitude,
      _currentLocation!.longitude,
    );

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: target, zoom: 16)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      gestureRecognizers: _eagerGestures,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
      tiltGesturesEnabled: true,
      rotateGesturesEnabled: true,
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        _maybeGoToCurrent();
      },
    );
  }
}
