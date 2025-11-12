import '../../../models/ride.dart';
import '../../../support/styles/app_colors.dart';
import '../../../support/view/view.dart';
import '../../../support/view/view_model.dart';
import 'components/ride_tile.dart';

abstract class HistoryViewModelProtocol extends ViewModel {
  List<Ride> get rides;
}

class HistoryView extends View<HistoryViewModelProtocol> {
  const HistoryView({super.key, required super.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de viagens')),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (_, _) {
          if (viewModel.isLoading) return const Center(child: CircularProgressIndicator());
          if (viewModel.rides.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.history, size: 64, color: AppColors.gray30),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma viagem encontrada',
                    style: TextTheme.of(context).bodyLarge?.copyWith(color: AppColors.gray30),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.rides.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (_, index) => RideTile(ride: viewModel.rides[index]),
          );
        },
      ),
    );
  }
}
