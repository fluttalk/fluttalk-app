import 'package:fluttalk/domain/entities/friend_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttalk/presentation/blocs/friend_management_cubit.dart';
import 'package:fluttalk/presentation/bloc/base/async_value.dart';
import 'package:fluttalk/presentation/components/bottom_sheet/custom_sliver_header_delegate.dart';
import 'package:fluttalk/presentation/components/common/custom_button.dart';
import 'package:fluttalk/presentation/components/common/search_text_field.dart';
import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:fluttalk/presentation/theme/my_text_styles.dart';

class AddFriendBottomSheet extends StatefulWidget {
  const AddFriendBottomSheet({super.key});

  @override
  State<AddFriendBottomSheet> createState() => _AddFriendBottomSheetState();
}

class _AddFriendBottomSheetState extends State<AddFriendBottomSheet> {
  final _textEditingController = TextEditingController();

  void _onAdd(BuildContext context) {
    final email = _textEditingController.text.trim();
    if (email.isEmpty) return;

    context.read<FriendManagementCubit>().addFriend(email);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FriendManagementCubit, AsyncValue<FriendEntity>>(
      listener: (context, state) {
        switch (state) {
          case AsyncError(message: final message):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          case AsyncData():
            Navigator.of(context).pop();
          case _:
            break;
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(
          height: 280,
          child: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                delegate: CustomSliverHeaderDelegate(
                  widget: Text(
                    "친구 추가하기",
                    style: MyTextStyles.subheading2.copyWith(
                      color: MyColors.neutralActive,
                    ),
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Center(
                          child: SearchTextField(
                            placeholder: '이메일 주소를 입력해주세요.',
                            controller: _textEditingController,
                          ),
                        ),
                      ),
                      BlocBuilder<FriendManagementCubit,
                          AsyncValue<FriendEntity>>(
                        builder: (context, state) {
                          final isLoading = state is AsyncLoading;
                          return CustomButton(
                            onTap: isLoading ? null : () => _onAdd(context),
                            isPrimary: true,
                            title: isLoading ? '추가 중...' : '추가',
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        onTap: () => Navigator.of(context).pop(),
                        isPrimary: false,
                        title: '닫기',
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
