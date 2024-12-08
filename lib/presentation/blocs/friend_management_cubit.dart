import 'package:fluttalk/domain/entities/friend_entity.dart';
import 'package:fluttalk/domain/services/friend_service.dart';
import 'package:fluttalk/presentation/bloc/base/async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendManagementCubit extends Cubit<AsyncValue<FriendEntity>> {
  final FriendService _friendService;

  FriendManagementCubit(this._friendService) : super(const AsyncInitial());

  Future<bool> addFriend(String email) async {
    emit(const AsyncLoading());

    final result = await _friendService.addFriend(email: email);

    return result.fold(
      (failure) {
        print('Add friend failed: ${failure.message}'); // 실패 로그
        emit(AsyncError(failure.message));
        return false;
      },
      (friend) {
        print('Add friend success: $friend'); // 성공 로그
        print('Emitting AsyncData state'); // 상태 변경 직전 로그
        emit(AsyncData(friend));
        print('AsyncData state emitted');
        return true;
      },
    );
  }

  Future<bool> removeFriend(String email) async {
    emit(const AsyncLoading());

    final result = await _friendService.removeFriend(email: email);

    return result.fold(
      (failure) {
        emit(AsyncError(failure.message));
        return false;
      },
      (friend) {
        emit(AsyncData(friend));
        return true;
      },
    );
  }
}
