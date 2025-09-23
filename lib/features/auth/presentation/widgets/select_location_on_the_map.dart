import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

class SelectableLocationMap extends StatefulWidget {
  const SelectableLocationMap({
    super.key,
    required this.onLocationSelected,
    this.initialSelection,
    this.initialZoom,
    this.cardElevation,
    this.borderRadius,
    this.height,
    this.placeholderText,
  });

  final ValueChanged<LatLng> onLocationSelected;
  final LatLng? initialSelection;
  final double? initialZoom;
  final double? cardElevation;
  final double? borderRadius;
  final double? height;
  final String? placeholderText;

  @override
  State<SelectableLocationMap> createState() => _SelectableLocationMapState();
}

class _SelectableLocationMapState extends State<SelectableLocationMap> {
  static const double _defaultZoom = 15;
  static const double _defaultHeight = 220;
  LatLng? _currentCenter;
  LatLng? _selected;
  bool _locationReady = false;
  bool _permissionDenied = false;

  final Completer<GoogleMapController> _smallMapCtrl = Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelection;
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      final permOk = await _ensureLocationPermission();
      if (!permOk) {
        setState(() {
          _permissionDenied = true;
          _locationReady = true;
        });
        return;
      }

      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      setState(() {
        _currentCenter = LatLng(pos.latitude, pos.longitude);
        _locationReady = true;
      });
    } catch (_) {
      setState(() => _locationReady = true);
    }
  }

  Future<bool> _ensureLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) return false;
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return false;
      }
    }
    return true;
  }

  Future<void> _openPicker() async {
    final startCenter = _selected ?? _currentCenter;

    final result = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => _FullscreenMapPickerPage(initialCenter: startCenter),
      ),
    );

    if (result != null) {
      setState(() => _selected = result);
      widget.onLocationSelected(result);
      _animateSmallMapTo(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.height ?? _defaultHeight;

    return Card(
          elevation: widget.cardElevation ?? 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: height,
            child: Stack(
              children: [_buildMapOrPlaceholder(), _buildTopStatus(), _buildTapToSelect()],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms)
        .move(begin: const Offset(0, 12), end: Offset.zero, duration: 300.ms);
  }

  Widget _buildMapOrPlaceholder() {
    if (!_locationReady && _currentCenter == null && _selected == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final cameraTarget = _selected ?? _currentCenter ?? const LatLng(0, 0);
    final zoom = widget.initialZoom ?? _defaultZoom;

    final markers = <Marker>{
      if (_selected != null) Marker(markerId: const MarkerId('selected'), position: _selected!),
    };

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: cameraTarget, zoom: zoom),
      markers: markers,
      myLocationEnabled: !_permissionDenied && _currentCenter != null,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapType: MapType.normal,

      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      scrollGesturesEnabled: false,
      zoomGesturesEnabled: false,
      compassEnabled: false,
      onTap: (_) => _openPicker(),
      mapToolbarEnabled: false,
      onMapCreated: (controller) {
        if (!_smallMapCtrl.isCompleted) _smallMapCtrl.complete(controller);
      },
    );
  }

  Widget _buildTopStatus() {
    final msg =
        _permissionDenied
            ? (widget.placeholderText ?? 'Location permission denied — tap to pick')
            : _selected != null
            ? 'Selected: ${_selected!.latitude.toStringAsFixed(5)}, ${_selected!.longitude.toStringAsFixed(5)}'
            : (widget.placeholderText ?? 'Centered on your location');

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              msg,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          )
          .animate()
          .fadeIn(duration: 300.ms)
          .then(delay: 100.ms)
          .scaleXY(begin: 0.98, end: 1.0, duration: 200.ms),
    );
  }

  Widget _buildTapToSelect() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).colorScheme.primary,
                elevation: 6,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _openPicker,
              icon: const Icon(Icons.place),
              label: const Text('Pick location', style: TextStyle(fontWeight: FontWeight.bold)),
            )
            .animate()
            .slideY(begin: 0.2, end: 0, duration: 250.ms, curve: Curves.easeOut)
            .fadeIn(duration: 250.ms),
      ),
    );
  }

  Future<void> _animateSmallMapTo(LatLng target, {double? zoom}) async {
    try {
      final c = await _smallMapCtrl.future;
      final z = zoom ?? 15;
      await c.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: target, zoom: z)),
      );
    } catch (_) {}
  }
}

class _FullscreenMapPickerPage extends StatefulWidget {
  const _FullscreenMapPickerPage({this.initialCenter});
  final LatLng? initialCenter;

  @override
  State<_FullscreenMapPickerPage> createState() => _FullscreenMapPickerPageState();
}

class _FullscreenMapPickerPageState extends State<_FullscreenMapPickerPage> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _center;
  LatLng? _chosen;
  bool _hasPermission = false;
  bool _loading = true;

  static const double _zoom = 16;

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  Future<void> _prepare() async {
    try {
      _hasPermission = await _checkPermissionQuick();
      if (widget.initialCenter != null) {
        _center = widget.initialCenter;
      } else if (_hasPermission) {
        final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
        _center = LatLng(pos.latitude, pos.longitude);
      } else {
        _center = const LatLng(0, 0);
      }
    } catch (_) {
      _center = const LatLng(0, 0);
    }
    setState(() => _loading = false);
  }

  Future<bool> _checkPermissionQuick() async {
    final perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.always || perm == LocationPermission.whileInUse) {
      return await Geolocator.isLocationServiceEnabled();
    }
    return false;
  }

  void _onMapTap(LatLng latLng) => setState(() => _chosen = latLng);

  Future<void> _recenterToMe() async {
    if (!_hasPermission) return;
    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    final me = LatLng(pos.latitude, pos.longitude);
    final c = await _controller.future;
    await c.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: me, zoom: _zoom)));
    setState(() => _center = me);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick a location'),
        backgroundColor: GPSColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Close',
        ),
        actions: [
          InkWell(
            onTap: _chosen == null ? null : () => Navigator.of(context).pop(_chosen),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: GPSColors.primary.withGreen(70),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body:
          _loading || _center == null
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  GoogleMap(
                        initialCameraPosition: CameraPosition(target: _center!, zoom: _zoom),
                        onMapCreated: _controller.complete,
                        onTap: _onMapTap,
                        myLocationEnabled: _hasPermission,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: true,
                        mapType: MapType.normal,

                        scrollGesturesEnabled: true,
                        zoomGesturesEnabled: true,
                        rotateGesturesEnabled: true,
                        tiltGesturesEnabled: true,
                        markers: {
                          if (_chosen != null)
                            Marker(markerId: const MarkerId('chosen'), position: _chosen!),
                        },
                      )
                      .animate()
                      .fadeIn(duration: 250.ms)
                      .scale(
                        begin: const Offset(0.98, 0.98),
                        end: const Offset(1, 1),
                        duration: 200.ms,
                      ),
                  if (_hasPermission)
                    Positioned(
                      right: 16,
                      bottom: 96,
                      child: FloatingActionButton.small(
                            onPressed: _recenterToMe,
                            child: const Icon(Icons.my_location),
                          )
                          .animate()
                          .fadeIn(duration: 250.ms)
                          .slideY(begin: 0.12, end: 0, duration: 250.ms),
                    ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: _BottomInfoBar(chosen: _chosen),
                  ),
                ],
              ),
    );
  }
}

class _BottomInfoBar extends StatelessWidget {
  const _BottomInfoBar({required this.chosen});
  final LatLng? chosen;

  @override
  Widget build(BuildContext context) {
    final txt =
        chosen == null
            ? 'Tap anywhere to choose'
            : 'Chosen: ${chosen!.latitude.toStringAsFixed(5)}, ${chosen!.longitude.toStringAsFixed(5)}';
    return SizedBox();
    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.55),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            txt,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        )
        .animate()
        .fadeIn(duration: 250.ms)
        .move(begin: const Offset(0, 10), end: Offset.zero, duration: 250.ms);
  }
}
