import '../../../components/maps_view.dart';
import '../../../models/ride.dart';
import '../../../support/styles/app_colors.dart';
import '../../../support/styles/app_images.dart';
import '../../../support/view/view.dart';
import '../../../support/view/view_model.dart';
import '../components/passenger_ride_tile.dart';

abstract class DriverViewModelProtocol extends ViewModel {
  bool get isWoman;
  bool get onlyWoman;
  List<Ride> get availableRides;
  void Function()? showRideAlert;

  void didTapRejectRide(Ride ride);
  void didTapAcceptRide(Ride ride);
  void didTapOnlyWomanSwitch(bool value);
}

class DriverView extends StatefulWidget {
  final DriverViewModelProtocol viewModel;
  const DriverView({super.key, required this.viewModel});

  @override
  State<DriverView> createState() => _DriverViewState();
}

class _DriverViewState extends State<DriverView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    widget.viewModel.setContext(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        const MapsView(),
        DraggableScrollableSheet(
          minChildSize: 0.4,
          maxChildSize: 0.6,
          initialChildSize: 0.4,
          builder: (context, scrollController) {
            return ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, child) {
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
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.gray30,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              else if (widget.viewModel.availableRides.isEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 56),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppColors.gray30),
                                  ),
                                  child: Column(
                                    spacing: 16,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.asset(AppImages.logo, width: 56, height: 56),
                                          ),
                                        ],
                                      ),
                                      const Text('Aguardando solicitações de caronas'),
                                    ],
                                  ),
                                )
                              else
                                Column(
                                  spacing: 8,
                                  mainAxisSize: MainAxisSize.min,
                                  children: widget.viewModel.availableRides.map((ride) {
                                    return PassengerRideTile(
                                      ride: ride,
                                      onAccept: () => widget.viewModel.didTapAcceptRide(ride),
                                      onReject: () => widget.viewModel.didTapRejectRide(ride),
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
            );
          },
        ),
      ],
    );
  }
}
