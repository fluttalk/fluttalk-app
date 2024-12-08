import 'package:fluttalk/domain/entities/friend_entity.dart';
import 'package:fluttalk/presentation/bloc/base/async_value.dart';
import 'package:fluttalk/presentation/blocs/friend_list_cubit.dart';
import 'package:fluttalk/presentation/blocs/friend_management_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttalk/presentation/components/friend_list/friend_list_sliver_app_bar.dart';
import 'package:fluttalk/presentation/components/friend_list/friend_list_item.dart';

class FriendListView extends StatelessWidget {
  const FriendListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FriendManagementCubit, AsyncValue<FriendEntity>>(
      listener: (context, state) {
        print('Listener received state: ${state.runtimeType}'); // 상태 타입 확인

        if (state is AsyncError) {
          print('Handling AsyncError');
          switch (state) {
            case AsyncError(message: final message):
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            case (_):
              break;
          }
        } else if (state is AsyncData<FriendEntity>) {
          print('Handling AsyncData, about to load friends');
          // 약간의 딜레이를 주어 상태가 안정화되도록 함
          Future.microtask(() {
            context.read<FriendListCubit>().loadFriends();
          });
        }
      },
      builder: (context, managementState) {
        return BlocBuilder<FriendListCubit, AsyncValue<List<FriendEntity>>>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                const FriendListSliverAppBar(),
                switch (state) {
                  AsyncInitial() => const SliverFillRemaining(
                      child: Center(child: Text("친구 목록을 불러오는 중...")),
                    ),
                  AsyncLoading() => const SliverFillRemaining(
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
                            (context, index) {
                              if (index == 0) return const SizedBox();

                              final friend = friends[index - 1];
                              return FriendListItem(
                                friend: friend,
                                onTap: (friend) => {},
                              );
                            },
                            childCount: friends.length + 1,
                          ),
                        ),
                },
              ],
            );
          },
        );
      },
    );
  }
}
