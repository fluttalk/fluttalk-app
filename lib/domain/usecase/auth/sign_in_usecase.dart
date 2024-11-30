import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/data/repositories/auth_repository.dart';
import 'package:fluttalk/domain/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';

class SignInUseCase {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  Future<Either<AppException, UserEntity>> execute({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _repository.signInWithEmail(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        return Left(AuthException('로그인에 실패했습니다'));
      }
      final user = await _repository.getMe();

      return Right(UserEntity(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName,
        friendIds: user.friendIds,
        createdAt: credential.user?.metadata.creationTime ?? DateTime.now(),
        lastLoginAt: credential.user?.metadata.lastSignInTime ?? DateTime.now(),
        pushEnabled: true,
      ));
    } catch (e) {
      return Left(AppErrorHandler.handle(e));
    }
  }
}
