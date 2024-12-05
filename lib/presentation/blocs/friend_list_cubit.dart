import 'package:fluttalk/domain/entities/friend_entity.dart';
import 'package:fluttalk/domain/services/friend_service.dart';
import 'package:fluttalk/presentation/bloc/base/async_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendListCubit extends Cubit<AsyncValue<List<FriendEntity>>> {
  final FriendService _friendService;

  FriendListCubit(this._friendService) : super(const AsyncInitial());

  Future<void> loadFriends() async {
    emit(const AsyncLoading());

    final result = await _friendService.getFriends();

    result.fold(
      (failure) => emit(AsyncError(failure.message)),
      (friends) => emit(AsyncData(friends)),
    );
  }

  // Future<void> addFriend(String email) async {
  //   if (state is! AsyncData<List<FriendEntity>>) return;
  //   final friends = (state as AsyncData<List<FriendEntity>>).data;

  //   final result = await _friendService.addFriend(email: email);

  //   result.fold(
  //     (failure) => emit(AsyncError(failure.message)),
  //     (friend) => emit(AsyncData([...friends, friend])),
  //   );
  // }

  // Future<void> removeFriend(String email) async {
  //   if (state is! AsyncData<List<FriendEntity>>) return;
  //   final friends = (state as AsyncData<List<FriendEntity>>).data;

  //   final result = await _friendService.removeFriend(email: email);

  //   result.fold(
  //     (failure) => emit(AsyncError(failure.message)),
  //     (removedFriend) => emit(AsyncData(
  //       friends.where((f) => f.email != email).toList(),
  //     )),
  //   );
  // }
}
