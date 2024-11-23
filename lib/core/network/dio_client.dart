import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'YOUR_BASE_URL',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        contentType: 'application/json',
      ),
    )..interceptors.add(
        CustomPrettyDioLogger(),
      );
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
