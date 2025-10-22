import '../../../support/styles/app_colors.dart';
import '../../../support/utils/constants.dart';
import '../../../support/view/view.dart';
import '../../../support/view/view_model.dart';

abstract class PassengerViewModelProtocol extends ViewModel {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              onChanged: widget.viewModel.updateDestination,
              decoration: const InputDecoration(hintText: 'Para onde vamos?'),
            ),
            const SizedBox(height: 16),
            const Placeholder(),
            const SizedBox(height: 16),
            const Text('Caronas disponíveis'),
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
        ),
      ),
    );
  }
}

class DriverTile extends StatelessWidget {
  const DriverTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gray30),
      ),
      child: Row(
        spacing: 16,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              Constants.avatar,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('João da Silva'),
              Text('HB20 Branca PXV4A34'),
            ],
          ),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Solicitar'),
          ),
        ],
      ),
    );
  }
}
