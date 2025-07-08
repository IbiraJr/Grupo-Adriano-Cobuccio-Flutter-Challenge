import 'package:dio/dio.dart';
import '../models/crypto_dto.dart';
import '../../core/config/app_config.dart';

abstract class CryptoRemoteDataSource {
  Future<List<CryptoDto>> getCryptos({
    String? query,
    int page = 1,
    int perPage = 20,
  });

  Future<CryptoDto> getCryptoById(String id);

  Future<List<CryptoDto>> searchCryptos(String query);
}

class CryptoRemoteDataSourceImpl implements CryptoRemoteDataSource {
  final Dio _dio;

  CryptoRemoteDataSourceImpl(this._dio);

  @override
  Future<List<CryptoDto>> getCryptos({
    String? query,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await _dio.get(
        AppConfig.coinsEndpoint,
        queryParameters: {
          'vs_currency': 'usd',
          'order': 'market_cap_desc',
          'per_page': perPage,
          'page': page,
          'sparkline': false,
          'price_change_percentage': '24h',
          if (query != null && query.isNotEmpty) 'ids': query,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => CryptoDto.fromJson(json)).toList();
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CryptoDto> getCryptoById(String id) async {
    try {
      final response = await _dio.get(
        '${AppConfig.coinDetailEndpoint}/$id',
        queryParameters: {
          'localization': false,
          'tickers': false,
          'market_data': true,
          'community_data': false,
          'developer_data': false,
          'sparkline': false,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final transformedData = {
          'id': data['id'],
          'symbol': data['symbol'],
          'name': data['name'],
          'image': data['image']?['large'],
          'current_price':
              data['market_data']?['current_price']?['usd']?.toDouble() ?? 0.0,
          'market_cap': data['market_data']?['market_cap']?['usd']?.toDouble(),
          'market_cap_rank': data['market_data']?['market_cap_rank'],
          'total_volume':
              data['market_data']?['total_volume']?['usd']?.toDouble(),
          'high_24h': data['market_data']?['high_24h']?['usd']?.toDouble(),
          'low_24h': data['market_data']?['low_24h']?['usd']?.toDouble(),
          'price_change_24h':
              data['market_data']?['price_change_24h']?.toDouble(),
          'price_change_percentage_24h':
              data['market_data']?['price_change_percentage_24h']?.toDouble(),
          'circulating_supply':
              data['market_data']?['circulating_supply']?.toDouble(),
          'total_supply': data['market_data']?['total_supply']?.toDouble(),
          'max_supply': data['market_data']?['max_supply']?.toDouble(),
          'last_updated':
              data['market_data']?['last_updated'] ??
              DateTime.now().toIso8601String(),
        };

        return CryptoDto.fromJson(transformedData);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CryptoDto>> searchCryptos(String query) async {
    try {
      final response = await _dio.get(
        AppConfig.searchEndpoint,
        queryParameters: {'query': query},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final List<dynamic> coins = data['coins'] ?? [];

        // Get detailed information for each coin found
        final List<CryptoDto> results = [];

        for (final coin in coins.take(10)) {
          // Limit to first 10 results
          try {
            final detailedCrypto = await getCryptoById(coin['id']);
            results.add(detailedCrypto);
          } catch (e) {
            // Skip coins that fail to load detailed info
            continue;
          }
        }

        return results;
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } catch (e) {
      rethrow;
    }
  }
}
