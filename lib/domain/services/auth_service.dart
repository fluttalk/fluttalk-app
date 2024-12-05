import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/domain/entities/me_entity.dart';
import 'package:fluttalk/domain/usecase/auth/get_auth_state_changes_usecase.dart';
import 'package:fluttalk/domain/usecase/auth/get_current_user_usecase.dart';
import 'package:fluttalk/domain/usecase/auth/sign_in_with_email_usecase.dart';
import 'package:fluttalk/domain/usecase/auth/sign_out_usecase.dart';
import 'package:fluttalk/domain/usecase/auth/sign_up_with_email_usecase.dart';
import 'package:fpdart/fpdart.dart';

class AuthService {
  final SignInWithEmailUseCase _signInWithEmailUseCase;
  final SignUpWithEmailUseCase _signUpWithEmailUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetAuthStateChangesUseCase _getAuthStateChangesUseCase;

  AuthService(
    this._signInWithEmailUseCase,
    this._signUpWithEmailUseCase,
    this._signOutUseCase,
    this._getCurrentUserUseCase,
    this._getAuthStateChangesUseCase,
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
}
