import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/auth/reset_password_cubit.dart';
import 'package:ottstudy/data/models/forgot_password_model.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';

import '../../../blocs/base_bloc/base_state.dart';
import '../../../gen/assets.gen.dart';
import '../../../res/colors.dart';
import '../../../util/common.dart';
import '../../../util/routes.dart';
import '../../widget/base_button.dart';
import '../../widget/base_loading.dart';
import '../../widget/base_text_input.dart';
import '../../widget/custom_dialog.dart';
import '../../widget/custom_snack_bar.dart';

class ResetPasswordScreen extends StatelessWidget {
  final ForgotPasswordModel? arg;

  const ResetPasswordScreen({Key? key, this.arg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetPasswordCubit(),
      child: ResetPasswordBody(arg: arg)
    );
  }
}

class ResetPasswordBody extends StatefulWidget {
  final ForgotPasswordModel? arg;

  const ResetPasswordBody({Key? key, this.arg}) : super(key: key);

  @override
  State<ResetPasswordBody> createState() => _ResetPasswordBodyState();
}

class _ResetPasswordBodyState extends State<ResetPasswordBody> {
  final _keyNewPassword = GlobalKey<TextFieldState>();
  final _keyConfirmPassword = GlobalKey<TextFieldState>();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Cập nhật mật khẩu',
      colorBackground: AppColors.background_white,
      loadingWidget: CustomLoading<ResetPasswordCubit>(),
      messageNotify: CustomSnackBar<ResetPasswordCubit>(),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 40,),
            Assets.images.imgPassword.image(scale: 2.2),
            const SizedBox(height: 40,),
            CustomTextInput(
              key: _keyNewPassword,
              isPasswordTF: true,
              isRequired: true,
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
                  return "Mật khẩu không được để trống";
                } else if (!Common.validatePassword(value)) {
                  return "Vui lòng nhập mật khẩu có ít nhất 8 ký tự, bao gồm chữ hoa, số và ký tự đặc biệt";
                } else {
                  return "";
                }
              },
            ),
            const SizedBox(height: 15,),
            CustomTextInput(
              key: _keyConfirmPassword,
              isPasswordTF: true,
              isRequired: true,
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
                if (value != _keyNewPassword.currentState!.value) {
                  return "Mật khẩu không trùng khớp";
                } else {
                  return "";
                }
              },
            ),
            BlocListener<ResetPasswordCubit, BaseState>(
              listener: (_, state) {
                if (state is LoadedState<bool>) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialog(
                        content: 'Đổi mật khẩu thành công',
                        onSubmit: () {
                          Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (route) => false);
                        }
                      );
                    }
                  );
                }
              },
              child: Container(),
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
          onTap: () {
            if (_keyNewPassword.currentState!.isValid == true && _keyConfirmPassword.currentState!.isValid == true) {
              Map<String, dynamic> body = {
                "email": widget.arg!.email,
                "token_id": widget.arg!.tokenId,
                "new_password": _keyNewPassword.currentState!.value,
                "confirm_password": _keyConfirmPassword.currentState!.value
              };
              BlocProvider.of<ResetPasswordCubit>(context).resetPassword(body);
            }
          },
        ),
      ),
    );
  }
}

