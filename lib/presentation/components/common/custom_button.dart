import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:fluttalk/presentation/theme/my_text_styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function? onTap;
  final bool isPrimary;
  final bool isEnabled;
  final String title;
  const CustomButton({
    this.onTap,
    required this.isPrimary,
    required this.title,
    this.isEnabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (isEnabled && onTap != null) ? () => onTap!() : null,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: isPrimary
              ? MyColors.brandDefault.withOpacity(
                  isEnabled ? 1.0 : 0.5,
                )
              : null,
          border: isPrimary
              ? null
              : Border.all(
                  color: MyColors.brandDefault.withOpacity(
                    isEnabled ? 1.0 : 0.5,
                  ),
                  width: 1,
                ),
        ),
        child: Center(
          child: Text(
            title,
            style: MyTextStyles.bodyText1.copyWith(
              color:
                  isPrimary ? MyColors.neutralOffWhite : MyColors.brandDefault,
            ),
          ),
        ),
      ),
    );
  }
}
