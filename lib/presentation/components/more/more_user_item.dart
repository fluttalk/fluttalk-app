import 'package:fluttalk/gen/assets.gen.dart';
import 'package:fluttalk/presentation/common/more_groups_child.dart';
import 'package:fluttalk/presentation/components/common/item_titles.dart';
import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class MoreUserItem extends StatelessWidget {
  final MoreUserItemData data;
  final bool isLoading;

  const MoreUserItem({
    required this.data,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: isLoading
                  ? const _ShimmerContainer(
                      width: 50,
                      height: 50,
                      shape: BoxShape.circle,
                    )
                  : Assets.icons.user.image(scale: 2),
            ),
          ),
          const SizedBox(width: 16),
          if (isLoading)
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerContainer(width: 120, height: 16),
                  SizedBox(height: 4),
                  _ShimmerContainer(width: 180, height: 14),
                ],
              ),
            )
          else
            ItemTitles(
              main: data.name,
              sub: data.email,
            ),
          const SizedBox(width: 6),
          InkWell(
            child: Assets.icons.chevronRight.image(scale: 2),
          )
        ],
      ),
    );
  }
}

class _ShimmerContainer extends StatefulWidget {
  final double width;
  final double height;
  final BoxShape shape;

  const _ShimmerContainer({
    required this.width,
    required this.height,
    this.shape = BoxShape.rectangle,
  });

  @override
  State<_ShimmerContainer> createState() => _ShimmerContainerState();
}

class _ShimmerContainerState extends State<_ShimmerContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: -2,
      end: 2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            shape: widget.shape,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.1, 0.3, 0.5, 0.7, 0.9],
              colors: [
                MyColors.neutralLine,
                MyColors.neutralLine.withOpacity(0.8),
                MyColors.neutralWhite.withOpacity(0.6),
                MyColors.neutralLine.withOpacity(0.8),
                MyColors.neutralLine,
              ],
              transform: GradientRotation(_animation.value),
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
