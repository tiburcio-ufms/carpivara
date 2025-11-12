import 'package:flutter/material.dart';

import '../../../../models/address.dart';

class DeleteAddressConfirmationDialog extends StatelessWidget {
  final Address address;

  const DeleteAddressConfirmationDialog({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Excluir endereço'),
      content: Text('Tem certeza que deseja excluir o endereço "${address.nickname}"?'),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Excluir'),
        ),
      ],
    );
  }
}
