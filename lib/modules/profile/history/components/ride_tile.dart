import '../../../../models/ride.dart';
import '../../../../support/styles/app_colors.dart';
import '../../../../support/view/view.dart';
import 'stop_tile.dart';

class RideTile extends StatelessWidget {
  final Ride ride;

  const RideTile({super.key, required this.ride});

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  String _formatDateShort(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day/$month/$year';
  }

  String _getStatus() {
    if (ride.endDate != null) return 'Concluída';
    if (ride.startDate != null) return 'Em andamento';
    if (ride.confirmationDate != null) return 'Confirmada';
    return 'Pendente';
  }

  Color _getStatusColor() {
    if (ride.endDate != null) return Colors.green;
    if (ride.startDate != null) return Colors.blue;
    if (ride.confirmationDate != null) return Colors.orange;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final origin = ride.addresses.isNotEmpty ? ride.addresses.first : null;
    final destination = ride.addresses.length > 1 ? ride.addresses.last : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gray30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDateShort(ride.requestDate),
                style: TextTheme.of(context).bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: _getStatusColor()),
                ),
                child: Text(
                  _getStatus(),
                  style: TextStyle(
                    color: _getStatusColor(),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (origin != null) ...[StopTile(address: origin, type: StopType.origin)],
          if (destination != null) ...[StopTile(address: destination, type: StopType.destination)],
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Solicitada em',
                    style: TextTheme.of(context).bodySmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(_formatDate(ride.requestDate)),
                ],
              ),
              if (ride.endDate != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Concluída em',
                      style: TextTheme.of(context).bodySmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(_formatDate(ride.endDate!)),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
