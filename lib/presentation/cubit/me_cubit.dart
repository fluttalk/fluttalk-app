import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttalk/core/state/async_value.dart';
import 'package:fluttalk/data/repositories/auth_repository.dart';
import 'package:fluttalk/domain/entities/me_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/user/index.dart';

class MeCubit extends Cubit<AsyncValue<MeEntity>> {
  final GetMeUseCase _getMeUseCase;
  final UpdateMeUseCase _updateMeUseCase;
  final AuthRepository _authRepository;
  StreamSubscription<User?>? _authStateSubscription;

  MeCubit({
    required GetMeUseCase getMeUseCase,
    required UpdateMeUseCase updateMeUseCase,
    required AuthRepository authRepository,
  })  : _getMeUseCase = getMeUseCase,
        _updateMeUseCase = updateMeUseCase,
        _authRepository = authRepository,
        super(const AsyncInitial()) {
    _initializeAuthStateSubscription();
  }

  void _initializeAuthStateSubscription() {
    _authStateSubscription = _authRepository.authStateChanges().listen(
      (user) {
        if (user != null) {
          getMe();
        } else {
          emit(const AsyncInitial());
        }
      },
    );
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }

  Future<void> getMe() async {
    emit(const AsyncLoading());
    final result = await _getMeUseCase.execute();
    result.fold(
      (error) => emit(AsyncError(error.message)),
      (me) => emit(AsyncData(me)),
    );
  }

  Future<void> updateProfile(String name) async {
    final currentState = state;
    emit(const AsyncLoading());
    final result = await _updateMeUseCase.execute(name);
    result.fold(
      (error) {
        emit(currentState); // 에러 시 이전 상태 복구
        emit(AsyncError(error.message));
      },
      (me) => emit(AsyncData(me)),
    );
  }
}
