import '../../../support/styles/app_colors.dart';
import '../../../support/utils/constants.dart';
import '../../../support/view/view.dart';
import '../../../support/view/view_model.dart';

abstract class LiveViewModelProtocol extends ViewModel {}

class LiveView extends View<LiveViewModelProtocol> {
  const LiveView({super.key, required super.viewModel});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewPadding.bottom;
    return Scaffold(
      appBar: AppBar(title: const Text('Viagem em andamento')),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const Placeholder(),
            const Spacer(),
            Container(
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
                                Text('Lucas A.'),
                                Text('HB20 Branca PXV4A34'),
                              ],
                            ),
                            const Spacer(),
                            const Text('12 min'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: () {},
                          child: const Row(
                            spacing: 8,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.chat),
                              Text('Chat'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Column(
                    spacing: 4,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('* Marina Embarcou às 09:48'),
                      Text('* Carona aceita às 09:45'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
