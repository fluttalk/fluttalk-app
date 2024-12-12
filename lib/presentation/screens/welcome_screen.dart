import 'package:fluttalk/gen/assets.gen.dart';
import 'package:fluttalk/presentation/screens/auth_state_screen.dart';
import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:fluttalk/presentation/theme/my_text_styles.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  _moveNext(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const AuthStateScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Assets.images.login.image(scale: 2),
              const SizedBox(height: 42),
              const Text(
                "다양한 플러터 개발자들과\n이야기를 나눠보세요",
                style: MyTextStyles.heading2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 127),
              const Text(
                "이용 약관 및 정책",
                style: MyTextStyles.bodyText1,
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 52,
                child: Material(
                  color: MyColors.brandDefault,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: () => _moveNext(context),
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SizedBox(
                      width: 327,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 8),
                          Text(
                            "대화 시작하기",
                            style: MyTextStyles.subheading2.copyWith(
                              color: MyColors.neutralOffWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
