import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BranchMapScreen extends StatefulWidget {
  const BranchMapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    this.title = 'Branch Location',
    this.zoom,
  });

  final String latitude;
  final String longitude;

  final String title;
  final double? zoom;

  @override
  State<BranchMapScreen> createState() => _BranchMapScreenState();
}

class _BranchMapScreenState extends State<BranchMapScreen> {
  late final double? _lat = double.tryParse(widget.latitude.trim());
  late final double? _lng = double.tryParse(widget.longitude.trim());
  GoogleMapController? _controller;

  late final bool _valid = _lat != null && _lng != null;
  late final LatLng _target = LatLng(_lat ?? 0, _lng ?? 0);

  static const double _defaultZoom = 16;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_valid) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Branch Location'),
          backgroundColor: Colors.black87,
        ),
        body: const Center(
          child: Text(
            'Invalid coordinates. Unable to show map.',
            style: TextStyle(color: Colors.black54),
          ),
        ),
      );
    }

    final markers = <Marker>{
      Marker(markerId: const MarkerId('branch-marker'), position: _target),
    };

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0,

          title: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              shadows: [Shadow(blurRadius: 6, color: Colors.black54)],
            ),
          ),
          leading: IconButton(
            tooltip: 'Back',
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _target,
                    zoom: widget.zoom ?? _defaultZoom,
                  ),
                  markers: markers,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: true,
                  compassEnabled: true,
                  buildingsEnabled: true,
                  tiltGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  onMapCreated: (c) => _controller = c,
                )
                .animate()
                .fadeIn(duration: 250.ms)
                .scale(
                  begin: const Offset(1.02, 1.02),
                  end: const Offset(1, 1),
                ),

            IgnorePointer(
              child: Container(
                height:
                    kToolbarHeight + MediaQuery.of(context).padding.top + 12,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x99000000), Colors.transparent],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
