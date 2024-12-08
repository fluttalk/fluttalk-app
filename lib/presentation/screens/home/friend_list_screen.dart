import 'package:fluttalk/data/repositories/friend_repository.dart';
import 'package:fluttalk/domain/services/friend_service.dart';
import 'package:fluttalk/domain/usecase/friend/index.dart';
import 'package:fluttalk/presentation/blocs/friend_list_cubit.dart';
import 'package:fluttalk/presentation/blocs/friend_management_cubit.dart';
import 'package:fluttalk/presentation/screens/home/friend_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendListScreen extends StatelessWidget {
  const FriendListScreen({super.key});

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

    return MultiBlocProvider(
      providers: [
        RepositoryProvider.value(value: friendService),
        BlocProvider(
          create: (context) => FriendListCubit(friendService)..loadFriends(),
        ),
        BlocProvider(
          create: (context) => FriendManagementCubit(friendService),
        ),
      ],
      child: const FriendListView(),
    );
  }
}



// class FriendListScreen extends StatelessWidget {
//   const FriendListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       slivers: [
//         const FriendListSliverAppBar(),
//         SliverList(
//           delegate: SliverChildBuilderDelegate(
//             (_, index) => switch (index) {
//               0 => const SizedBox(),
//               // const SearchTextField(placeholder: "Search"),
//               _ => const FriendListItem(),
//             },
//             childCount: 20,
//           ),
//         ),
//       ],
//     );
//   }
// }
