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
        emit(AsyncError(failure.message));
        return false;
      },
      (friend) {
        emit(AsyncData(friend));
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
