import 'package:flutter/material.dart';

class MyColors {
  static const brandDark = Color(0xFF001a83);
  static const brandDefault = Color(0xFF002DE3);
  static const brandDarkMode = Color(0xFF375FFF);
  static const brandLight = Color(0xFF879FFF);
  static const brandBG = Color(0xFFD2D5F9);

  static const neutralActive = Color(0xFF0F1828);
  static const neutralDark = Color(0xFF152033);
  static const neutralBody = Color(0xFF1B2B48);
  static const neutralWeak = Color(0xFFA4A4A4);
  static const neutralDisabled = Color(0xFFADB5BD);
  static const neutralLine = Color(0xFFEDEDED);
  static const neutralOffWhite = Color(0xFFF7F7FC);
  static const neutralWhite = Color(0xFFFFFFFF);

  static const accentDanger = Color(0xFFE94242);
  static const accentWarning = Color(0xFFFDCF41);
  static const accentSuccess = Color(0xFF2CC069);
  static const accentSafe = Color(0xFF7BCBCF);

  static const profileBackgroind = Color(0xFF166FF6);

  static const gradientStyle01 = LinearGradient(
    colors: [
      Color(0xFFD2D5F9),
      Color(0xFF2C37E1),
    ],
    begin: Alignment.bottomLeft,
    end: Alignment.bottomRight,
  );

  static const gradientStyle02 = LinearGradient(
    colors: [
      Color(0xFFEC9EFF),
      Color(0xFF5F2EEA),
    ],
    begin: Alignment.bottomLeft,
    end: Alignment.bottomRight,
  );
}
