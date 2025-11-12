import '../../../support/utils/constants.dart';
import '../../../support/view/view.dart';
import '../../../support/view/view_model.dart';
import '../components/shell_tab_bar.dart';
import '../home_factory.dart';

abstract class ShellViewModelProtocol extends ViewModel {
  void didTapProfile();
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
            preferredSize: Size(double.infinity, 60),
            child: Padding(
              child: ShellTabBar(),
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            ),
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            HomeFactory.driver(context),
            HomeFactory.passenger(context),
          ],
        ),
      ),
    );
  }
}
