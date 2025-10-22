import '../../../support/styles/app_colors.dart';
import '../../../support/styles/app_images.dart';
import '../../../support/view/view.dart';
import '../../../support/view/view_model.dart';

abstract class DriverViewModelProtocol extends ViewModel {}

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
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Placeholder(),
            const SizedBox(height: 16),
            const Text('Solicitações de carona'),
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
        ),
      ),
    );
  }
}
