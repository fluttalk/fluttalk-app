import 'package:fluttalk/data/repositories/friend_repository.dart';
import 'package:fluttalk/domain/entities/friend_entity.dart';
import 'package:fluttalk/domain/services/friend_service.dart';
import 'package:fluttalk/domain/usecase/friend/index.dart';
import 'package:fluttalk/presentation/bloc/base/async_value.dart';
import 'package:fluttalk/presentation/blocs/friend_list_cubit.dart';
import 'package:fluttalk/presentation/components/bottom_sheet/custom_sliver_header_delegate.dart';
import 'package:fluttalk/presentation/components/friend_list/friend_list_item.dart';
import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:fluttalk/presentation/theme/my_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectFriendBottomSheet extends StatelessWidget {
  const SelectFriendBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final getFriendsUseCase =
        GetFriendsUseCase(context.read<FriendRepository>());
    final addFriendUseCase = AddFriendUseCase(context.read<FriendRepository>());
    final removeFriendUseCase =
        RemoveFriendUseCase(context.read<FriendRepository>());
    final friendService = FriendService(
      getFriendsUseCase,
      addFriendUseCase,
      removeFriendUseCase,
    );
    return BlocProvider(
      create: (context) => FriendListCubit(friendService)..loadFriends(),
      child: BlocBuilder<FriendListCubit, AsyncValue<List<FriendEntity>>>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                delegate: CustomSliverHeaderDelegate(
                  widget: Text(
                    "채팅을 시작할 친구를 선택하세요",
                    style: MyTextStyles.subheading2.copyWith(
                      color: MyColors.neutralActive,
                    ),
                  ),
                ),
              ),
              switch (state) {
                AsyncInitial() || AsyncLoading() => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                AsyncError(message: final message) => SliverFillRemaining(
                    child: Center(child: Text(message)),
                  ),
                AsyncData(data: final friends) => friends.isEmpty
                    ? const SliverFillRemaining(
                        child: Center(child: Text("친구가 없습니다")),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => FriendListItem(
                            friend: friends[index],
                            onTap: (friend) =>
                                Navigator.of(context).pop(friend),
                          ),
                          childCount: friends.length,
                        ),
                      ),
              },
            ],
          );
        },
      ),
    );
  }
}
