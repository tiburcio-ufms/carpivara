import '../../../support/styles/app_colors.dart';
import '../../../support/styles/app_images.dart';
import '../../../support/utils/constants.dart';
import '../../../support/view/view.dart';
import '../../../support/view/view_model.dart';

abstract class DriverViewModelProtocol extends ViewModel {
  bool get onlyWoman;
  void Function()? showRideAlert;

  void didTapRejectRide();
  void didTapAcceptRide();
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
    _bind();
  }

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
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _bind() {
    widget.viewModel.showRideAlert = () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Nova solicitação de carona'),
          content: Column(
            spacing: 16,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Marina A.'),
                      const Text('Psicologia 3º semestre'),
                      Text(
                        'Ponto de coleta',
                        style: TextTheme.of(context).bodyLarge,
                      ),
                      const Text('Facom'),
                      Text(
                        'Destino',
                        style: TextTheme.of(context).bodyLarge,
                      ),
                      const Text('Rua 1, 368 Jardim América'),
                    ],
                  ),
                ],
              ),
              const Text('Sem desvios na sua rota'),
            ],
          ),
          actions: [
            OutlinedButton(
              child: const Text('Recusar'),
              onPressed: widget.viewModel.didTapRejectRide,
            ),
            ElevatedButton(
              child: const Text('Aceitar'),
              onPressed: widget.viewModel.didTapAcceptRide,
            ),
          ],
        ),
      );
    };
  }
}
