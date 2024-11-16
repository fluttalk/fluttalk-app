import 'package:fluttalk/gen/fonts.gen.dart';
import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData light() {
    return ThemeData(
      scaffoldBackgroundColor: MyColors.neutralWhite,
      primarySwatch: Colors.blue,
      fontFamily: FontFamily.pretandard,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: MyColors.neutralWhite,
        selectedItemColor: MyColors.neutralActive,
        unselectedItemColor: MyColors.neutralWeak,
      ),
    );
  }
}
