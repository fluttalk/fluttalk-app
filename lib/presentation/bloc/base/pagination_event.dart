// // PaginationEvent는 페이지네이션과 관련된 모든 이벤트의 기본이 되는 추상 클래스입니다.
// abstract class PaginationEvent {
//   const PaginationEvent();
// }

// // LoadMoreEvent는 더 많은 아이템을 로드하라는 요청을 나타냅니다.
// // 스크롤이 끝에 도달했을 때 발생할 수 있습니다.
// class LoadMoreEvent extends PaginationEvent {
//   const LoadMoreEvent();
// }

// // RefreshEvent는 목록을 처음부터 다시 로드하라는 요청을 나타냅니다.
// // 사용자가 당겨서 새로고침할 때 발생할 수 있습니다.
// class RefreshEvent extends PaginationEvent {
//   const RefreshEvent();
// }
