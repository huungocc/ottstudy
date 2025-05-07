import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/data/models/models.dart';

import '../../../blocs/base_bloc/base.dart';
import '../../../blocs/cubit.dart';
import '../../../gen/assets.gen.dart';
import '../../../res/colors.dart';
import '../../../util/common.dart';
import '../../../util/constants.dart';
import '../../../util/routes.dart';
import '../../widget/widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => LoginCubit(), child: LoginBody());
  }
}

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginBody> {
  final _keyEmail = GlobalKey<TextFieldState>();
  final _keyPassword = GlobalKey<TextFieldState>();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      hideAppBar: true,
      resizeToAvoidBottomInset: true,
      loadingWidget: CustomLoading<LoginCubit>(),
      messageNotify: CustomSnackBar<LoginCubit>(),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Assets.images.imgLogin.image()
                ),
                const SizedBox(height: 40,),
                const CustomTextLabel('Chào mừng đến với 123Study!', gradient: AppColors.base_gradient_1, fontWeight:
                FontWeight.bold,
                  fontSize: 20,),
                const SizedBox(height: 10,),
                const CustomTextLabel('Hãy đăng nhập để bắt đầu học nhé.'),
                const SizedBox(height: 40,),
                CustomTextInput(
                  key: _keyEmail,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.black, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.black, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: "Nhập email",
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Email không được để trống";
                    } else if (!Common.validateEmail(value)) {
                      return "Vui lòng nhập đúng định dạng email";
                    } else {
                      return "";
                    }
                  },
                ),
                const SizedBox(height: 10,),
                CustomTextInput(
                  key: _keyPassword,
                  isPasswordTF: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.black, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.black, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: "Nhập mật khẩu",
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
                BlocListener<LoginCubit, BaseState>(
                  listener: (_, state) {
                    if (state is LoadedState<UserModel>) {
                      if (state.data.role == UserRole.admin) {
                        Navigator.pushNamedAndRemoveUntil(context, Routes.adminHomeScreen, (route) => false);
                      } else {
                        Navigator.pushNamedAndRemoveUntil(context, Routes.mainScreen, (route) => false);
                      }
                    }
                  },
                  child: Container(),
                ),
                const SizedBox(height: 20,),
                BaseButton(
                  onTap: () {
                    if (_keyEmail.currentState!.isValid == true && _keyPassword.currentState!.isValid == true) {
                      Map<String, dynamic> body = {
                        "email": _keyEmail.currentState?.value,
                        "password": _keyPassword.currentState?.value,
                      };
                      BlocProvider.of<LoginCubit>(context).doLogin(body);
                    }
                  },
                  borderRadius: 20,
                  title: 'Đăng nhập',
                ),
                const SizedBox(height: 10,),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.forgotPasswordScreen);
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CustomTextLabel('Quên mật khẩu?', gradient: AppColors.base_gradient_1,)
                  )
                )
              ],
            ),
          ),
        ),
      ),
      bottomBar: BottomAppBar(
        height: 50,
        color: AppColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomTextLabel('Bạn không có tài khoản?'),
            const SizedBox(width: 5,),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.signupScreen);
              },
              child: const CustomTextLabel('Đăng ký ngay', fontWeight: FontWeight.w600, gradient: AppColors.base_gradient_1,)
            )
          ],
        ),
      ),
    );
  }
}
