import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/data/repositories/friend_repository.dart';
import 'package:fluttalk/domain/entities/friend_entity.dart';
import 'package:fpdart/fpdart.dart';

class AddFriendUseCase {
  final FriendRepository _repository;

  AddFriendUseCase(this._repository);

  Future<Either<AppException, FriendEntity>> execute(String email) async {
    try {
      final user = await _repository.addFriendByEmail(
        AddFriendRequest(email: email),
      );
      return Right(FriendEntity(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName,
        photoUrl: user.photoUrl,
        disabled: user.disabled,
        emailVerified: user.emailVerified,
      ));
    } catch (e) {
      return Left(AppErrorHandler.handle(e));
    }
  }
}
