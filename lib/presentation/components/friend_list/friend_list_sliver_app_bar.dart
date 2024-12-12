import 'package:fluttalk/domain/services/friend_service.dart';
import 'package:fluttalk/gen/assets.gen.dart';
import 'package:fluttalk/presentation/blocs/friend_list_cubit.dart';
import 'package:fluttalk/presentation/blocs/friend_management_cubit.dart';
import 'package:fluttalk/presentation/components/bottom_sheet/add_friend_bottom_sheet.dart';
import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:fluttalk/presentation/theme/my_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendListSliverAppBar extends StatelessWidget {
  // final VoidCallback? onAddFrinedTap;
  const FriendListSliverAppBar({super.key});

  void _showAddFriendBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return MultiBlocProvider(
          providers: [
            RepositoryProvider.value(
              value: context.read<FriendService>(),
            ),
            // 기존 FriendManagementCubit을 재사용
            BlocProvider.value(
              value: context.read<FriendManagementCubit>(),
            ),
            // 기존 FriendListCubit도 전달
            BlocProvider.value(
              value: context.read<FriendListCubit>(),
            ),
          ],
          child: const AddFriendBottomSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: MyColors.neutralWhite,
      title: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text(
          'Friends',
          style: MyTextStyles.subheading1.copyWith(
            color: MyColors.neutralActive,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16, bottom: 8),
          child: InkWell(
            onTap: () => _showAddFriendBottomSheet(context),
            child: Assets.icons.plus.image(
              scale: 2,
              color: MyColors.neutralActive,
            ),
          ),
        ),
      ],
      scrolledUnderElevation: 0,
      centerTitle: false,
      pinned: true,
    );
  }
}
