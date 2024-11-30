import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/data/repositories/auth_repository.dart';
import 'package:fluttalk/domain/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';

class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<Either<AppException, UserEntity>> execute({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Firebase 회원가입
      final credential = await _repository.signUpWithEmail(
        email: email,
        password: password,
      );

      final signedInUser = credential.user;
      if (signedInUser == null) {
        return Left(AuthException('회원가입에 실패했습니다'));
      }

      // 2. 회원가입 후 유저 정보 가져오기
      final user = await _repository.getMe();

      return Right(UserEntity(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName,
        friendIds: user.friendIds,
        createdAt: signedInUser.metadata.creationTime ?? DateTime.now(),
        lastLoginAt: signedInUser.metadata.lastSignInTime ?? DateTime.now(),
        pushEnabled: true,
      ));
    } catch (e) {
      return Left(AppErrorHandler.handle(e));
    }
  }
}
