import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  final Dio dio;

  DioClient({required String baseUrl})
      : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 3),
            contentType: 'application/json',
          ),
        )..interceptors.addAll([
            CustomPrettyDioLogger(),
            TokenInterceptor(),
          ]);
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
