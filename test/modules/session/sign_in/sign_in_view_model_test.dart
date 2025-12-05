import 'package:carpivara/models/session.dart';
import 'package:carpivara/models/user.dart';
import 'package:carpivara/modules/session/sign_in/sign_in_view_model.dart';
import 'package:carpivara/repositories/session_repository.dart';
import 'package:carpivara/support/utils/result.dart';
import 'package:carpivara/support/utils/session_manager.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock classes
class MockSessionRepository implements SessionRepositoryProtocol {
  Result<Session>? signInResult;

  @override
  Future<Result<Session>> signIn(Map<String, dynamic> credentials) async {
    return signInResult ?? Result.error(Exception('Not configured'));
  }
}

class MockSessionManager implements SessionManagerProtocol {
  Session? _session;
  bool saveSessionCalled = false;
  Session? savedSession;

  @override
  Session? get session => _session;

  @override
  bool get hasSession => _session != null;

  @override
  Future<bool> verifySession() async {
    return _session != null;
  }

  @override
  Future<void> saveSession(Session session) async {
    saveSessionCalled = true;
    savedSession = session;
    _session = session;
  }

  @override
  Future<void> removeSession() async {
    _session = null;
  }
}

void main() {
  group('SignInViewModel', () {
    late MockSessionRepository mockRepository;
    late MockSessionManager mockSessionManager;
    late SignInViewModel viewModel;

    setUp(() {
      mockRepository = MockSessionRepository();
      mockSessionManager = MockSessionManager();
      viewModel = SignInViewModel(
        sessionRepository: mockRepository,
        sessionManager: mockSessionManager,
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('initial state has no errors', () {
      expect(viewModel.passportError, isNull);
      expect(viewModel.passwordError, isNull);
      expect(viewModel.isLoading, isFalse);
    });

    test('updatePassport updates passport value', () {
      viewModel.updatePassport('123456789012');
      // Note: passport is private, so we test through validation
      expect(viewModel.passportError, isNull);
    });

    test('updatePassword updates password value', () {
      viewModel.updatePassword('password123');
      // Note: password is private, so we test through validation
      expect(viewModel.passwordError, isNull);
    });

    test('passport validation - empty passport', () {
      viewModel.updatePassport('');
      viewModel.didTapSignIn();
      expect(viewModel.passportError, equals('Passaporte é obrigatório'));
    });

    test('passport validation - invalid length', () {
      viewModel.updatePassport('12345');
      viewModel.didTapSignIn();
      expect(viewModel.passportError, equals('Passaporte deve ter 12 caracteres'));
    });

    test('passport validation - non-numeric characters', () {
      viewModel.updatePassport('12345678901a');
      viewModel.didTapSignIn();
      expect(viewModel.passportError, equals('Passaporte deve ter apenas números'));
    });

    test('passport validation - valid passport', () {
      viewModel.updatePassport('123456789012');
      viewModel.didTapSignIn();
      expect(viewModel.passportError, isNull);
    });

    test('password validation - empty password', () {
      viewModel.updatePassword('');
      viewModel.didTapSignIn();
      expect(viewModel.passwordError, equals('Senha é obrigatória'));
    });

    test('password validation - too short', () {
      viewModel.updatePassword('short');
      viewModel.didTapSignIn();
      expect(viewModel.passwordError, equals('Senha deve ter pelo menos 8 caracteres'));
    });

    test('password validation - valid password', () {
      viewModel.updatePassword('password123');
      viewModel.didTapSignIn();
      expect(viewModel.passwordError, isNull);
    });

    test('didTapSignIn - successful sign in', () async {
      final testUser = User(
        id: 1,
        passport: '123456789012',
        name: 'Test User',
        course: 'Computer Science',
        profilePic: '',
        rating: '4.5',
        ridesAsDriver: '10',
        ridesAsPassenger: '5',
        semester: '8',
        isWoman: false,
      );
      final testSession = Session(
        token: 'test_token',
        user: testUser,
      );

      viewModel.updatePassport('123456789012');
      viewModel.updatePassword('password123');

      mockRepository.signInResult = Result.ok(testSession);

      viewModel.didTapSignIn();

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      expect(mockSessionManager.saveSessionCalled, isTrue);
      expect(mockSessionManager.savedSession, equals(testSession));
    });

    test('didTapSignIn - failed sign in', () async {
      viewModel.updatePassport('123456789012');
      viewModel.updatePassword('password123');

      mockRepository.signInResult = Result.error(Exception('Invalid credentials'));

      var failureCalled = false;
      String? failureMessage;
      viewModel.setRenderFailure((message) {
        failureCalled = true;
        failureMessage = message;
      });

      viewModel.didTapSignIn();

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      expect(failureCalled, isTrue);
      expect(failureMessage, contains('Invalid credentials'));
      expect(mockSessionManager.saveSessionCalled, isFalse);
    });

    test('didTapSignIn - does not sign in if form is invalid', () async {
      viewModel.updatePassport('');
      viewModel.updatePassword('');

      viewModel.didTapSignIn();

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      expect(mockSessionManager.saveSessionCalled, isFalse);
    });
  });
}
