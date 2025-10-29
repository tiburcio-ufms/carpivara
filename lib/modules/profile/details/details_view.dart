import '../../../support/styles/app_colors.dart';
import '../../../support/utils/constants.dart';
import '../../../support/view/view.dart';
import '../../../support/view/view_model.dart';

abstract class DetailsViewModelProtocol extends ViewModel {}

class DetailsView extends View<DetailsViewModelProtocol> {
  const DetailsView({super.key, required super.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu perfil')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.gray30),
                ),
                child: Column(
                  spacing: 8,
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
                            Text('Camila Ribeiro'),
                            Text('Sistemas de Informação - 5º Semestre'),
                            Text('RGA: 2021.1234.567-8'),
                          ],
                        ),
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('24'),
                            Text('Passageiro'),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('12'),
                            Text('Motorista'),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('4.8'),
                            Text('Avaliação'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.gray30),
                ),
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 16,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Meus locais', style: TextTheme.of(context).bodyLarge),
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text('Adicionar'),
                          style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Row(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.location_on_outlined),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Casa'),
                                Text('Rua das Flores, 534, Santa Barbara'),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.edit_outlined),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.gray30),
                ),
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Configurações', style: TextTheme.of(context).bodyLarge),
                    const Row(
                      spacing: 12,
                      children: [
                        Icon(Icons.settings_outlined),
                        Text('Preferências de carona'),
                      ],
                    ),
                    const Row(
                      spacing: 12,
                      children: [
                        Icon(Icons.settings_outlined),
                        Text('Histórico de viagens'),
                      ],
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Sair'),
                style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
