import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_app/features/search/cubits/search_cubit/search_cubit.dart';
import 'package:gps_app/features/search/models/suggestion_model/suggestion_model.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/restaurant_detail_provider.dart';
import 'package:gps_app/features/user/store_details/presentation/store_details_screen.dart';
// adjust imports as needed

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(27.6648, 81.5158),
    zoom: 14,
  );

  static const double hueAllLocations = BitmapDescriptor.hueAzure;
  static const double hueSuggestions = BitmapDescriptor.hueGreen;
  static const double hueSelected = BitmapDescriptor.hueRed;

  final _eagerGestures = <Factory<OneSequenceGestureRecognizer>>{
    Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
  };

  late SearchCubit cubit;

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    cubit = context.read<SearchCubit>();
    _rebuildMarkersFromState(cubit.state);
    _maybeGoToCurrent();
  }

  Future<void> _maybeGoToCurrent() async {
    final current = cubit.state.currentLocation;
    if (current == null) return;
    if (!_controller.isCompleted) return;

    final controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: current, zoom: 16)),
    );
  }

  Future<void> _goToLatLng(LatLng target, {double zoom = 16}) async {
    if (!_controller.isCompleted) return;
    final controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: target, zoom: zoom)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchCubit, SearchState>(
      listener: (context, state) async {
        if (state.searchStateEnum == SearchStateEnum.allLocationsFetched ||
            state.searchStateEnum == SearchStateEnum.update ||
            state.searchStateEnum == SearchStateEnum.suggestionSelected ||
            state.searchStateEnum == SearchStateEnum.currentLocationAvailable) {
          _rebuildMarkersFromState(state);
        }

        if (state.searchStateEnum == SearchStateEnum.currentLocationAvailable) {
          await _maybeGoToCurrent();
        }

        if (state.searchStateEnum == SearchStateEnum.suggestionSelected &&
            state.selectedSuggestion?.location?.latitude != null &&
            state.selectedSuggestion?.location?.longitude != null) {
          final loc = state.selectedSuggestion!.location!;
          await _goToLatLng(LatLng(loc.latitude!, loc.longitude!), zoom: 17);
        }
      },
      buildWhen:
          (previous, current) => [
            SearchStateEnum.currentLocationAvailable,
            SearchStateEnum.allLocationsFetched,
            SearchStateEnum.suggestionSelected,
          ].contains(current.searchStateEnum),
      builder: (context, state) {
        return GoogleMap(
          gestureRecognizers: _eagerGestures,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          tiltGesturesEnabled: true,
          rotateGesturesEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          markers: _markers,
          onMapCreated: (controller) {
            _controller.complete(controller);
            _maybeGoToCurrent();
          },
        );
      },
    );
  }

  void _rebuildMarkersFromState(SearchState state) {
    final Set<Marker> next = {};

    final selected = state.selectedSuggestion;

    // 1) All Locations layer
    final allLocations = state.allLocations?.data ?? const <SuggestionModel>[];
    for (final s in allLocations) {
      final lat = s.location?.latitude;
      final lng = s.location?.longitude;
      if (lat == null || lng == null) continue;

      final isSelected = selected != null && _sameSuggestion(selected, s);
      final hue = isSelected ? hueSelected : hueAllLocations;
      final zIndex = isSelected ? 100.0 : 10.0;

      next.add(
        Marker(
          markerId: MarkerId('all_${_keyFor(s)}'),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(hue),
          zIndex: zIndex,
          infoWindow: InfoWindow(
            title: s.name ?? '',
            onTap: () {
              // pr('hello world');
              if (s.type == 'farm' || s.type == 'store') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (_) => StoreDetailsScreen(
                          userId: s.userId,
                          publicPage: true,
                          enableEdit: false,
                          enableCompleteProfile: true,
                        ),
                  ),
                );
              } else if (s.type == 'restaurant') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (_) => RestaurantDetailProvider(
                          restaurantId: s.restaurantId ?? -1,
                          enableEdit: false,
                        ),
                  ),
                );
              }
            },
          ),
          onTap: () {},
        ),
      );
    }

    // 2) Suggestions layer (render after so they sit above by default)
    final suggestions = state.suggestions?.data ?? const <SuggestionModel>[];
    for (final s in suggestions) {
      final lat = s.location?.latitude;
      final lng = s.location?.longitude;
      if (lat == null || lng == null) continue;

      final isSelected = selected != null && _sameSuggestion(selected, s);
      final hue = isSelected ? hueSelected : hueSuggestions;
      final zIndex = isSelected ? 200.0 : 20.0;

      next.add(
        Marker(
          markerId: MarkerId('sug_${_keyFor(s)}'),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(hue),
          zIndex: zIndex,
          infoWindow: InfoWindow(
            title: s.name ?? '',
            onTap: () {
              // TODO: navigate to profile screen
            },
          ),
          onTap: () {
            // no-op; InfoWindow shows. Optionally: cubit.selectSuggestion(s);
          },
        ),
      );
    }

    if (mounted) {
      setState(() => _markers = next);
    }
  }

  bool _sameSuggestion(SuggestionModel a, SuggestionModel b) {
    if (a.vendorId != null && b.vendorId != null) return a.vendorId == b.vendorId;
    if (a.restaurantId != null && b.restaurantId != null) return a.restaurantId == b.restaurantId;
    if (a.userId != null && b.userId != null) return a.userId == b.userId;
    return (a.name != null && b.name != null && a.name == b.name);
  }

  String _keyFor(SuggestionModel s) {
    return (s.vendorId?.toString() ??
            s.restaurantId?.toString() ??
            s.userId?.toString() ??
            s.name ??
            UniqueKey().toString())
        .toString();
  }
}
