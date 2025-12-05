import 'package:flutter/material.dart';

import '../../../../models/address.dart';
import '../../../../support/view/view.dart';

class AddressTile extends StatelessWidget {
  final Address address;
  final Function(Address address)? onEdit;
  final Function(Address address)? onDelete;

  const AddressTile({
    super.key,
    this.onEdit,
    this.onDelete,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: [
        Expanded(
          child: Row(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(address.nickname),
                    Text(
                      '${address.street}, ${address.number}, ${address.neighborhood}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () => onEdit?.call(address),
          child: const Icon(Icons.edit_outlined),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () => onDelete?.call(address),
          child: const Icon(Icons.delete_outline, color: Colors.red),
        ),
      ],
    );
  }
}
