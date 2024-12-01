import 'package:fluttalk/core/state/async_value.dart';
import 'package:fluttalk/domain/entities/friend_entity.dart';
import 'package:fluttalk/domain/usecase/friend/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendListCubit extends Cubit<AsyncValue<List<FriendEntity>>> {
  final GetFriendsUseCase _getFriendsUseCase;
  final AddFriendUseCase _addFriendUseCase;
  final RemoveFriendUseCase _removeFriendUseCase;

  FriendListCubit({
    required GetFriendsUseCase getFriendsUseCase,
    required AddFriendUseCase addFriendUseCase,
    required RemoveFriendUseCase removeFriendUseCase,
  })  : _getFriendsUseCase = getFriendsUseCase,
        _addFriendUseCase = addFriendUseCase,
        _removeFriendUseCase = removeFriendUseCase,
        super(const AsyncInitial());

  Future<void> getFriends() async {
    emit(const AsyncLoading());
    final result = await _getFriendsUseCase.execute();
    result.fold(
      (error) => emit(AsyncError(error.message)),
      (friends) => emit(AsyncData(friends)),
    );
  }

  Future<void> addFriend(String email) async {
    final currentState = state;
    if (currentState is! AsyncData<List<FriendEntity>>) return;

    emit(const AsyncLoading());
    final result = await _addFriendUseCase.execute(email);
    result.fold(
      (error) {
        emit(currentState);
        emit(AsyncError(error.message));
      },
      (friend) {
        final updatedFriends = [...currentState.data, friend];
        emit(AsyncData(updatedFriends));
      },
    );
  }

  Future<void> removeFriend(String email) async {
    final currentState = state;
    if (currentState is! AsyncData<List<FriendEntity>>) return;

    emit(const AsyncLoading());
    final result = await _removeFriendUseCase.execute(email);
    result.fold(
      (error) {
        emit(currentState);
        emit(AsyncError(error.message));
      },
      (removedFriend) {
        final updatedFriends = currentState.data
            .where((friend) => friend.id != removedFriend.id)
            .toList();
        emit(AsyncData(updatedFriends));
      },
    );
  }
}
