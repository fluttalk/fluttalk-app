import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/data/repositories/auth_repository.dart';
import 'package:fluttalk/data/repositories/user_repository.dart';
import 'package:fluttalk/domain/entities/me_entity.dart';
import 'package:fpdart/fpdart.dart';

class SignUpUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  SignUpUseCase(this._authRepository, this._userRepository);

  Future<Either<AppException, MeEntity>> execute({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _authRepository.signUpWithEmail(
        email: email,
        password: password,
      );

      final signedInUser = credential.user;
      if (signedInUser == null) {
        return Left(AuthException('회원가입에 실패했습니다'));
      }

      final user = await _userRepository.getMe();

      return Right(MeEntity(
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
