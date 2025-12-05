import 'dart:async';

import '../../models/address.dart';
import '../../support/utils/result.dart';
import '../address_repository.dart';

class AddressRepositoryMock implements AddressRepositoryProtocol {
  final List<Address> _addresses = [
    Address(
      id: 1,
      userId: 1,
      street: 'Rua das Flores',
      number: '123',
      neighborhood: 'Centro',
      complement: 'Apto 101',
      city: 'São Paulo',
      state: 'SP',
      country: 'Brasil',
      postalCode: '01234-567',
      nickname: 'Casa',
    ),
    Address(
      id: 2,
      userId: 1,
      street: 'Avenida Paulista',
      number: '1000',
      neighborhood: 'Bela Vistaaaaaaaaaaaaa',
      complement: '',
      city: 'São Paulo',
      state: 'SP',
      country: 'Brasil',
      postalCode: '01310-100',
      nickname: 'Trabalho',
    ),
    Address(
      id: 3,
      userId: 1,
      street: 'Rua Augusta',
      number: '500',
      neighborhood: 'Consolação',
      complement: 'Sala 205',
      city: 'São Paulo',
      state: 'SP',
      country: 'Brasil',
      postalCode: '01305-000',
      nickname: 'Casa do João',
    ),
  ];

  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<Result<List<Address>>> getAddresses() async {
    await _simulateNetworkDelay();
    return Result.ok(List.from(_addresses));
  }

  @override
  Future<Result<Address>> createAddress(Address address) async {
    await _simulateNetworkDelay();
    final newAddress = Address(
      id: _addresses.length + 1,
      userId: address.userId,
      street: address.street,
      number: address.number,
      neighborhood: address.neighborhood,
      complement: address.complement,
      city: address.city,
      state: address.state,
      country: address.country,
      postalCode: address.postalCode,
      nickname: address.nickname,
    );
    _addresses.add(newAddress);
    return Result.ok(newAddress);
  }

  @override
  Future<Result<Address>> updateAddress(Address address) async {
    await _simulateNetworkDelay();
    if (address.id == null) {
      return Result.error(Exception('Address ID is required for update'));
    }

    final index = _addresses.indexWhere((a) => a.id == address.id);
    if (index == -1) {
      return Result.error(Exception('Address not found'));
    }

    _addresses[index] = address;
    return Result.ok(address);
  }

  @override
  Future<Result<void>> deleteAddress(int id) async {
    await _simulateNetworkDelay();
    final index = _addresses.indexWhere((a) => a.id == id);
    if (index == -1) {
      return Result.error(Exception('Address not found'));
    }

    _addresses.removeAt(index);
    return const Result.ok(null);
  }
}
