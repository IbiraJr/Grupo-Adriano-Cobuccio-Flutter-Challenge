
import 'package:hive_ce/hive.dart';

import '../../domain/entities/crypto.dart';
import '../config/app_config.dart';

class HiveService {
  static Future<void> init() async {
    // Register adapters
    Hive.registerAdapter(CryptoAdapter());
    
    // Open boxes
    await Hive.openBox<Crypto>(AppConfig.favoritesBoxName);
  }
  
  static Future<void> clearAllBoxes() async {
    await Hive.box<Crypto>(AppConfig.favoritesBoxName).clear();
    await Hive.box(AppConfig.cacheBoxName).clear();
  }
}