import '../../../support/view/view.dart';
import '../../../support/view/view_model.dart';
import '../components/shell_tab_bar.dart';
import '../home_factory.dart';

abstract class ShellViewModelProtocol extends ViewModel {
  void didTapTab(int index);
  void updateDestination(String destination);
}

class ShellView extends View<ShellViewModelProtocol> {
  const ShellView({super.key, required super.viewModel});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CarPivara'),
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 44),
            child: Padding(
              child: ShellTabBar(onTap: viewModel.didTapTab),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            HomeFactory.driver(context),
            HomeFactory.passenger(context),
          ],
        ),
      ),
    );
  }
}
