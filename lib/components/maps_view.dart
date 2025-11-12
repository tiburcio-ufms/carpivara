import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/maps_route_data.dart';

class MapsView extends StatefulWidget {
  final LatLng? destination;
  final MapsRouteData? route;
  final Function(GoogleMapController)? onMapReady;
  final LatLng? currentLocation;
  final bool isNavigationMode;

  const MapsView({
    super.key,
    this.onMapReady,
    this.destination,
    this.route,
    this.currentLocation,
    this.isNavigationMode = false,
  });

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestLocationPermissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final location = widget.currentLocation ?? _currentLocation;

    if (_isLoading && location == null) return const Center(child: CircularProgressIndicator());
    if (location == null && !widget.isNavigationMode) {
      return const Center(child: Text('Localização não disponível'));
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: location ?? const LatLng(0, 0),
        zoom: widget.isNavigationMode ? 17 : 14,
        tilt: widget.isNavigationMode ? 45 : 0,
      ),
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: widget.isNavigationMode,
      markers: _buildMarkers(),
      polylines: _buildPolylines(),
      mapType: widget.isNavigationMode ? MapType.normal : MapType.normal,
    );
  }

  Set<Polyline> _buildPolylines() {
    if (widget.route == null) return {};
    return {
      Polyline(
        polylineId: const PolylineId('route'),
        points: widget.route!.points,
        color: Colors.blue,
        width: 5,
      ),
    };
  }

  Set<Marker> _buildMarkers() {
    if (widget.destination == null) return {};
    return {
      Marker(
        markerId: const MarkerId('destination'),
        position: widget.destination!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    widget.onMapReady?.call(controller);

    if (widget.route != null) {
      _updateCameraForRoute();
    } else if (widget.destination != null && _currentLocation != null) {
      _adjustCameraToDestination(_currentLocation!, widget.destination!);
    }
  }

  void _updateCameraForRoute() {
    if (_mapController == null || widget.route == null) return;
    try {
      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(widget.route!.bounds, 75));
    } on Exception catch (_) {
      // Controller foi descartado, ignorar
      _mapController = null;
    }
  }

  void _adjustCameraToDestination(LatLng origin, LatLng destination) {
    if (_mapController == null) return;
    final minLat = origin.latitude < destination.latitude ? origin.latitude : destination.latitude;
    final maxLat = origin.latitude > destination.latitude ? origin.latitude : destination.latitude;
    final minLng = origin.longitude < destination.longitude ? origin.longitude : destination.longitude;
    final maxLng = origin.longitude > destination.longitude ? origin.longitude : destination.longitude;
    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
    try {
      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 75));
    } on Exception catch (_) {
      // Controller foi descartado, ignorar
      _mapController = null;
    }
  }

  @override
  void didUpdateWidget(MapsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final routeChanged = oldWidget.route != widget.route;
    final destinationChanged = oldWidget.destination != widget.destination;
    final locationChanged = oldWidget.currentLocation != widget.currentLocation;
    final navigationModeChanged = oldWidget.isNavigationMode != widget.isNavigationMode;

    // Se estiver em modo navegação e a localização mudou, não atualizar a câmera aqui
    // (o ViewModel já faz isso)
    if (widget.isNavigationMode && locationChanged) {
      setState(() {});
      return;
    }

    if (navigationModeChanged && !widget.isNavigationMode && widget.route != null) {
      _updateCameraForRoute();
      setState(() {});
    } else if (routeChanged && widget.route != null && !widget.isNavigationMode) {
      _updateCameraForRoute();
      setState(() {});
    } else if (destinationChanged &&
        widget.destination != null &&
        _currentLocation != null &&
        !widget.isNavigationMode) {
      _adjustCameraToDestination(_currentLocation!, widget.destination!);
      setState(() {});
    }
  }

  Future<void> _requestLocationPermissions() async {
    var locationPermission = PermissionStatus.denied;

    locationPermission = await Permission.location.request();

    if (locationPermission.isGranted) {
      await _getCurrentLocation();
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
    } on Exception catch (_) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _mapController = null;
    super.dispose();
  }
}
