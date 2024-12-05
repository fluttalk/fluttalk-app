import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/data/repositories/friend_repository.dart';
import 'package:fluttalk/domain/entities/friend_entity.dart';
import 'package:fpdart/fpdart.dart';

class AddFriendUseCase {
  final FriendRepository _friendRepository;

  AddFriendUseCase(this._friendRepository);

  Future<Either<AppException, FriendEntity>> execute(
      {required String email}) async {
    try {
      final response = await _friendRepository.addFriendByEmail(email: email);

      if (response.code != null) {
        final code = response.code ?? 500;
        final message = response.message ?? '알 수 없는 오류가 발생했습니다';
        return Left(
          ApiException(code: code, message: message),
        );
      }

      final friend = response.result;
      if (friend == null) {
        return const Left(
          NoResultException(),
        );
      }

      return Right(
        FriendEntity.fromUserModel(friend),
      );
    } catch (e) {
      return Left(
        AppErrorHandler.handle(e),
      );
    }
  }
}
