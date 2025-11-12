import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/maps_route_data.dart';
import '../models/place_details.dart';
import '../models/place_prediction.dart';
import '../services/places_service.dart';
import '../support/utils/result.dart';

abstract class PlacesRepositoryProtocol {
  Future<Result<List<PlacePrediction>>> getPlacePredictions(String query);
  Future<Result<PlaceDetails>> getPlaceDetails(String placeId);
  Future<Result<MapsRouteData>> getDirections(LatLng origin, LatLng destination);
}

class PlacesRepository extends PlacesRepositoryProtocol {
  final PlacesServiceProtocol _service;

  PlacesRepository({required PlacesServiceProtocol service}) : _service = service;

  @override
  Future<Result<List<PlacePrediction>>> getPlacePredictions(String query) async {
    try {
      final response = await _service.getPlacePredictions(query);
      if (response is Error) return Result.error(response.error);

      final data = (response as Ok).value as Map<String, dynamic>;
      final predictionsData = data['predictions'] as List<dynamic>?;
      if (predictionsData == null) return const Result.ok([]);
      final predictions = predictionsData.map((json) => PlacePrediction.fromJson(json)).toList();
      return Result.ok(predictions);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result<PlaceDetails>> getPlaceDetails(String placeId) async {
    try {
      final response = await _service.getPlaceDetails(placeId);
      if (response is Error) return Result.error(response.error);

      final data = (response as Ok).value as Map<String, dynamic>;
      final result = data['result'] as Map<String, dynamic>;
      return Result.ok(PlaceDetails.fromJson(result));
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result<MapsRouteData>> getDirections(LatLng origin, LatLng destination) async {
    try {
      final response = await _service.getDirections(
        origin.latitude,
        origin.longitude,
        destination.latitude,
        destination.longitude,
      );
      if (response is Error) return Result.error(response.error);

      final data = (response as Ok).value as Map<String, dynamic>;
      if (data['status'] == 'OK' && data['routes'] != null && (data['routes'] as List).isNotEmpty) {
        final routeData = (data['routes'] as List).first as Map<String, dynamic>;
        final overviewPolyline = routeData['overview_polyline'] as Map<String, dynamic>?;
        final encodedPoints = overviewPolyline?['points'] as String?;

        if (encodedPoints != null) {
          final points = _decodePolyline(encodedPoints);
          final bounds = _calculateBounds([origin, destination, ...points]);
          return Result.ok(MapsRouteData(points: points, bounds: bounds));
        }
      }

      // Fallback: criar rota simples com origem e destino
      final bounds = _calculateBounds([origin, destination]);
      return Result.ok(MapsRouteData(points: [origin, destination], bounds: bounds));
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    final points = <LatLng>[];
    var index = 0;
    var lat = 0;
    var lng = 0;

    while (index < encoded.length) {
      var shift = 0;
      var result = 0;
      int byte;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      final dlat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      final dlng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
  }

  LatLngBounds _calculateBounds(List<LatLng> points) {
    if (points.isEmpty) {
      return LatLngBounds(
        southwest: const LatLng(0, 0),
        northeast: const LatLng(0, 0),
      );
    }

    var minLat = points.first.latitude;
    var maxLat = points.first.latitude;
    var minLng = points.first.longitude;
    var maxLng = points.first.longitude;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
}
