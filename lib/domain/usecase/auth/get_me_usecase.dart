import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/data/repositories/auth_repository.dart';
import 'package:fluttalk/domain/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';

class GetMeUseCase {
  final AuthRepository _repository;
  final FirebaseAuth _auth;

  GetMeUseCase(this._repository, this._auth);

  Future<Either<AppException, UserEntity>> execute() async {
    try {
      final user = await _repository.getMe();
      final currentUser = _auth.currentUser;

      return Right(UserEntity(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName,
        friendIds: user.friendIds,
        createdAt: currentUser?.metadata.creationTime ?? DateTime.now(),
        lastLoginAt: currentUser?.metadata.lastSignInTime ?? DateTime.now(),
        pushEnabled: true,
      ));
    } catch (e) {
      return Left(AppErrorHandler.handle(e));
    }
  }
}
