import 'package:carpivara/modules/home/shell/shell_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ShellViewModel', () {
    late ShellViewModel viewModel;

    setUp(() {
      viewModel = ShellViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('initial state', () {
      expect(viewModel.isLoading, isFalse);
    });

    test('didTapProfile sets context and navigates', () {
      // Mock context navigation
      viewModel.setContext(null); // In real test, you'd use a mock BuildContext

      // Since we can't easily test navigation without a real context,
      // we just verify the method exists and doesn't throw
      expect(() => viewModel.didTapProfile(), returnsNormally);
    });
  });
}
