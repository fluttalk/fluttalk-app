import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  late final Dio dio;

  DioClient({required String baseUrl}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        contentType: 'application/json',
      ),
    );

    dio.interceptors.addAll([
      CustomPrettyDioLogger(),
      TokenInterceptor(),
      RetryInterceptor(
        dio: dio, // 여기서 dio 인스턴스를 전달
        maxRetries: 3,
        retryInterval: const Duration(milliseconds: 300),
      ),
    ]);
  }
}

/// Creates a PrettyDioLogger object. This logger configuration displays request headers,
/// request bodies, response bodies, response headers, errors and formats logging in a compact way.
/// The maximum width of the log is set to 100 characters.
class CustomPrettyDioLogger extends PrettyDioLogger {
  /// Creates a custom logger with predefined settings for Dio HTTP logging
  CustomPrettyDioLogger()
      : super(
            requestHeader: true,

            /// Enable request header logging
            requestBody: true,

            /// Enable request body logging
            responseBody: true,

            /// Enable response body logging
            responseHeader: true,

            /// Enable response header logging
            error: true,

            /// Enable error logging
            compact: true,

            /// Enable compact mode
            maxWidth: 100

            /// Set maximum log width
            );
}

class TokenInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration retryInterval;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryInterval = const Duration(milliseconds: 300),
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    var extra = err.requestOptions.extra;
    var retryCount = extra['retryCount'] ?? 0;

    if (_shouldRetry(err) && retryCount < maxRetries) {
      await Future.delayed(retryInterval);

      var options = err.requestOptions;
      options.extra['retryCount'] = retryCount + 1;

      try {
        final response = await dio.fetch(options);
        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.next(e);
      }
    }

    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        (err.response?.statusCode ?? 0) >= 500;
  }
}
