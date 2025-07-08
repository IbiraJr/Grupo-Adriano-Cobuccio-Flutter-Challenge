import 'package:dartz/dartz.dart';
import '../entities/crypto.dart';
import '../../core/errors/failure.dart';

abstract class CryptoRepository {
  Future<Either<Failure, List<Crypto>>> getCryptos({
    String? query,
    int page = 1,
    int perPage = 20,
  });
  
  Future<Either<Failure, Crypto>> getCryptoById(String id);
  
  Future<Either<Failure, List<Crypto>>> searchCryptos(String query);
  
  Future<Either<Failure, List<Crypto>>> getFavorites();
  
  Future<Either<Failure, Unit>> addToFavorites(Crypto crypto);
  
  Future<Either<Failure, Unit>> removeFromFavorites(String cryptoId);
  
  Future<Either<Failure, bool>> isFavorite(String cryptoId);
}