import 'dart:async';

import 'package:go_router/go_router.dart';

import '../../../models/address.dart';
import '../../../models/user.dart';
import '../../../repositories/address_repository.dart';
import '../../../support/utils/result.dart';
import '../../../support/utils/session_manager.dart';
import '../../../support/utils/string_formatter.dart';
import 'components/address_form_dialog.dart';
import 'components/delete_address_confirmation_dialog.dart';
import 'details_view.dart';

class DetailsViewModel extends DetailsViewModelProtocol {
  late User _user;
  List<Address> _addresses = [];

  final SessionManagerProtocol _sessionManager;
  final AddressRepositoryProtocol _addressRepository;
  DetailsViewModel({
    required SessionManagerProtocol sessionManager,
    required AddressRepositoryProtocol addressRepository,
  }) : _sessionManager = sessionManager,
       _addressRepository = addressRepository {
    _user = _sessionManager.session!.user;
    _getAddresses();
  }

  @override
  String get rating => _user.rating;

  @override
  String get ridesAsDriver => _user.ridesAsDriver;

  @override
  String get ridesAsPassenger => _user.ridesAsPassenger;

  @override
  String get profilePic => _user.profilePic;

  @override
  String get name => _user.name;

  @override
  String get course => _user.course;

  @override
  String get passport => _user.passport.formattedPassport();

  @override
  String get semester => _user.semester;

  @override
  List<Address> get addresses => _addresses;

  @override
  Future<void> didTapLogout() async {
    await _sessionManager.removeSession();
    context?.go('/sign-in');
  }

  @override
  Future<void> didTapHistory() async {
    unawaited(context?.push('/shell/profile/history'));
  }

  @override
  Future<void> didTapPreferences() async {
    unawaited(context?.push('/shell/profile/preferences'));
  }

  @override
  Future<void> didTapAddAddress() async {
    final address = await renderDialog?.call(AddressFormDialog(userId: _user.id));
    if (address != null) await _createAddress(address);
  }

  @override
  Future<void> didTapEditAddress(Address address) async {
    final updatedAddress = await renderDialog?.call(AddressFormDialog(userId: _user.id, address: address));
    if (updatedAddress != null) await _updateAddress(updatedAddress);
  }

  @override
  Future<void> didTapDeleteAddress(Address address) async {
    if (address.id == null) return renderFailure?.call('Endereço inválido');

    final confirmed = await renderDialog?.call(DeleteAddressConfirmationDialog(address: address));
    if (confirmed != true) return;

    final result = await _addressRepository.deleteAddress(address.id!);
    switch (result) {
      case Ok():
        await _getAddresses();
      case Error(:final error):
        renderFailure?.call(error.toString());
    }
  }

  // Private methods -----------------------------------------------------------
  Future<void> _getAddresses() async {
    final result = await _addressRepository.getAddresses();
    switch (result) {
      case Ok(:final value):
        _addresses = value;
        notifyListeners();
      case Error(:final error):
        renderFailure?.call(error.toString());
    }
  }

  Future<void> _createAddress(Address address) async {
    final result = await _addressRepository.createAddress(address);
    switch (result) {
      case Ok():
        await _getAddresses();
      case Error(:final error):
        renderFailure?.call(error.toString());
    }
  }

  Future<void> _updateAddress(Address address) async {
    final result = await _addressRepository.updateAddress(address);
    switch (result) {
      case Ok():
        await _getAddresses();
      case Error(:final error):
        renderFailure?.call(error.toString());
    }
  }
}
