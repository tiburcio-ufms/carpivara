import 'package:dio/dio.dart';

import '../support/config/env_config.dart';
import '../support/utils/result.dart';

abstract class PlacesServiceProtocol {
  Future<Result> getPlacePredictions(String query);
  Future<Result> getPlaceDetails(String placeId);
  Future<Result> getDirections(double originLat, double originLng, double destLat, double destLng);
}

class PlacesService implements PlacesServiceProtocol {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place';
  final Dio _dio = Dio();

  String get _apiKey => EnvConfig.googlePlacesApiKey;

  @override
  Future<Result> getPlacePredictions(String query) async {
    try {
      if (query.isEmpty) return const Result.ok({'status': 'OK', 'predictions': []});

      final response = await _dio.get(
        '$_baseUrl/autocomplete/json',
        queryParameters: {
          'input': query,
          'key': _apiKey,
          'language': 'pt-BR',
          'components': 'country:br',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['status'] == 'OK') return Result.ok(data);
        return Result.error(Exception(data['status'] as String));
      }
      return Result.error(Exception('Failed to fetch predictions'));
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result> getPlaceDetails(String placeId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/details/json',
        queryParameters: {
          'place_id': placeId,
          'key': _apiKey,
          'language': 'pt-BR',
          'fields': 'place_id,formatted_address,geometry,name',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['status'] == 'OK') return Result.ok(data);
        return Result.error(Exception(data['status'] as String));
      }
      return Result.error(Exception('Failed to fetch place details'));
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result> getDirections(double originLat, double originLng, double destLat, double destLng) async {
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/directions/json',
        queryParameters: {
          'origin': '$originLat,$originLng',
          'destination': '$destLat,$destLng',
          'key': _apiKey,
          'language': 'pt-BR',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['status'] == 'OK') return Result.ok(data);
        return Result.error(Exception(data['status'] as String));
      }
      return Result.error(Exception('Failed to fetch directions'));
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}
