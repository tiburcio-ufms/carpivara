import '../../../models/user.dart';
import '../../../support/styles/app_colors.dart';
import '../../../support/view/view.dart';

class DriverTile extends StatelessWidget {
  final User driver;
  final VoidCallback? onRequest;

  const DriverTile({super.key, this.onRequest, required this.driver});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gray30),
      ),
      child: Row(
        spacing: 16,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              driver.profilePic.isNotEmpty ? driver.profilePic : 'assets/man_avatar_1.png',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(driver.name),
                if (driver.carModel != null && driver.carPlate != null)
                  Text('${driver.carModel} ${driver.carPlate}')
                else
                  Text('${driver.course} - ${driver.semester}'),
                Row(
                  spacing: 4,
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    Text('${driver.rating} (${driver.ridesAsDriver})'),
                  ],
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onRequest,
            child: const Text('Solicitar'),
          ),
        ],
      ),
    );
  }
}
