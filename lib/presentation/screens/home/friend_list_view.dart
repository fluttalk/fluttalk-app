import 'package:fluttalk/domain/entities/friend_entity.dart';
import 'package:fluttalk/presentation/bloc/base/async_value.dart';
import 'package:fluttalk/presentation/blocs/chat_list/chat_list_bloc.dart';
import 'package:fluttalk/presentation/blocs/chat_list/chat_list_event.dart';
import 'package:fluttalk/presentation/blocs/chat_list/chat_list_state.dart';
import 'package:fluttalk/presentation/blocs/friend_list_cubit.dart';
import 'package:fluttalk/presentation/blocs/friend_management_cubit.dart';
import 'package:fluttalk/presentation/components/bottom_sheet/edit_chat_title_bottom_sheet.dart';
import 'package:fluttalk/presentation/components/bottom_sheet/select_friend_action_bottom_sheet.dart';
import 'package:fluttalk/presentation/components/common/enums.dart';
import 'package:fluttalk/presentation/components/common/search_text_field.dart';
import 'package:fluttalk/presentation/screens/chat_room/chat_room_screen.dart';
import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:fluttalk/presentation/theme/my_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttalk/presentation/components/friend_list/friend_list_sliver_app_bar.dart';
import 'package:fluttalk/presentation/components/friend_list/friend_list_item.dart';

class FriendListView extends StatefulWidget {
  const FriendListView({super.key});

  @override
  State<FriendListView> createState() => _FriendListViewState();
}

class _FriendListViewState extends State<FriendListView> {
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FriendListCubit>().loadFriends();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _showChatRoom(BuildContext context, FriendEntity friend) async {
    final result = await showModalBottomSheet<FriendAction>(
      context: context,
      isScrollControlled: false,
      builder: (bottomSheetContext) => SelectFriendActionBottomSheet(
        friend: friend,
      ),
    );

    if (!context.mounted) return;

    if (result == FriendAction.delete) {
      context.read<FriendManagementCubit>().removeFriend(friend.email);
    } else if (result == FriendAction.chat) {
      final title = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: false,
        builder: (bottomSheetContext) => const EditChatTitleBottomSheet(),
      );

      if (title != null && context.mounted) {
        await _createChat(context, friend, title);
      }
    }
  }

  Future<void> _createChat(
      BuildContext context, FriendEntity friend, String title) async {
    context.read<ChatListBloc>().add(CreateChatEvent(
          email: friend.email,
          title: title,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ChatListBloc, ChatListState>(
          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error!)),
              );
            } else if (state.createdChat != null) {
              // 새로 생성된 채팅방이 있을 때만
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ChatRoomScreen(chatId: state.createdChat!.id),
              ));
            }
          },
        ),
        BlocListener<FriendManagementCubit, AsyncValue<FriendEntity>>(
          listener: (context, state) {
            if (state is AsyncError) {
              switch (state) {
                case AsyncError(message: final message):
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                case (_):
                  break;
              }
            } else if (state is AsyncData<FriendEntity>) {
              Future.microtask(() {
                if (context.mounted) {
                  context.read<FriendListCubit>().loadFriends();
                }
              });
            }
          },
        ),
      ],
      child: BlocBuilder<FriendListCubit, AsyncValue<List<FriendEntity>>>(
        builder: (context, state) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).unfocus(); // 포커스 해제
            },
            child: CustomScrollView(
              slivers: [
                const FriendListSliverAppBar(),
                switch (state) {
                  AsyncInitial() || AsyncLoading() => const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  AsyncError(message: final message) => SliverFillRemaining(
                      child: Center(child: Text(message)),
                    ),
                  AsyncData(data: final friends) => friends.isEmpty
                      ? SliverList(
                          delegate: SliverChildListDelegate([
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              child: SearchTextField(
                                placeholder: "검색할 친구 정보를 입력하세요.",
                                controller: _textEditingController,
                              ),
                            ),
                            Center(
                              child: Text(
                                "친구가 없습니다",
                                style: MyTextStyles.bodyText1.copyWith(
                                  color: MyColors.neutralWeak,
                                ),
                              ),
                            ),
                          ]),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index == 0) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                  child: SearchTextField(
                                    placeholder: "검색할 친구 정보를 입력하세요.",
                                    controller: _textEditingController,
                                  ),
                                );
                              }

                              final friend = friends[index - 1];
                              return FriendListItem(
                                friend: friend,
                                onTap: (friend) =>
                                    _showChatRoom(context, friend),
                              );
                            },
                            childCount: friends.length + 1,
                          ),
                        ),
                },
              ],
            ),
          );
        },
      ),
    );
  }
}

// class FriendListView extends StatelessWidget {
//   const FriendListView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<FriendManagementCubit, AsyncValue<FriendEntity>>(
//       listener: (context, state) {
//         // print('Listener received state: ${state.runtimeType}'); // 상태 타입 확인

//         if (state is AsyncError) {
//           // print('Handling AsyncError');
//           switch (state) {
//             case AsyncError(message: final message):
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(message)),
//               );
//             case (_):
//               break;
//           }
//         } else if (state is AsyncData<FriendEntity>) {
//           // print('Handling AsyncData, about to load friends');
//           // 약간의 딜레이를 주어 상태가 안정화되도록 함
//           Future.microtask(() {
//             if (context.mounted) context.read<FriendListCubit>().loadFriends();
//           });
//         }
//       },
//       builder: (context, managementState) {
//         return BlocBuilder<FriendListCubit, AsyncValue<List<FriendEntity>>>(
//           builder: (context, state) {
//             return CustomScrollView(
//               slivers: [
//                 const FriendListSliverAppBar(),
//                 switch (state) {
//                   AsyncInitial() => const SliverFillRemaining(
//                       child: Center(child: Text("친구 목록을 불러오는 중...")),
//                     ),
//                   AsyncLoading() => const SliverFillRemaining(
//                       child: Center(child: CircularProgressIndicator()),
//                     ),
//                   AsyncError(message: final message) => SliverFillRemaining(
//                       child: Center(child: Text(message)),
//                     ),
//                   AsyncData(data: final friends) => friends.isEmpty
//                       ? const SliverFillRemaining(
//                           child: Center(child: Text("친구가 없습니다")),
//                         )
//                       : SliverList(
//                           delegate: SliverChildBuilderDelegate(
//                             (context, index) {
//                               if (index == 0) return const SizedBox();

//                               final friend = friends[index - 1];
//                               return FriendListItem(
//                                 friend: friend,
//                                 onTap: (friend) => {},
//                               );
//                             },
//                             childCount: friends.length + 1,
//                           ),
//                         ),
//                 },
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }
