import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get googleMapsApiKey {
    return dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  }

  static String get googlePlacesApiKey {
    return dotenv.env['GOOGLE_PLACES_API_KEY'] ?? dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  }

  static Future<void> load() async {
    await dotenv.load();
  }
}
