import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/data/repositories/auth_repository.dart';
import 'package:fluttalk/data/repositories/user_repository.dart';
import 'package:fluttalk/domain/entities/me_entity.dart';
import 'package:fpdart/fpdart.dart';

class UpdateMeUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  UpdateMeUseCase(this._authRepository, this._userRepository);

  Future<Either<AppException, MeEntity>> execute(String name) async {
    try {
      final firebaseUser = _authRepository.currentUser;
      if (firebaseUser == null) {
        return Left(UnauthorizedException());
      }

      await _userRepository.updateMe(
        UpdateMeRequest(name: name),
      );

      final user = await _userRepository.getMe();

      return Right(MeEntity(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName,
        friendIds: user.friendIds,
        createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
        lastLoginAt: firebaseUser.metadata.lastSignInTime ?? DateTime.now(),
        pushEnabled: true,
      ));
    } catch (e) {
      return Left(AppErrorHandler.handle(e));
    }
  }
}
