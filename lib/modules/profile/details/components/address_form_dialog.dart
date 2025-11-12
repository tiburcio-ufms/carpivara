import 'package:flutter/material.dart';

import '../../../../models/address.dart';

class AddressFormDialog extends StatefulWidget {
  final Address? address;
  final int userId;

  const AddressFormDialog({
    super.key,
    this.address,
    required this.userId,
  });

  @override
  State<AddressFormDialog> createState() => _AddressFormDialogState();
}

class _AddressFormDialogState extends State<AddressFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nicknameController;
  late TextEditingController _streetController;
  late TextEditingController _numberController;
  late TextEditingController _neighborhoodController;
  late TextEditingController _complementController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _countryController;
  late TextEditingController _postalCodeController;

  bool get isEditing => widget.address != null;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.address?.nickname ?? '');
    _streetController = TextEditingController(text: widget.address?.street ?? '');
    _numberController = TextEditingController(text: widget.address?.number ?? '');
    _neighborhoodController = TextEditingController(text: widget.address?.neighborhood ?? '');
    _complementController = TextEditingController(text: widget.address?.complement ?? '');
    _cityController = TextEditingController(text: widget.address?.city ?? '');
    _stateController = TextEditingController(text: widget.address?.state ?? '');
    _countryController = TextEditingController(text: widget.address?.country ?? '');
    _postalCodeController = TextEditingController(text: widget.address?.postalCode ?? '');
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _neighborhoodController.dispose();
    _complementController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  Address? _buildAddress() {
    if (!_formKey.currentState!.validate()) return null;

    return Address(
      id: widget.address?.id,
      userId: widget.userId,
      nickname: _nicknameController.text.trim(),
      street: _streetController.text.trim(),
      number: _numberController.text.trim(),
      neighborhood: _neighborhoodController.text.trim(),
      complement: _complementController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      country: _countryController.text.trim(),
      postalCode: _postalCodeController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Editar endereço' : 'Adicionar endereço'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: 'Apelido',
                  hintText: 'Ex: Casa, Trabalho',
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'O apelido é obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _streetController,
                decoration: const InputDecoration(
                  labelText: 'Rua',
                  hintText: 'Nome da rua',
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'A rua é obrigatória';
                  }
                  return null;
                },
              ),
              Row(
                spacing: 8,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _numberController,
                      decoration: const InputDecoration(
                        labelText: 'Número',
                        hintText: '123',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'O número é obrigatório';
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _neighborhoodController,
                      decoration: const InputDecoration(
                        labelText: 'Bairro',
                        hintText: 'Nome do bairro',
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'O bairro é obrigatório';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _complementController,
                decoration: const InputDecoration(
                  labelText: 'Complemento',
                  hintText: 'Ex: Apto 101, Sala 205',
                ),
                textCapitalization: TextCapitalization.words,
              ),
              Row(
                spacing: 8,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'Cidade',
                        hintText: 'Nome da cidade',
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'A cidade é obrigatória';
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _stateController,
                      decoration: const InputDecoration(
                        labelText: 'Estado',
                        hintText: 'SP',
                      ),
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 2,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'O estado é obrigatório';
                        }
                        if (value.trim().length != 2) {
                          return 'Use 2 letras';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(
                  labelText: 'País',
                  hintText: 'Brasil',
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'O país é obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _postalCodeController,
                decoration: const InputDecoration(
                  labelText: 'CEP',
                  hintText: '00000-000',
                ),
                keyboardType: TextInputType.number,
                maxLength: 9,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'O CEP é obrigatório';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final address = _buildAddress();
            if (address != null) {
              Navigator.of(context).pop(address);
            }
          },
          child: Text(isEditing ? 'Salvar' : 'Adicionar'),
        ),
      ],
    );
  }
}
