import 'package:fluttalk/core/api/base_response.dart';

// 단일 응답
class SingleResponse<T> extends BaseResponse<T> {
  final T? result;

  const SingleResponse({
    this.result,
    super.message,
    super.code,
    super.name,
  });

  factory SingleResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    final resultData = json['result'] as Map<String, dynamic>?;
    return SingleResponse(
      result: resultData != null ? fromJson(resultData) : null,
      message: json['message'],
      code: json['code'],
      name: json['name'],
    );
  }
}
