import 'package:dio/dio.dart';
import 'api_config.dart';
import '../storage/token_storage.dart';

typedef SessionExpiredCallback = void Function();

class DioClient {
  late final Dio _dio;
  final TokenStorage _tokenStorage;
  final SessionExpiredCallback? _onSessionExpired;

  DioClient(this._tokenStorage, {SessionExpiredCallback? onSessionExpired})
      : _onSessionExpired = onSessionExpired {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshed = await _refreshToken();
            if (refreshed) {
              return handler.resolve(await _retry(error.requestOptions));
            }
            _onSessionExpired?.call();
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await Dio(
        BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ).post(
        '${ApiConfig.auth}/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['accessToken'];
        await _tokenStorage.saveAccessToken(newAccessToken);
        return true;
      }
    } catch (e) {
      await _tokenStorage.clearTokens();
    }
    return false;
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Dio get dio => _dio;
}
