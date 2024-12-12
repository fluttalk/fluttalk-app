import 'package:fluttalk/domain/entities/me_entity.dart';
import 'package:fluttalk/presentation/bloc/base/async_value.dart';
import 'package:fluttalk/presentation/blocs/me_cubit.dart';
import 'package:fluttalk/presentation/components/common/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoreLogoutItem extends StatelessWidget {
  const MoreLogoutItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MeCubit, AsyncValue<MeEntity>>(
      listener: (context, state) {
        switch (state) {
          case AsyncError(message: final message):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          case AsyncInitial():
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('로그아웃되었습니다.')),
            );
          case _:
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<MeCubit, AsyncValue<MeEntity>>(
          builder: (context, state) {
            return CustomButton(
              onTap: state is AsyncLoading
                  ? null
                  : () => context.read<MeCubit>().signOut(),
              isPrimary: false,
              title: state is AsyncLoading ? "로그아웃 중..." : "로그아웃",
            );
          },
        ),
      ),
    );
  }
}
