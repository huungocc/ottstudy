import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/auth/verify_otp_cubit.dart';
import 'package:ottstudy/blocs/base_bloc/base.dart';
import 'package:ottstudy/data/models/forgot_password_model.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/ui/widget/custom_dialog.dart';
import 'package:pinput/pinput.dart';

import '../../../blocs/auth/forgot_password_cubit.dart';
import '../../../gen/assets.gen.dart';
import '../../../res/colors.dart';
import '../../../util/common.dart';
import '../../../util/routes.dart';
import '../../widget/base_button.dart';
import '../../widget/base_loading.dart';
import '../../widget/base_text_input.dart';
import '../../widget/custom_text_label.dart';
import '../../widget/widget.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ForgotPasswordCubit(),
        ),
        BlocProvider(
          create: (_) => VerifyOtpCubit(),
        )
      ],
      child: ForgotPasswordBody()
    );
  }
}

class ForgotPasswordBody extends StatefulWidget {
  const ForgotPasswordBody({super.key});

  @override
  State<ForgotPasswordBody> createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<ForgotPasswordBody> {
  final _keyEmail = GlobalKey<TextFieldState>();
  String _errorText = '';

  PinTheme get _defaultPinTheme => PinTheme(
    width: 50,
    height: 50,
    textStyle: const TextStyle(
      fontSize: 22,
      color: AppColors.base_pink,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: AppColors.base_pink),
    ),
  );

  void _showOtpDialog() {
    final pinController = TextEditingController();
    final verifyCubit = BlocProvider.of<VerifyOtpCubit>(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String err = '';
        return BlocProvider.value(
          value: verifyCubit,
          child: BlocConsumer<VerifyOtpCubit, BaseState>(
            listener: (_, state) {
              if (state is LoadedState<ForgotPasswordModel>) {
                Navigator.pop(context);
                Navigator.pushNamed(context, Routes.resetPasswordScreen, arguments: ForgotPasswordModel(
                  email: _keyEmail.currentState?.value,
                  tokenId: state.data.tokenId,
                ));
              } else if (state is ErrorState){
                setState(() {
                  err = state.data;
                });
              }
            },
            builder: (context, state) {
              final isLoading = state is LoadingState;
              return Stack(
                children: [
                  CustomDialog(
                    hasCloseButton: true,
                    content: Column(
                      children: [
                        const CustomTextLabel('Nhập mã OTP được gửi đến email của bạn để tiếp tục!'),
                        const SizedBox(height: 20,),
                        Pinput(
                          controller: pinController,
                          defaultPinTheme: _defaultPinTheme,
                          separatorBuilder: (index) => const SizedBox(width: 8),
                          hapticFeedbackType: HapticFeedbackType.lightImpact,
                          onCompleted: (pin) {
                            debugPrint('onCompleted: $pin');
                          },
                          onChanged: (value) {
                            if (_errorText.isNotEmpty) {
                              setState(() {
                                _errorText = '';
                              });
                            }
                            debugPrint('onChanged: $value');
                          },
                          cursor: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 9),
                                width: 22,
                                height: 1,
                                color: AppColors.base_pink,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20,),
                        if (err.isNotEmpty) CustomTextLabel(err, color: AppColors.colorError, fontStyle: FontStyle.italic,)
                      ],
                    ),
                    onSubmit: isLoading ? null : () {
                      if (pinController.text.isNotEmpty) {
                        Map<String, dynamic> body = {
                          "email": _keyEmail.currentState?.value,
                          "token": pinController.text
                        };
                        BlocProvider.of<VerifyOtpCubit>(context).verifyOtp(body);
                      }
                    },
                  ),
                  if (isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: BaseProgressIndicator(),
                      ),
                    ),
                ]
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Quên mật khẩu',
      colorBackground: AppColors.background_white,
      loadingWidget: CustomLoading<ForgotPasswordCubit>(),
      messageNotify: CustomSnackBar<ForgotPasswordCubit>(),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 40,),
            Assets.images.imgPassword.image(scale: 2.2),
            const SizedBox(height: 40,),
            CustomTextInput(
              key: _keyEmail,
              isRequired: true,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.white, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.white, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: "Nhập email để tiếp tục",
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
            BlocListener<ForgotPasswordCubit, BaseState>(
              listener: (_, state) {
                if (state is LoadedState<bool>) {
                  _showOtpDialog();
                }
              },
              child: const SizedBox.shrink(),
            )
          ],
        ),
      ),
      bottomBar: BottomAppBar(
        height: 70,
        color: AppColors.background_white,
        child: BaseButton(
          title: 'Tiếp tục',
          gradient: AppColors.base_gradient_1,
          borderRadius: 20,
          onTap: () {
            if (_keyEmail.currentState!.isValid == true) {
              Map<String, dynamic> body = {
                "email": _keyEmail.currentState?.value,
              };
              BlocProvider.of<ForgotPasswordCubit>(context).sendEmail(body);
            }
          },
        ),
      ),
    );
  }
}

