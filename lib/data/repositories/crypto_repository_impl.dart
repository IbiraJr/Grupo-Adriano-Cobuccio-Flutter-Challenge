import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../core/errors/failure.dart';
import '../../domain/entities/crypto.dart';
import '../../domain/repositories/crypto_repository.dart';
import '../datasources/crypto_local_datasource.dart';
import '../datasources/crypto_remote_datasource.dart';

class CryptoRepositoryImpl implements CryptoRepository {
  final CryptoRemoteDataSource _remoteDataSource;
  final CryptoLocalDataSource _localDataSource;

  CryptoRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, List<Crypto>>> getCryptos({
    String? query,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final cryptos = await _remoteDataSource.getCryptos(
        query: query,
        page: page,
        perPage: perPage,
      );

      return Right(cryptos.map((dto) => dto.toEntity()).toList());
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Crypto>> getCryptoById(String id) async {
    try {
      final crypto = await _remoteDataSource.getCryptoById(id);
      return Right(crypto.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Crypto>>> searchCryptos(String query) async {
    try {
      final cryptos = await _remoteDataSource.searchCryptos(query);
      return Right(cryptos.map((dto) => dto.toEntity()).toList());
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Crypto>>> getFavorites() async {
    try {
      final favorites = await _localDataSource.getFavorites();
      return Right(favorites);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addToFavorites(Crypto crypto) async {
    try {
      await _localDataSource.addToFavorites(crypto);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFromFavorites(String cryptoId) async {
    try {
      await _localDataSource.removeFromFavorites(cryptoId);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String cryptoId) async {
    try {
      final isFavorite = await _localDataSource.isFavorite(cryptoId);
      return Right(isFavorite);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  Failure _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Timeout de conexão');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode != null) {
          if (statusCode >= 500) {
            return const ServerFailure('Erro interno do servidor');
          } else if (statusCode == 404) {
            return const ServerFailure('Recurso não encontrado');
          } else if (statusCode == 429) {
            return const ServerFailure(
              'Muitas requisições. Tente novamente mais tarde',
            );
          }
        }
        return ServerFailure('Erro no servidor: ${e.message}');
      case DioExceptionType.connectionError:
        return const NetworkFailure('Sem conexão com a internet');
      case DioExceptionType.cancel:
        return const NetworkFailure('Requisição cancelada');
      default:
        return NetworkFailure('Erro de rede: ${e.message}');
    }
  }
}
