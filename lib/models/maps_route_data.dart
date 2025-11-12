import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsRouteData {
  final List<LatLng> points;
  final LatLngBounds bounds;

  MapsRouteData({
    required this.points,
    required this.bounds,
  });
}
