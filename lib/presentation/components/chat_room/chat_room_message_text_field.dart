import 'package:fluttalk/gen/assets.gen.dart';
import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class ChatRoomMessageTextField extends StatelessWidget {
  static const height = 56.0;
  const ChatRoomMessageTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: MyColors.neutralWhite,
        child: Column(
          children: [
            Container(
              height: 1,
              color: MyColors.neutralLine,
            ),
            SizedBox(
              height: height,
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  InkWell(
                    child: Assets.icons.plusLight.image(
                      scale: 2,
                      color: MyColors.neutralDisabled,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: MyColors.neutralOffWhite,
                          hintText: "메시지를 입력해주세요.",
                          contentPadding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            left: 10,
                          ),
                          hintStyle: const TextStyle(
                            color: MyColors.neutralDisabled,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    child: Assets.icons.sendAltFilledLight.image(
                      scale: 2,
                      color: MyColors.brandDefault,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
