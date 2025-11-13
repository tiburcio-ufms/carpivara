import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../components/maps_view.dart';
import '../../../models/maps_route_data.dart';
import '../../../models/ride.dart';
import '../../../models/user.dart';
import '../../../support/styles/app_colors.dart';
import '../../../support/view/view.dart';
import '../../../support/view/view_model.dart';

abstract class LiveViewModelProtocol extends ViewModel {
  Ride? get currentRide;
  MapsRouteData? get route;
  bool get isDriver;
  User? get otherUser;
  String get destinationAddress;
  String? get rideStatus;
  LatLng? get destinationLatLng;
  LatLng? get currentUserLocation;
  bool get isNavigationMode;

  void onMapReady(GoogleMapController controller);
  void toggleNavigationMode();
  Future<void> finishRide();
  Future<void> cancelRide();
}

class LiveView extends View<LiveViewModelProtocol> {
  const LiveView({super.key, required super.viewModel});

  @override
  void initState() {
    super.initState();
    viewModel.toggleNavigationMode();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewPadding.bottom;
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.currentRide == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Viagem em andamento')),
          body: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                MapsView(
                  route: viewModel.route,
                  onMapReady: viewModel.onMapReady,
                  destination: viewModel.destinationLatLng,
                  currentLocation: viewModel.currentUserLocation,
                  isNavigationMode: viewModel.isNavigationMode,
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: FloatingActionButton.small(
                    onPressed: viewModel.toggleNavigationMode,
                    backgroundColor: viewModel.isNavigationMode ? Colors.blue : Colors.grey,
                    child: Icon(
                      viewModel.isNavigationMode ? Icons.navigation : Icons.map,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, bottom),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.gray30),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.gray30),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                spacing: 16,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      viewModel.otherUser?.profilePic.isNotEmpty ?? false
                                          ? viewModel.otherUser!.profilePic
                                          : 'assets/man_avatar_1.png',
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      spacing: 4,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          viewModel.otherUser?.name ??
                                              (viewModel.isDriver ? 'Passageiro' : 'Motorista'),
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        if (viewModel.otherUser != null)
                                          Text(
                                            viewModel.isDriver
                                                ? '${viewModel.otherUser!.course} - ${viewModel.otherUser!.semester}'
                                                : '${viewModel.otherUser!.carModel ?? ''} ${viewModel.otherUser!.carPlate ?? ''}',
                                          ),
                                        if (viewModel.otherUser != null)
                                          Row(
                                            spacing: 4,
                                            children: [
                                              const Icon(Icons.star, size: 16, color: Colors.amber),
                                              Text(
                                                viewModel.otherUser!.rating,
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                spacing: 8,
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: viewModel.isLoading ? null : viewModel.cancelRide,
                                      child: const Row(
                                        spacing: 8,
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.close, size: 18),
                                          Text('Cancelar'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (viewModel.isDriver)
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: viewModel.isLoading ? null : viewModel.finishRide,
                                        child: const Row(
                                          spacing: 8,
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.check, size: 18),
                                            Text('Finalizar'),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 16, color: AppColors.lightBlue),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Destino: ${viewModel.destinationAddress}',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                            if (viewModel.currentRide?.confirmationDate != null)
                              Text(
                                '* Carona aceita às ${_formatTime(viewModel.currentRide!.confirmationDate!)}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            if (viewModel.currentRide?.startDate != null)
                              Text(
                                '* Viagem iniciada às ${_formatTime(viewModel.currentRide!.startDate!)}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
