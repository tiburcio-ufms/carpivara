import 'package:carpivara/models/address.dart';
import 'package:carpivara/models/session.dart';
import 'package:carpivara/models/user.dart';
import 'package:carpivara/modules/profile/details/details_view_model.dart';
import 'package:carpivara/repositories/address_repository.dart';
import 'package:carpivara/support/utils/result.dart';
import 'package:carpivara/support/utils/session_manager.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock classes
class MockAddressRepository implements AddressRepositoryProtocol {
  Result<List<Address>>? getAddressesResult;
  Result<Address>? createAddressResult;
  Result<Address>? updateAddressResult;
  Result<void>? deleteAddressResult;

  @override
  Future<Result<List<Address>>> getAddresses() async {
    return getAddressesResult ?? Result.error(Exception('Not configured'));
  }

  @override
  Future<Result<Address>> createAddress(Address address) async {
    return createAddressResult ?? Result.error(Exception('Not configured'));
  }

  @override
  Future<Result<Address>> updateAddress(Address address) async {
    return updateAddressResult ?? Result.error(Exception('Not configured'));
  }

  @override
  Future<Result<void>> deleteAddress(int id) async {
    return deleteAddressResult ?? Result.error(Exception('Not configured'));
  }
}

class MockSessionManager implements SessionManagerProtocol {
  Session? _session;

  @override
  Session? get session => _session;

  @override
  bool get hasSession => _session != null;

  @override
  Future<bool> verifySession() async {
    return _session != null;
  }

  void setSession(Session session) {
    _session = session;
  }

  @override
  Future<void> saveSession(Session session) async {
    _session = session;
  }

  @override
  Future<void> removeSession() async {
    _session = null;
  }
}

void main() {
  group('DetailsViewModel', () {
    late MockAddressRepository mockRepository;
    late MockSessionManager mockSessionManager;
    late DetailsViewModel viewModel;

    final testUser = User(
      id: 1,
      passport: '123456789012',
      name: 'Test User',
      course: 'Computer Science',
      profilePic: 'https://example.com/pic.jpg',
      rating: '4.5',
      ridesAsDriver: '10',
      ridesAsPassenger: '5',
      semester: '8',
      isWoman: false,
    );

    final testAddress = Address(
      id: 1,
      userId: 1,
      street: 'Test Street',
      number: '123',
      neighborhood: 'Test Neighborhood',
      complement: '',
      city: 'Test City',
      state: 'Test State',
      country: 'Brasil',
      postalCode: '12345-678',
      nickname: 'Home',
    );

    setUp(() {
      mockRepository = MockAddressRepository();
      mockSessionManager = MockSessionManager();
      final session = Session(token: 'token', user: testUser);
      mockSessionManager.setSession(session);
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('initial state loads user data', () {
      mockRepository.getAddressesResult = const Result.ok([]);

      viewModel = DetailsViewModel(
        sessionManager: mockSessionManager,
        addressRepository: mockRepository,
      );

      expect(viewModel.name, equals(testUser.name));
      expect(viewModel.course, equals(testUser.course));
      expect(viewModel.rating, equals(testUser.rating));
      expect(viewModel.ridesAsDriver, equals(testUser.ridesAsDriver));
      expect(viewModel.ridesAsPassenger, equals(testUser.ridesAsPassenger));
      expect(viewModel.profilePic, equals(testUser.profilePic));
      expect(viewModel.semester, equals(testUser.semester));
    });

    test('loads addresses on initialization', () async {
      mockRepository.getAddressesResult = Result.ok([testAddress]);

      viewModel = DetailsViewModel(
        sessionManager: mockSessionManager,
        addressRepository: mockRepository,
      );

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      expect(viewModel.addresses.length, equals(1));
      expect(viewModel.addresses.first.id, equals(1));
    });

    test('didTapLogout removes session and navigates', () async {
      mockRepository.getAddressesResult = const Result.ok([]);

      viewModel = DetailsViewModel(
        sessionManager: mockSessionManager,
        addressRepository: mockRepository,
      );

      await viewModel.didTapLogout();

      expect(mockSessionManager.session, isNull);
    });

    test('didTapAddAddress creates address successfully', () async {
      mockRepository.getAddressesResult = const Result.ok([]);
      mockRepository.createAddressResult = Result.ok(testAddress);

      viewModel = DetailsViewModel(
        sessionManager: mockSessionManager,
        addressRepository: mockRepository,
      );

      // Mock dialog to return address
      Address? dialogResult;
      viewModel.setRenderDialog(<T>(dialog) async {
        dialogResult = testAddress;
        return testAddress as T;
      });

      await viewModel.didTapAddAddress();

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      expect(dialogResult, isNotNull);
    });

    test('didTapEditAddress updates address successfully', () async {
      mockRepository.getAddressesResult = Result.ok([testAddress]);
      final updatedAddress = Address(
        id: 1,
        userId: 1,
        street: 'Updated Street',
        number: '456',
        neighborhood: 'Updated Neighborhood',
        complement: '',
        city: 'Updated City',
        state: 'Updated State',
        country: 'Brasil',
        postalCode: '98765-432',
        nickname: 'Work',
      );
      mockRepository.updateAddressResult = Result.ok(updatedAddress);

      viewModel = DetailsViewModel(
        sessionManager: mockSessionManager,
        addressRepository: mockRepository,
      );

      // Wait for initial load
      await Future.delayed(const Duration(milliseconds: 100));

      // Mock dialog to return updated address
      viewModel.setRenderDialog(<T>(dialog) async {
        return updatedAddress as T;
      });

      await viewModel.didTapEditAddress(testAddress);

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      // Address should be reloaded
      expect(viewModel.addresses.isNotEmpty, isTrue);
    });

    test('didTapDeleteAddress deletes address successfully', () async {
      mockRepository.getAddressesResult = Result.ok([testAddress]);
      mockRepository.deleteAddressResult = const Result.ok(null);
      mockRepository.getAddressesResult = const Result.ok([]); // After deletion

      viewModel = DetailsViewModel(
        sessionManager: mockSessionManager,
        addressRepository: mockRepository,
      );

      // Wait for initial load
      await Future.delayed(const Duration(milliseconds: 100));

      // Mock dialog to return true (confirmed)
      viewModel.setRenderDialog(<T>(dialog) async {
        return true as T;
      });

      await viewModel.didTapDeleteAddress(testAddress);

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      // Addresses should be reloaded (empty now)
      expect(viewModel.addresses.isEmpty, isTrue);
    });

    test('didTapDeleteAddress does not delete if not confirmed', () async {
      mockRepository.getAddressesResult = Result.ok([testAddress]);

      viewModel = DetailsViewModel(
        sessionManager: mockSessionManager,
        addressRepository: mockRepository,
      );

      // Wait for initial load
      await Future.delayed(const Duration(milliseconds: 100));

      // Mock dialog to return false (not confirmed)
      viewModel.setRenderDialog(<T>(dialog) async {
        return false as T;
      });

      await viewModel.didTapDeleteAddress(testAddress);

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      // Address should still be there
      expect(viewModel.addresses.length, equals(1));
    });

    test('didTapDeleteAddress shows error for invalid address', () async {
      mockRepository.getAddressesResult = const Result.ok([]);

      viewModel = DetailsViewModel(
        sessionManager: mockSessionManager,
        addressRepository: mockRepository,
      );

      final invalidAddress = Address(
        userId: 1,
        street: 'Test Street',
        number: '123',
        neighborhood: 'Test Neighborhood',
        complement: '',
        city: 'Test City',
        state: 'Test State',
        country: 'Brasil',
        postalCode: '12345-678',
        nickname: 'Home',
      );

      var failureCalled = false;
      String? failureMessage;
      viewModel.setRenderFailure((message) {
        failureCalled = true;
        failureMessage = message;
      });

      await viewModel.didTapDeleteAddress(invalidAddress);

      expect(failureCalled, isTrue);
      expect(failureMessage, contains('inválido'));
    });

    test('handles error when loading addresses', () async {
      mockRepository.getAddressesResult = Result.error(Exception('Network error'));

      var failureCalled = false;
      String? failureMessage;

      viewModel = DetailsViewModel(
        sessionManager: mockSessionManager,
        addressRepository: mockRepository,
      );

      viewModel.setRenderFailure((message) {
        failureCalled = true;
        failureMessage = message;
      });

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      expect(failureCalled, isTrue);
      expect(failureMessage, contains('Network error'));
    });
  });
}
