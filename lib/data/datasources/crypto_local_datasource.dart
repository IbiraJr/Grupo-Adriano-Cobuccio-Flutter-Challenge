import 'package:hive_ce/hive.dart';

import '../../core/config/app_config.dart';
import '../../domain/entities/crypto.dart';

abstract class CryptoLocalDataSource {
  Future<List<Crypto>> getFavorites();
  Future<void> addToFavorites(Crypto crypto);
  Future<void> removeFromFavorites(String cryptoId);
  Future<bool> isFavorite(String cryptoId);
  Future<void> clearFavorites();
}

class CryptoLocalDataSourceImpl implements CryptoLocalDataSource {
  late Box<Crypto> _favoritesBox;

  CryptoLocalDataSourceImpl() {
    _favoritesBox = Hive.box<Crypto>(AppConfig.favoritesBoxName);
  }

  @override
  Future<List<Crypto>> getFavorites() async {
    try {
      return _favoritesBox.values.toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> addToFavorites(Crypto crypto) async {
    try {
      await _favoritesBox.put(crypto.id, crypto);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeFromFavorites(String cryptoId) async {
    try {
      await _favoritesBox.delete(cryptoId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isFavorite(String cryptoId) async {
    try {
      return _favoritesBox.containsKey(cryptoId);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> clearFavorites() async {
    try {
      await _favoritesBox.clear();
    } catch (e) {
      rethrow;
    }
  }
}
