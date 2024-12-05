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

  void _showAddFriendDialog(BuildContext context) {
    final emailController = TextEditingController();
    final cubit = context.read<FriendManagementCubit>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('친구 추가'),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: '이메일',
            hintText: '친구의 이메일을 입력하세요',
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              final email = emailController.text.trim();
              if (email.isNotEmpty) {
                cubit.addFriend(email);
                Navigator.pop(context);
              }
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FriendManagementCubit, AsyncValue<FriendEntity>>(
      listener: (context, state) {
        if (state is AsyncError) {
          switch (state) {
            case AsyncError(message: final message):
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            case AsyncData():
              context.read<FriendListCubit>().loadFriends();
            case _:
              break;
          }
        }
        if (state is AsyncData) {
          context.read<FriendListCubit>().loadFriends();
        }
      },
      builder: (context, managementState) {
        return BlocBuilder<FriendListCubit, AsyncValue<List<FriendEntity>>>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                FriendListSliverAppBar(
                  onAddFrinedTap: () => _showAddFriendDialog(context),
                ),
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
