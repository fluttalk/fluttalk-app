import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/data/repositories/auth_repository.dart';
import 'package:fluttalk/data/repositories/user_repository.dart';
import 'package:fluttalk/domain/entities/me_entity.dart';
import 'package:fpdart/fpdart.dart';

class GetMeUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  GetMeUseCase(this._authRepository, this._userRepository);

  Future<Either<AppException, MeEntity>> execute() async {
    try {
      final firebaseUser = _authRepository.currentUser;
      if (firebaseUser == null) {
        return Left(UnauthorizedException());
      }

      final user = await _userRepository.getMe();
      return Right(MeEntity(
        id: user.uid,
        email: user.email ?? '',
        createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
        lastLoginAt: firebaseUser.metadata.lastSignInTime ?? DateTime.now(),
        friendIds: [],
        pushEnabled: true,
      ).copyWith(
        name: user.displayName,
        friendIds: user.friendIds,
      ));
    } catch (e) {
      return Left(AppErrorHandler.handle(e));
    }
  }
}
