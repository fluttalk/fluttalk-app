abstract class BaseResponse<T> {
  final String? message;
  final int? code;
  final String? name;

  const BaseResponse({
    this.message,
    this.code,
    this.name,
  });
}
