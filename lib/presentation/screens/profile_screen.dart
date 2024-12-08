import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttalk/gen/assets.gen.dart';
import 'package:fluttalk/presentation/bloc/base/async_value.dart';
import 'package:fluttalk/presentation/blocs/me_cubit.dart';
import 'package:fluttalk/presentation/components/common/common_text_field.dart';
import 'package:fluttalk/presentation/components/common/custom_button.dart';
import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:fluttalk/domain/entities/me_entity.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _textEditingController = TextEditingController();
  bool canSave = false;

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(_onChangedName);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<MeCubit>().state;
      if (state case AsyncData(data: final me)) {
        _textEditingController.text = me.name ?? '';
        canSave = _textEditingController.text.isNotEmpty;
      }
    });
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_onChangedName);
    _textEditingController.dispose();
    super.dispose();
  }

  _onChangedName() {
    setState(() {
      canSave = _textEditingController.text.isNotEmpty;
    });
  }

  _save(BuildContext context) {
    context.read<MeCubit>().updateName(name: _textEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MeCubit, AsyncValue<MeEntity>>(
      listener: (context, state) {
        switch (state) {
          case AsyncError(message: final message):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          case AsyncData():
            Navigator.of(context).pop();
          case _:
            break;
        }
      },
      builder: (context, state) {
        final isLoading = state is AsyncLoading;

        return Scaffold(
          appBar: AppBar(
            title: const Text("내 정보"),
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 45),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      color: MyColors.neutralOffWhite,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Assets.icons.user.image(scale: 1),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 31),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: CommonTextField(
                    hintText: "이름을 입력해주세요.",
                    textEditingController: _textEditingController,
                    // enabled: !isLoading,
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: CustomButton(
                        onTap: (canSave && !isLoading)
                            ? () => _save(context)
                            : null,
                        isPrimary: canSave && !isLoading,
                        title: isLoading ? "저장 중..." : "저장 하기",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: 32,
                      ),
                      child: CustomButton(
                        onTap: isLoading
                            ? null
                            : () => context.read<MeCubit>().signOut(),
                        isPrimary: false,
                        title: "로그아웃",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
