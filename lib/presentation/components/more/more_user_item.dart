import 'package:fluttalk/domain/entities/me_entity.dart';
import 'package:fluttalk/gen/assets.gen.dart';
import 'package:fluttalk/presentation/bloc/base/async_value.dart';
import 'package:fluttalk/presentation/blocs/me_cubit.dart';
import 'package:fluttalk/presentation/components/common/item_titles.dart';
import 'package:fluttalk/presentation/screens/profile_screen.dart';
import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoreUserItem extends StatelessWidget {
  const MoreUserItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeCubit, AsyncValue<MeEntity>>(
      builder: (context, state) {
        final user = switch (state) {
          AsyncData(data: final me) => me,
          _ => null,
        };

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: MyColors.neutralLine,
                  ),
                  child: Center(
                    child: Assets.icons.user.image(scale: 2),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ItemTitles(
                    main: user?.email ?? '',
                    sub: user?.name ?? '',
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  child: Assets.icons.chevronRight.image(scale: 2),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


// class MoreUserItem extends StatelessWidget {
//   final MoreUserItemData data;
//   const MoreUserItem({
//     required this.data,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       child: Row(
//         children: [
//           Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(50),
//               color: MyColors.neutralLine,
//             ),
//             child: Center(
//               child: Assets.icons.user.image(
//                 scale: 2,
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           ItemTitles(
//             main: data.name,
//             sub: data.email,
//           ),
//           const SizedBox(width: 6),
//           InkWell(
//             child: Assets.icons.chevronRight.image(scale: 2),
//           )
//         ],
//       ),
//     );
//   }
// }
