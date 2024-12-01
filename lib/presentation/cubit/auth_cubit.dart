import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttalk/core/state/async_value.dart';
import 'package:fluttalk/data/repositories/auth_repository.dart';
import 'package:fluttalk/domain/usecase/auth/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AsyncValue<bool>> {
  final AuthRepository _authRepository;
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  StreamSubscription<User?>? _authStateSubscription;

  AuthCubit({
    required AuthRepository authRepository,
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required SignOutUseCase signOutUseCase,
  })  : _authRepository = authRepository,
        _signInUseCase = signInUseCase,
        _signUpUseCase = signUpUseCase,
        _signOutUseCase = signOutUseCase,
        super(const AsyncInitial()) {
    _initializeAuthStateSubscription();
  }

  void _initializeAuthStateSubscription() {
    _authStateSubscription = _authRepository.authStateChanges().listen(
      (user) {
        emit(AsyncData(user != null));
      },
      onError: (error) {
        emit(AsyncError(error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
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
      (error) {
        emit(AsyncError(error.message));
        throw error;
      },
      (_) => null, // authStateChanges가 처리
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
      (error) {
        emit(AsyncError(error.message));
        throw error;
      },
      (_) => null, // authStateChanges가 처리
    );
  }

  Future<void> signOut() async {
    emit(const AsyncLoading());
    final result = await _signOutUseCase.execute();
    result.fold(
      (error) {
        emit(AsyncError(error.message));
        throw error;
      },
      (_) => null, // authStateChanges가 처리
    );
  }
}
