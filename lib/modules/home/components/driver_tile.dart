import '../../../support/styles/app_colors.dart';
import '../../../support/utils/constants.dart';
import '../../../support/view/view.dart';

class DriverTile extends StatelessWidget {
  const DriverTile({super.key});

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
            child: Image.network(
              Constants.avatar,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('João da Silva'),
              Text('HB20 Branca PXV4A34'),
            ],
          ),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Solicitar'),
          ),
        ],
      ),
    );
  }
}
