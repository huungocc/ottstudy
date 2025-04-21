import 'package:flutter/material.dart';
import 'package:ottstudy/ui/widget/base_button.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';

import '../../../gen/assets.gen.dart';
import '../../../res/colors.dart';
import '../../widget/base_text_input.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangePasswordBody();
  }
}

class ChangePasswordBody extends StatefulWidget {
  const ChangePasswordBody({super.key});

  @override
  State<ChangePasswordBody> createState() => _ChangePasswordBodyState();
}

class _ChangePasswordBodyState extends State<ChangePasswordBody> {
  final _keyOldPassword = GlobalKey<TextFieldState>();
  final _keyNewPassword = GlobalKey<TextFieldState>();
  final _keyConfirmPassword = GlobalKey<TextFieldState>();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Cập nhật mật khẩu',
      colorBackground: AppColors.background_white,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 40,),
            Assets.images.imgPassword.image(scale: 2.2),
            const SizedBox(height: 40,),
            CustomTextInput(
              key: _keyOldPassword,
              isPasswordTF: true,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.white, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.white, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: "Mật khẩu cũ",
              validator: (String value) {
                if (value.isEmpty) {
                  return "Loi";
                }
              },
            ),
            const SizedBox(height: 15,),
            CustomTextInput(
              key: _keyNewPassword,
              isPasswordTF: true,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.white, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.white, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: "Mật khẩu mới",
              validator: (String value) {
                if (value.isEmpty) {
                  return "Loi";
                }
              },
            ),
            const SizedBox(height: 15,),
            CustomTextInput(
              key: _keyConfirmPassword,
              isPasswordTF: true,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.white, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.white, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: "Nhập lại mật khẩu mới",
              validator: (String value) {
                if (value.isEmpty) {
                  return "Loi";
                }
              },
            ),
          ],
        ),
      ),
      bottomBar: BottomAppBar(
        color: AppColors.background_white,
        height: 70,
        child: BaseButton(
          title: 'Cập nhật mật khẩu',
          borderRadius: 20,
        ),
      ),
    );
  }
}

