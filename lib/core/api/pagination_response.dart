import 'package:fluttalk/core/api/list_response.dart';
import 'package:fluttalk/core/error/error.dart';

class PaginationResponse<T> extends ListResponse<T> {
  final String? nextKey;

  PaginationResponse({
    required super.results,
    this.nextKey,
    super.message,
    super.code,
    super.name,
  });

  factory PaginationResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    if (json['results'] == null) throw const NoResultsException();
    return PaginationResponse(
        results: (json['results'] as List).map((e) => fromJson(e)).toList(),
        nextKey: json['nextKey'],
        code: json['code'],
        message: json['message'],
        name: json['name']);
  }
}
