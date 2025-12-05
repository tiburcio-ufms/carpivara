import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/maps_route_data.dart';
import '../../models/place_details.dart';
import '../../models/place_prediction.dart';
import '../../support/utils/result.dart';
import '../places_repository.dart';

class PlacesRepositoryMock implements PlacesRepositoryProtocol {
  @override
  Future<Result<List<PlacePrediction>>> getPlacePredictions(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (query.length < 3) return const Result.ok([]);
    if (query.toLowerCase().contains('rua')) {
      return Result.ok([
        PlacePrediction(
          placeId: '1',
          description: 'Rua A, Cidade',
          mainText: 'Rua A',
          secondaryText: 'Cidade',
        ),
        PlacePrediction(
          placeId: '2',
          description: 'Rua B, Cidade',
          mainText: 'Rua B',
          secondaryText: 'Cidade',
        ),
      ]);
    }

    return const Result.ok([]);
  }

  @override
  Future<Result<PlaceDetails>> getPlaceDetails(String placeId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Result.ok(
      PlaceDetails(
        placeId: placeId,
        formattedAddress: 'Endereço Detalhado $placeId',
        latitude: -20.4692 + (int.tryParse(placeId) ?? 0) * 0.001,
        longitude: -54.6201 + (int.tryParse(placeId) ?? 0) * 0.001,
      ),
    );
  }

  @override
  Future<Result<MapsRouteData>> getDirections(LatLng origin, LatLng destination) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Criar pontos intermediários para simular uma rota
    final points = [
      origin,
      LatLng(
        (origin.latitude + destination.latitude) / 2,
        (origin.longitude + destination.longitude) / 2,
      ),
      destination,
    ];

    final minLat = origin.latitude < destination.latitude ? origin.latitude : destination.latitude;
    final maxLat = origin.latitude > destination.latitude ? origin.latitude : destination.latitude;
    final minLng = origin.longitude < destination.longitude ? origin.longitude : destination.longitude;
    final maxLng = origin.longitude > destination.longitude ? origin.longitude : destination.longitude;

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    return Result.ok(MapsRouteData(points: points, bounds: bounds));
  }
}
