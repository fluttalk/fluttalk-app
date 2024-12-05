import 'package:fluttalk/presentation/bloc/base/async_value.dart';
import 'package:fluttalk/domain/entities/me_entity.dart';
import 'package:fluttalk/domain/services/auth_service.dart';
import 'package:fluttalk/domain/services/user_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MeCubit extends Cubit<AsyncValue<MeEntity>> {
  final AuthService _authService;
  final UserService _userService;

  MeCubit(
    this._authService,
    this._userService,
  ) : super(const AsyncInitial());

  // 이메일로 로그인하고 사용자 정보를 로드합니다
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(const AsyncLoading());

    final result = await _authService.signInWithEmail(
      email: email,
      password: password,
    );

    await result.fold(
      (error) async => emit(AsyncError(error.message)),
      (me) async {
        // 인증 성공 후 서버에서 추가 정보를 가져옵니다
        final meResult = await _userService.getMe();
        meResult.fold(
          (error) => emit(AsyncError(error.message)),
          (me) => emit(AsyncData(me)),
        );
      },
    );
  }

  // 회원가입 후 사용자 정보를 로드합니다
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    emit(const AsyncLoading());

    final result = await _authService.signUpWithEmail(
      email: email,
      password: password,
    );

    await result.fold(
      (error) async => emit(AsyncError(error.message)),
      (me) async {
        // 회원가입 성공 후 서버에서 정보를 가져옵니다
        final meResult = await _userService.getMe();
        meResult.fold(
          (error) => emit(AsyncError(error.message)),
          (me) => emit(AsyncData(me)),
        );
      },
    );
  }

  // 로그아웃 처리를 합니다
  Future<void> signOut() async {
    emit(const AsyncLoading());

    final result = await _authService.signOut();

    result.fold(
      (error) => emit(AsyncError(error.message)),
      (_) => emit(const AsyncInitial()),
    );
  }

  // 사용자 이름을 업데이트합니다
  Future<void> updateName({required String name}) async {
    emit(const AsyncLoading());

    final result = await _userService.updateName(name: name);

    result.fold(
      (error) => emit(AsyncError(error.message)),
      (me) => emit(AsyncData(me)),
    );
  }

  // 서버에서 최신 사용자 정보를 가져옵니다
  Future<void> refresh() async {
    emit(const AsyncLoading());

    final result = await _userService.getMe();

    result.fold(
      (error) => emit(AsyncError(error.message)),
      (me) => emit(AsyncData(me)),
    );
  }
}
