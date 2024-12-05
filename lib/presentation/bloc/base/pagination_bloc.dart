// // PaginationBloc은 페이지네이션의 기본 로직을 구현하는 추상 클래스입니다.

// import 'package:bloc_concurrency/bloc_concurrency.dart';
// import 'package:fluttalk/core/error/error.dart';
// import 'package:fluttalk/domain/entities/pagination_list.dart';
// import 'package:fluttalk/presentation/bloc/base/index.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fpdart/fpdart.dart';

// abstract class PaginationBloc<T>
//     extends Bloc<PaginationEvent, PaginationValue<T>> {
//   // 생성자에서 초기 상태를 설정합니다.
//   // 처음에는 데이터가 없고, 더 불러올 수 있는 상태입니다.
//   PaginationBloc()
//       : super(const PaginationValue(
//           items: AsyncInitial(),
//           hasMore: true,
//         )) {
//     // 각 이벤트 타입에 대한 핸들러를 등록합니다.
//     // droppable 트랜스포머를 사용하여 중복 요청을 방지합니다.
//     on<LoadMoreEvent>(_onLoadMore, transformer: droppable());
//     on<RefreshEvent>(_onRefresh, transformer: droppable());
//   }

//   // 실제 데이터를 로드하는 메서드입니다.
//   // 구체적인 구현은 하위 클래스에서 제공해야 합니다.
//   Future<Either<AppException, PaginatedList<T>>> loadItems(String? nextKey);

//   // 더 많은 아이템을 로드하는 이벤트를 처리합니다.
//   Future<void> _onLoadMore(
//     LoadMoreEvent event,
//     Emitter<PaginationValue<T>> emit,
//   ) async {
//     // 이미 로딩 중이거나 더 불러올 아이템이 없다면 중단합니다.
//     if (state.items is AsyncLoading || !state.hasMore) return;

//     // 현재 아이템 목록을 가져옵니다.
//     final currentItems = switch (state.items) {
//       AsyncData(data: final items) => items,
//       _ => <T>[],
//     };

//     // 현재 아이템이 있다면 유지하고, 없다면 로딩 상태를 표시합니다.
//     if (currentItems.isNotEmpty) {
//       emit(state.copyWith(items: AsyncData(currentItems)));
//     } else {
//       emit(state.copyWith(items: const AsyncLoading()));
//     }

//     // 새로운 아이템을 로드합니다.
//     final result = await loadItems(state.nextKey);

//     result.fold(
//       // 에러가 발생하면 에러 상태를 발행합니다.
//       (error) => emit(state.copyWith(
//         items: AsyncError(error.message),
//       )),
//       // 성공하면 새 아이템을 기존 목록에 추가하고 다음 페이지 정보를 업데이트합니다.
//       (pagedItems) {
//         final newItems = [...currentItems, ...pagedItems.items];
//         final nextKey = pagedItems.nextKey;

//         emit(state.copyWith(
//           items: AsyncData(newItems),
//           hasMore: nextKey != null,
//           nextKey: nextKey,
//         ));
//       },
//     );
//   }

//   // 목록을 새로고침하는 이벤트를 처리합니다.
//   Future<void> _onRefresh(
//     RefreshEvent event,
//     Emitter<PaginationValue<T>> emit,
//   ) async {
//     // 상태를 초기화하고 처음부터 다시 로드합니다.
//     emit(const PaginationValue(
//       items: AsyncInitial(),
//       hasMore: true,
//     ));
//     add(const LoadMoreEvent());
//   }
// }
