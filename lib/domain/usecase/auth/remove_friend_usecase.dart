import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/data/repositories/auth_repository.dart';
import 'package:fluttalk/data/repositories/friend_repository.dart';
import 'package:fluttalk/domain/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';

class RemoveFriendUseCase {
  final FriendRepository _friendRepository;
  final AuthRepository _authRepository;
  final FirebaseAuth _auth;

  RemoveFriendUseCase(this._friendRepository, this._authRepository, this._auth);

  Future<Either<AppException, UserEntity>> execute(String email) async {
    try {
      // 1. 친구 제거
      await _friendRepository
          .removeFriendByEmail(RemoveFriendRequest(email: email));

      // 2. 현재 유저 정보 갱신
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        return Left(UnauthorizedException());
      }

      final user = await _authRepository.getMe();

      return Right(UserEntity(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName,
        friendIds: user.friendIds,
        createdAt: currentUser.metadata.creationTime ?? DateTime.now(),
        lastLoginAt: currentUser.metadata.lastSignInTime ?? DateTime.now(),
        pushEnabled: true,
      ));
    } catch (e) {
      return Left(AppErrorHandler.handle(e));
    }
  }
}
