import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/crypto_local_datasource.dart';
import '../../data/datasources/crypto_remote_datasource.dart';
import '../../data/repositories/crypto_repository_impl.dart';
import '../../domain/repositories/crypto_repository.dart';
import '../services/dio_client.dart';

// DIO Client Provider
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

// Data Sources Providers
final cryptoRemoteDataSourceProvider = Provider<CryptoRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return CryptoRemoteDataSourceImpl(dioClient.dio);
});

final cryptoLocalDataSourceProvider = Provider<CryptoLocalDataSource>((ref) {
  return CryptoLocalDataSourceImpl();
});

// Repository Provider
final cryptoRepositoryProvider = Provider<CryptoRepository>((ref) {
  final remoteDataSource = ref.watch(cryptoRemoteDataSourceProvider);
  final localDataSource = ref.watch(cryptoLocalDataSourceProvider);
  return CryptoRepositoryImpl(remoteDataSource, localDataSource);
});