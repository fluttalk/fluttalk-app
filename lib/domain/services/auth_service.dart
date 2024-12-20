import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/domain/entities/me_entity.dart';
import 'package:fluttalk/domain/entities/token_entity.dart';
import 'package:fluttalk/domain/usecase/auth/index.dart';
import 'package:fluttalk/domain/usecase/auth/revoke_token_usecase.dart';
import 'package:fpdart/fpdart.dart';

class AuthService {
  final SignInWithEmailUseCase _signInWithEmailUseCase;
  final SignUpWithEmailUseCase _signUpWithEmailUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetAuthStateChangesUseCase _getAuthStateChangesUseCase;
  final RefreshTokenUseCase _refreshTokenUseCase;
  final RevokeTokenUseCase _revokeTokenUseCase;

  AuthService(
    this._signInWithEmailUseCase,
    this._signUpWithEmailUseCase,
    this._signOutUseCase,
    this._getCurrentUserUseCase,
    this._getAuthStateChangesUseCase,
    this._refreshTokenUseCase,
    this._revokeTokenUseCase,
  );

  // 현재 인증된 사용자 정보를 가져옵니다
  Either<AppException, MeEntity?> getCurrentUser() {
    return _getCurrentUserUseCase.execute();
  }

  // 인증 상태 변경을 실시간으로 감지합니다
  Stream<Either<AppException, MeEntity?>> getAuthStateChanges() {
    return _getAuthStateChangesUseCase.execute();
  }

  // 이메일로 로그인합니다
  Future<Either<AppException, MeEntity>> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _signInWithEmailUseCase.execute(
      email: email,
      password: password,
    );
  }

  // 이메일로 회원가입합니다
  Future<Either<AppException, MeEntity>> signUpWithEmail({
    required String email,
    required String password,
  }) {
    return _signUpWithEmailUseCase.execute(
      email: email,
      password: password,
    );
  }

  // 로그아웃합니다
  Future<Either<AppException, void>> signOut() {
    return _signOutUseCase.execute();
  }

  // 토큰을 갱신합니다
  Future<Either<AppException, TokenEntity>> refreshToken() {
    return _refreshTokenUseCase.execute();
  }

  // 토큰을 폐기합니다
  Future<Either<AppException, Unit>> revokeToken() {
    return _revokeTokenUseCase.execute();
  }
}
