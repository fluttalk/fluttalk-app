import 'package:fluttalk/core/api/base_response.dart';

// 복수 응답
class ListResponse<T> extends BaseResponse<T> {
  final List<T>? results;

  ListResponse({this.results, super.message, super.code, super.name});

  factory ListResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    final resultsList = json['results'] as List?;
    return ListResponse(
        results: resultsList
            ?.map((e) => fromJson(e as Map<String, dynamic>))
            .toList(),
        code: json['code'],
        message: json['message'],
        name: json['name']);
  }
}
