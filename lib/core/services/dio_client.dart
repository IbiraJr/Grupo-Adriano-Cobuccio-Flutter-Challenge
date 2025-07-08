import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';
import '../config/app_config.dart';
import 'dart:developer' as dev;

class DioClient {
  late Dio _dio;

  DioClient() {
    _dio = Dio();
    _setupInterceptors();
  }

  Dio get dio => _dio;

  Future<void> _setupInterceptors() async {
    _dio.options = BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'x-cg-demo-api-key': 'CG-gyEMqDGRSVXu3fdg955DbqQ2',
      },
    );

    // Cache interceptor

    final cacheOptions = CacheOptions(
      store: HiveCacheStore(
        AppConfig.cacheDir,
        hiveBoxName: AppConfig.cacheBoxName,
      ),
      policy: CachePolicy.request,
      hitCacheOnErrorCodes: [401, 403],
      maxStale: const Duration(days: 7),
      priority: CachePriority.normal,
      cipher: null,
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      allowPostMethod: false,
    );

    _dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));

    // Logging interceptor (only in debug mode)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => dev.log(obj.toString()),
      ),
    );
  }
}
