import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../components/maps_view.dart';
import '../../../models/maps_route_data.dart';
import '../../../models/place_prediction.dart';
import '../../../models/user.dart';
import '../../../support/styles/app_colors.dart';
import '../../../support/view/view.dart';
import '../../../support/view/view_model.dart';
import '../components/driver_tile.dart';

abstract class PassengerViewModelProtocol extends ViewModel {
  bool get isWoman;
  bool get onlyWoman;
  String get destinationQuery;
  List<PlacePrediction> get placePredictions;
  List<User> get availableDrivers;
  LatLng? get destinationLatLng;
  MapsRouteData? get route;
  bool get hasRequestedRide;

  void didTapOnlyWomanSwitch(bool value);
  void updateDestination(String destination);
  void selectPlace(PlacePrediction prediction);
  void requestRide(User driver);
  void cancelRide();
  void onMapReady(GoogleMapController controller);
  void clearDestination();
}

class PassengerView extends StatefulWidget {
  final PassengerViewModelProtocol viewModel;
  const PassengerView({super.key, required this.viewModel});

  @override
  State<PassengerView> createState() => _PassengerViewState();
}

class _PassengerViewState extends State<PassengerView> with AutomaticKeepAliveClientMixin {
  late final FocusNode _destinationFocusNode;
  late final TextEditingController _destinationController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _destinationFocusNode = FocusNode();
    _destinationController = TextEditingController(text: widget.viewModel.destinationQuery);
    widget.viewModel.setContext(context);
    widget.viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _destinationController.dispose();
    widget.viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    if (widget.viewModel.destinationQuery != _destinationController.text) {
      _destinationFocusNode.unfocus();
      _destinationController.value = TextEditingValue(
        text: widget.viewModel.destinationQuery,
        selection: TextSelection.collapsed(offset: widget.viewModel.destinationQuery.length),
      );
    }
  }

  Widget? get _searchBarSuffixIcon {
    if (widget.viewModel.destinationQuery.isEmpty) return null;
    return IconButton(
      icon: const Icon(Icons.clear),
      onPressed: widget.viewModel.clearDestination,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        return Stack(
          children: [
            MapsView(
              route: widget.viewModel.route,
              onMapReady: widget.viewModel.onMapReady,
              destination: widget.viewModel.destinationLatLng,
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                              color: Colors.black.withValues(alpha: 0.1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              focusNode: _destinationFocusNode,
                              controller: _destinationController,
                              onChanged: widget.viewModel.updateDestination,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Para onde vamos?',
                                suffixIcon: _searchBarSuffixIcon,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ),
                            if (widget.viewModel.placePredictions.isNotEmpty)
                              Container(
                                constraints: const BoxConstraints(maxHeight: 200),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: widget.viewModel.placePredictions.length,
                                  itemBuilder: (context, index) {
                                    final prediction = widget.viewModel.placePredictions[index];
                                    final hasSecondaryText = prediction.secondaryText != null;
                                    return ListTile(
                                      leading: const Icon(Icons.location_on),
                                      onTap: () => widget.viewModel.selectPlace(prediction),
                                      title: Text(prediction.mainText ?? prediction.description),
                                      subtitle: hasSecondaryText ? Text(prediction.secondaryText!) : null,
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            DraggableScrollableSheet(
              minChildSize: 0.4,
              maxChildSize: 0.6,
              initialChildSize: 0.4,
              builder: (context, scrollController) {
                return DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.gray30,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  const Text('Solicitações de carona'),
                                  const Spacer(),
                                  if (widget.viewModel.isWoman) const Text('Apenas mulheres'),
                                  if (widget.viewModel.isWoman) const SizedBox(width: 8),
                                  if (widget.viewModel.isWoman)
                                    Switch(
                                      value: widget.viewModel.onlyWoman,
                                      onChanged: widget.viewModel.didTapOnlyWomanSwitch,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (widget.viewModel.isLoading)
                                const Center(
                                  child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()),
                                )
                              else if (widget.viewModel.hasRequestedRide)
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      spacing: 16,
                                      children: [
                                        const CircularProgressIndicator(),
                                        const Text('Aguardando aceite do motorista...'),
                                        OutlinedButton(
                                          onPressed: widget.viewModel.cancelRide,
                                          child: const Text('Cancelar'),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else if (widget.viewModel.availableDrivers.isEmpty &&
                                  widget.viewModel.destinationQuery.isNotEmpty)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text('Nenhum motorista disponível'),
                                  ),
                                )
                              else if (widget.viewModel.availableDrivers.isNotEmpty)
                                Column(
                                  spacing: 8,
                                  mainAxisSize: MainAxisSize.min,
                                  children: widget.viewModel.availableDrivers.map((driver) {
                                    return DriverTile(
                                      driver: driver,
                                      onRequest: () => widget.viewModel.requestRide(driver),
                                    );
                                  }).toList(),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
