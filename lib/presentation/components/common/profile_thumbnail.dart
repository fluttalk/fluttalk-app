import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class ProfileThumbnail extends StatelessWidget {
  const ProfileThumbnail({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: SizedBox(
        width: 48,
        height: 48,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: MyColors.profileBackgroind,
          ),
        ),
      ),
    );
  }
}
