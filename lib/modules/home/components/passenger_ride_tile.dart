import '../../../models/ride.dart';
import '../../../support/styles/app_colors.dart';
import '../../../support/utils/constants.dart';
import '../../../support/view/view.dart';

class PassengerRideTile extends StatelessWidget {
  final Ride ride;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const PassengerRideTile({
    super.key,
    required this.ride,
    this.onAccept,
    this.onReject,
  });

  String _getDestinationAddress() {
    if (ride.addresses.isEmpty) return 'Destino não informado';
    final destination = ride.addresses.first;
    return destination.street;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gray30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 16,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  ride.passenger.profilePic.isNotEmpty
                      ? ride.passenger.profilePic
                      : Constants.avatar,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      Constants.avatar,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              Expanded(
                child: Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ride.passenger.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${ride.passenger.course} - ${ride.passenger.semester}'),
                    Row(
                      spacing: 4,
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        Text('${ride.passenger.rating} (${ride.passenger.ridesAsPassenger})'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: AppColors.lightBlue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Destino',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(_getDestinationAddress()),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onReject,
                  child: const Text('Recusar'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: onAccept,
                  child: const Text('Aceitar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
