import 'package:fluttalk/data/repositories/auth_repository.dart';
import 'package:fluttalk/data/repositories/user_repository.dart';
import 'package:fluttalk/domain/services/auth_service.dart';
import 'package:fluttalk/domain/services/user_service.dart';
import 'package:fluttalk/domain/usecase/auth/index.dart';
import 'package:fluttalk/domain/usecase/user/index.dart';
import 'package:fluttalk/presentation/blocs/me_cubit.dart';
import 'package:fluttalk/presentation/screens/home/more_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Auth UseCases
    final signInWithEmailUseCase =
        SignInWithEmailUseCase(context.read<AuthRepository>());
    final signUpWithEmailUseCase =
        SignUpWithEmailUseCase(context.read<AuthRepository>());
    final signOutUseCase = SignOutUseCase(context.read<AuthRepository>());
    final getCurrentUserUseCase =
        GetCurrentUserUseCase(context.read<AuthRepository>());
    final getAuthStateChangesUseCase =
        GetAuthStateChangesUseCase(context.read<AuthRepository>());

    // User UseCases
    final getMeUseCase = GetMeUseCase(
      context.read<UserRepository>(),
      context.read<AuthRepository>(),
    );
    final updateMeUseCase = UpdateMeUseCase(
      context.read<UserRepository>(),
      context.read<AuthRepository>(),
    );

    // Services
    final authService = AuthService(
      signInWithEmailUseCase,
      signUpWithEmailUseCase,
      signOutUseCase,
      getCurrentUserUseCase,
      getAuthStateChangesUseCase,
    );

    final userService = UserService(
      getMeUseCase,
      updateMeUseCase,
    );

    return BlocProvider(
      create: (context) => MeCubit(
        authService,
        userService,
      )..refresh(),
      child: const MoreView(),
    );
  }
}

// class MoreScreen extends StatelessWidget {
//   static List<MoreItemData> items = [
//     const MoreUserItemData(
//       name: "최재영",
//       email: "qwerty@gmail.com",
//     ),
//     const MoreGroupItemData(children: [
//       MoreGroupsChild.help,
//       MoreGroupsChild.privacy,
//     ]),
//     MoreSeperatorItemData(),
//     const MoreGroupItemData(children: [
//       MoreGroupsChild.help,
//       MoreGroupsChild.privacy,
//     ]),
//   ];

//   const MoreScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       slivers: [
//         const MoreSliverAppBar(),
//         SliverList(
//           delegate: SliverChildBuilderDelegate(
//             (_, index) => switch (items[index]) {
//               MoreUserItemData data => MoreUserItem(data: data),
//               MoreGroupItemData data => MoreGroupItem(data: data),
//               MoreSeperatorItemData _ => const MoreSeperatorItem(),
//             },
//             childCount: items.length,
//           ),
//         ),
//       ],
//     );
//   }
// }
