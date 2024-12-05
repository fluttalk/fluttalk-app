import 'package:fluttalk/domain/entities/me_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttalk/presentation/bloc/base/async_value.dart';
import 'package:fluttalk/presentation/blocs/me_cubit.dart';
import 'package:fluttalk/presentation/common/more_groups_child.dart';
import 'package:fluttalk/presentation/components/more/more_group_item.dart';
import 'package:fluttalk/presentation/components/more/more_seperator_item.dart';
import 'package:fluttalk/presentation/components/more/more_user_item.dart';
import 'package:fluttalk/presentation/components/more/more_sliver_app_bar.dart';

class MoreView extends StatelessWidget {
  static List<MoreItemData> getItems(MeEntity? me) => [
        MoreUserItemData(
          name: me?.name ?? "없음",
          email: me?.email ?? "",
        ),
        const MoreGroupItemData(children: [
          MoreGroupsChild.help,
          MoreGroupsChild.privacy,
        ]),
        MoreSeperatorItemData(),
      ];

  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MeCubit, AsyncValue<MeEntity>>(
      listener: (context, state) {
        switch (state) {
          case AsyncError(message: final message):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          case _:
            break;
        }
      },
      builder: (context, state) {
        final items = switch (state) {
          AsyncInitial() => getItems(null),
          AsyncLoading() => getItems(null),
          AsyncError() => getItems(null),
          AsyncData(data: final me) => getItems(me),
        };

        return CustomScrollView(
          slivers: [
            const MoreSliverAppBar(),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) => switch (items[index]) {
                  MoreUserItemData data => MoreUserItem(
                      data: data,
                      isLoading: state is AsyncLoading,
                    ),
                  MoreGroupItemData data => MoreGroupItem(data: data),
                  MoreSeperatorItemData _ => const MoreSeperatorItem(),
                },
                childCount: items.length,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: () => context.read<MeCubit>().signOut(),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: const Text('LogOut'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
