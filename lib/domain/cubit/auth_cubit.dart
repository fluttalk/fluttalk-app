import 'package:fluttalk/core/state/async_value.dart';
import 'package:fluttalk/domain/entities/user_entity.dart';
import 'package:fluttalk/domain/usecase/auth/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AsyncValue<UserEntity>> {
  final GetMeUseCase _getMeUseCase;
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final UpdateMeUseCase _updateMeUseCase;
  final SignOutUseCase _signOutUseCase;

  AuthCubit({
    required GetMeUseCase getMeUseCase,
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required UpdateMeUseCase updateMeUseCase,
    required SignOutUseCase signOutUseCase,
  })  : _getMeUseCase = getMeUseCase,
        _signInUseCase = signInUseCase,
        _signUpUseCase = signUpUseCase,
        _updateMeUseCase = updateMeUseCase,
        _signOutUseCase = signOutUseCase,
        super(const AsyncInitial());

  Future<void> getMe() async {
    emit(const AsyncLoading());
    final result = await _getMeUseCase.execute();
    result.fold(
      (error) => emit(AsyncError(error.message)),
      (user) => emit(AsyncData(user)),
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(const AsyncLoading());
    final result = await _signInUseCase.execute(
      email: email,
      password: password,
    );
    result.fold(
      (error) => emit(AsyncError(error.message)),
      (user) => emit(AsyncData(user)),
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    emit(const AsyncLoading());
    final result = await _signUpUseCase.execute(
      email: email,
      password: password,
    );
    result.fold(
      (error) => emit(AsyncError(error.message)),
      (user) => emit(AsyncData(user)),
    );
  }

  Future<void> updateProfile(String name) async {
    emit(const AsyncLoading());
    final result = await _updateMeUseCase.execute(name);
    result.fold(
      (error) => emit(AsyncError(error.message)),
      (user) => emit(AsyncData(user)),
    );
  }

  Future<void> signOut() async {
    emit(const AsyncLoading());
    final result = await _signOutUseCase.execute();
    result.fold(
      (error) => emit(AsyncError(error.message)),
      (_) => emit(const AsyncInitial()),
    );
  }
}
