import '../../../../models/address.dart';
import '../../../../support/view/view.dart';

enum StopType {
  origin,
  destination;

  String get name {
    return switch (this) {
      StopType.origin => 'Origem',
      StopType.destination => 'Destino',
    };
  }

  Color get color {
    return switch (this) {
      StopType.origin => Colors.green,
      StopType.destination => Colors.red,
    };
  }
}

class StopTile extends StatelessWidget {
  final Address address;
  final StopType type;

  const StopTile({super.key, required this.address, required this.type});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Icon(Icons.location_on, size: 16, color: type.color),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(type.name, style: TextTheme.of(context).bodySmall?.copyWith(fontWeight: FontWeight.bold)),
              Text('${address.nickname} - ${address.street}, ${address.number}'),
            ],
          ),
        ),
      ],
    );
  }
}
