import '../../../support/utils/constants.dart';
import '../../../support/view/view.dart';
import '../../../support/view/view_model.dart';
import '../components/shell_tab_bar.dart';
import '../home_factory.dart';

abstract class ShellViewModelProtocol extends ViewModel {
  void didTapProfile();
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
          actions: [
            InkWell(
              onTap: viewModel.didTapProfile,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  Constants.avatar,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.only(right: 16),
          bottom: const PreferredSize(
            preferredSize: Size(double.infinity, 44),
            child: Padding(
              child: ShellTabBar(),
              padding: EdgeInsets.symmetric(horizontal: 16),
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
