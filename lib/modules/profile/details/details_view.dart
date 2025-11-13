import '../../../models/address.dart';
import '../../../support/styles/app_colors.dart';
import '../../../support/view/view.dart';
import '../../../support/view/view_model.dart';
import 'components/address_tile.dart';

abstract class DetailsViewModelProtocol extends ViewModel {
  String get rating;
  String get ridesAsDriver;
  String get ridesAsPassenger;
  String get profilePic;
  String get name;
  String get course;
  String get passport;
  String get semester;
  List<Address> get addresses;

  void didTapLogout();
  void didTapHistory();
  void didTapPreferences();
  void didTapAddAddress();
  void didTapEditAddress(Address address);
  void didTapDeleteAddress(Address address);
}

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
                            viewModel.profilePic,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(viewModel.name),
                            Text('${viewModel.course} - ${viewModel.semester}'),
                            Text('RGA: ${viewModel.passport}'),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(viewModel.ridesAsPassenger),
                            const Text('Passageiro'),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(viewModel.ridesAsDriver),
                            const Text('Motorista'),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(viewModel.rating),
                            const Text('Avaliação'),
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
                          child: const Text('Adicionar'),
                          onPressed: viewModel.didTapAddAddress,
                          style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
                        ),
                      ],
                    ),
                    ...viewModel.addresses.map((address) {
                      return AddressTile(
                        address: address,
                        onEdit: viewModel.didTapEditAddress,
                        onDelete: viewModel.didTapDeleteAddress,
                      );
                    }),
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
                  spacing: 16,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Configurações', style: TextTheme.of(context).bodyLarge),
                    InkWell(
                      onTap: viewModel.didTapHistory,
                      child: const Row(
                        spacing: 12,
                        children: [
                          Icon(Icons.settings_outlined),
                          Text('Histórico de viagens'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                child: const Text('Sair'),
                onPressed: viewModel.didTapLogout,
                style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
