import '../../../support/view/view.dart';
import '../../../support/view/view_model.dart';
import '../components/driver_tile.dart';

abstract class PassengerViewModelProtocol extends ViewModel {
  bool get onlyWoman;

  void didTapOnlyWomanSwitch(bool value);
  void updateDestination(String destination);
}

class PassengerView extends StatefulWidget {
  final PassengerViewModelProtocol viewModel;
  const PassengerView({super.key, required this.viewModel});

  @override
  State<PassengerView> createState() => _PassengerViewState();
}

class _PassengerViewState extends State<PassengerView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  onChanged: widget.viewModel.updateDestination,
                  decoration: const InputDecoration(hintText: 'Para onde vamos?'),
                ),
                const SizedBox(height: 16),
                const Placeholder(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Solicitações de carona'),
                    const Spacer(),
                    const Text('Apenas mulheres'),
                    const SizedBox(width: 8),
                    Switch(
                      value: widget.viewModel.onlyWoman,
                      onChanged: widget.viewModel.didTapOnlyWomanSwitch,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Column(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DriverTile(),
                    DriverTile(),
                    DriverTile(),
                    DriverTile(),
                    DriverTile(),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
