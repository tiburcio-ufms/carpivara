import '../../../support/components/default_scroll.dart';
import '../../../support/styles/app_images.dart';
import '../../../support/view/view.dart';
import '../../../support/view/view_model.dart';

abstract class SignInViewModelProtocol extends ViewModel {
  String? get passportError;
  String? get passwordError;

  void didTapSignIn();
  void updatePassport(String passport);
  void updatePassword(String password);
}

class SignInView extends View<SignInViewModelProtocol> {
  const SignInView({super.key, required super.viewModel});

  Widget get _actionWidget {
    if (!viewModel.isLoading) return const Text('Entrar');
    return const CircularProgressIndicator(padding: EdgeInsets.symmetric(vertical: 8));
  }

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
                keyboardType: TextInputType.number,
                onChanged: viewModel.updatePassport,
                decoration: InputDecoration(hintText: '000000000000', errorText: viewModel.passportError),
              ),
              const SizedBox(height: 16),
              const Text('Senha'),
              TextFormField(
                obscureText: true,
                onChanged: viewModel.updatePassword,
                decoration: InputDecoration(hintText: '************', errorText: viewModel.passwordError),
              ),
              const SizedBox(height: 56),
              ElevatedButton(
                child: _actionWidget,
                onPressed: viewModel.didTapSignIn,
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
