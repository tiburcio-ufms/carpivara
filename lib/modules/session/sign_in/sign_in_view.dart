import '../../../support/components/default_scroll.dart';
import '../../../support/styles/app_images.dart';
import '../../../support/view/view.dart';
import '../../../support/view/view_model.dart';

abstract class SignInViewModelProtocol extends ViewModel {
  void didTapSignIn();
  void updatePassport(String passport);
  void updatePassword(String password);
}

class SignInView extends View<SignInViewModelProtocol> {
  const SignInView({super.key, required super.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DefaultScroll(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(AppImages.logo, width: 100, height: 100),
                  ),
                ],
              ),
              const Spacer(),
              const Text('Passaporte UFMS'),
              TextFormField(
                onChanged: viewModel.updatePassport,
                decoration: const InputDecoration(hintText: '0000.0000.000-0'),
              ),
              const SizedBox(height: 16),
              const Text('Senha'),
              TextFormField(
                obscureText: true,
                onChanged: viewModel.updatePassword,
                decoration: const InputDecoration(hintText: '************'),
              ),
              const SizedBox(height: 56),
              ElevatedButton(
                onPressed: viewModel.didTapSignIn,
                child: const Text('Entrar'),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
