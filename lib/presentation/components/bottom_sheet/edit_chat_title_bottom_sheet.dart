import 'package:fluttalk/presentation/components/bottom_sheet/custom_sliver_header_delegate.dart';
import 'package:fluttalk/presentation/components/common/common_text_field.dart';
import 'package:fluttalk/presentation/components/common/custom_button.dart';
import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:fluttalk/presentation/theme/my_text_styles.dart';
import 'package:flutter/material.dart';

class EditChatTitleBottomSheet extends StatefulWidget {
  // final Function(String title) onConfirmed;
  const EditChatTitleBottomSheet({super.key});

  @override
  State<EditChatTitleBottomSheet> createState() =>
      _EditChatTitleBottomSheetState();
}

class _EditChatTitleBottomSheetState extends State<EditChatTitleBottomSheet> {
  final _textEditingController = TextEditingController();
  bool _canCreate = false;

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(_onChangedChatTitle);
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_onChangedChatTitle);
    super.dispose();
  }

  _onChangedChatTitle() {
    setState(() {
      _canCreate = _textEditingController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: 200,
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: CustomSliverHeaderDelegate(
                widget: Text(
                  "채팅방의 제목을 입력해주세요",
                  style: MyTextStyles.subheading2.copyWith(
                    color: MyColors.neutralActive,
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Center(
                        child: CommonTextField(
                          textEditingController: _textEditingController,
                          hintText: "채팅방의 제목을 입력해주세요",
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      onTap: () => Navigator.of(context)
                          .pop(_textEditingController.text),
                      isPrimary: true,
                      isEnabled: _canCreate,
                      title: "생성 하기",
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
