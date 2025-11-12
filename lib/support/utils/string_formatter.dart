extension StringFormatter on String {
  String formattedPassport() {
    return '${substring(0, 4)}.${substring(4, 8)}.${substring(8, 11)}-${substring(11, 12)}';
  }
}
