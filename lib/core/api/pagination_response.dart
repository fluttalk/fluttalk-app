class PaginationResponse<T> {
  final String? nextKey;
  final List<T> results;

  PaginationResponse({
    this.nextKey,
    required this.results,
  });

  factory PaginationResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return PaginationResponse(
      nextKey: json['nextKey'],
      results: (json['results'] as List)
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
