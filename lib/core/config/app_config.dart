import 'package:brasil_card/core/services/hive_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

class AppConfig {
  static const String baseUrl = 'https://api.coingecko.com/api/v3';
  static const String appName = 'BrasilCripto';
  static const String version = '1.0.0';

  // API Endpoints
  static const String coinsEndpoint = '/coins/markets';
  static const String searchEndpoint = '/search';
  static const String coinDetailEndpoint = '/coins';

  // Hive Box Names
  static String cacheDir = '';
  static const String favoritesBoxName = 'favorites_box';
  static const String cacheBoxName = 'cache_box';

  // Cache Duration
  static const Duration cacheDuration = Duration(minutes: 5);

  // Pagination
  static const int itemsPerPage = 20;

  static Future<void> init() async {
    await dotenv.load(fileName: ".env");
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final path = appDocumentDir.path;
    cacheDir = path;
    Hive.init(path);
    await HiveService.init();
  }
}
