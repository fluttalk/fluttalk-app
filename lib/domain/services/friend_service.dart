import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/domain/entities/friend_entity.dart';
import 'package:fluttalk/domain/usecase/friend/add_friend_usecase.dart';
import 'package:fluttalk/domain/usecase/friend/get_friends_usecase.dart';
import 'package:fluttalk/domain/usecase/friend/remove_friend_usecase.dart';
import 'package:fpdart/fpdart.dart';

class FriendService {
  final GetFriendsUseCase _getFriendsUseCase;
  final AddFriendUseCase _addFriendUseCase;
  final RemoveFriendUseCase _removeFriendUseCase;

  FriendService(
    this._getFriendsUseCase,
    this._addFriendUseCase,
    this._removeFriendUseCase,
  );

  // 친구 목록을 가져옵니다. 한번에 모든 친구 정보를 반환합니다.
  Future<Either<AppException, List<FriendEntity>>> getFriends() {
    return _getFriendsUseCase.execute();
  }

  // 이메일로 친구를 추가합니다. 해당 이메일의 사용자가 존재해야 합니다.
  Future<Either<AppException, FriendEntity>> addFriend({
    required String email,
  }) {
    return _addFriendUseCase.execute(email: email);
  }

  // 이메일로 친구를 삭제합니다. 이미 친구로 등록된 사용자여야 합니다.
  Future<Either<AppException, FriendEntity>> removeFriend({
    required String email,
  }) {
    return _removeFriendUseCase.execute(email: email);
  }
}
