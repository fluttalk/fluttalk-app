class PaginatedList<T> {
  final List<T> items;
  final String? nextKey;

  const PaginatedList({
    required this.items,
    this.nextKey,
  });

  // JSON에서 PaginatedList를 생성하는 팩토리 메서드
  // 제네릭 타입 T를 어떻게 변환할지 결정하는 fromJson 함수를 파라미터로 받습니다
  factory PaginatedList.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    // results 배열을 파싱하여 T 타입의 리스트로 변환합니다
    final results = json['results'] as List?;
    final items = results
            ?.map((item) => fromJson(item as Map<String, dynamic>))
            .toList() ??
        [];

    // 다음 페이지의 키를 가져옵니다
    final nextKey = json['nextKey'] as String?;

    return PaginatedList(items: items, nextKey: nextKey);
  }
}
