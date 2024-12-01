import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/data/repositories/friend_repository.dart';
import 'package:fluttalk/domain/entities/friend_entity.dart';
import 'package:fpdart/fpdart.dart';

class GetFriendsUseCase {
  final FriendRepository _repository;

  GetFriendsUseCase(this._repository);

  Future<Either<AppException, List<FriendEntity>>> execute() async {
    try {
      final users = await _repository.getFriends();
      return Right(users
          .map((user) => FriendEntity(
                id: user.uid,
                email: user.email ?? '',
                name: user.displayName,
                photoUrl: user.photoUrl,
                disabled: user.disabled,
                emailVerified: user.emailVerified,
              ))
          .toList());
    } catch (e) {
      return Left(AppErrorHandler.handle(e));
    }
  }
}
