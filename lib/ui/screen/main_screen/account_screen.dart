import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/ui/widget/base_button.dart';
import 'package:ottstudy/ui/widget/base_network_image.dart';
import 'package:ottstudy/ui/widget/custom_text_label.dart';
import 'package:ottstudy/util/shared_preference.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../blocs/auth/user_info_cubit.dart';
import '../../../blocs/base_bloc/base_state.dart';
import '../../../data/models/user_model.dart';
import '../../../res/colors.dart';
import '../../../util/common.dart';
import '../../../util/routes.dart';
import '../../widget/base_progress_indicator.dart';
import '../../widget/base_screen.dart';
import '../../widget/custom_dialog.dart';
import '../../widget/custom_snack_bar.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserInfoCubit(),
      child: AccountBody(),
    );
  }
}

class AccountBody extends StatefulWidget {
  const AccountBody({super.key});

  @override
  State<AccountBody> createState() => _AccountBodyState();
}

class _AccountBodyState extends State<AccountBody> {
  String? imageUrl;
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    context.read<UserInfoCubit>().getUserInfo(null);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      hideAppBar: true,
      colorBackground: AppColors.background_white,
      messageNotify: CustomSnackBar<UserInfoCubit>(),
      body: BlocConsumer<UserInfoCubit, BaseState>(
        listener: (context, state) {
          if (state is LoadedState<UserModel>) {
            setState(() {
              userModel = state.data;
              imageUrl = userModel?.avatarUrl;
            });
          }
        },
        builder: (context, state) {
          return Container(
            decoration: const BoxDecoration(gradient: AppColors.base_gradient_1),
            child: Column(
              children: [
                _buildUserInfoSection(state),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.background_white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const CustomTextLabel(
                          'Cài đặt',
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BaseButton(
                          borderRadius: 20,
                          backgroundColor: AppColors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomTextLabel('Thông tin cá nhân'),
                              PhosphorIcon(
                                PhosphorIcons.user(),
                              )
                            ],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, Routes.editAccountInfoScreen);
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BaseButton(
                          borderRadius: 20,
                          backgroundColor: AppColors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomTextLabel('Đổi mật khẩu'),
                              PhosphorIcon(
                                PhosphorIcons.password(),
                              )
                            ],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, Routes.changePasswordScreen);
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        const CustomTextLabel(
                          'Công cụ',
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BaseButton(
                          borderRadius: 20,
                          backgroundColor: AppColors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomTextLabel('Máy tính cầm tay'),
                              PhosphorIcon(
                                PhosphorIcons.calculator(),
                              )
                            ],
                          ),
                          onTap: () {
                            Common.showCalculator(context);
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BaseButton(
                          borderRadius: 20,
                          backgroundColor: AppColors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomTextLabel('Hỏi đáp với Chat Bot'),
                              PhosphorIcon(
                                PhosphorIcons.openAiLogo(),
                              )
                            ],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, Routes.chatBotScreen);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomBar: BottomAppBar(
        color: AppColors.background_white,
        child: BaseButton(
          title: 'Đăng xuất',
          borderColor: AppColors.base_pink,
          backgroundColor: AppColors.white,
          borderRadius: 20,
          titleColor: AppColors.base_pink,
          onTap: () {
            _showLogoutDialog();
          },
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(
          content: const CustomTextLabel('Bạn có chắc muốn đăng xuất?', fontSize: 16,),
          titleSubmit: 'OK',
          onSubmit: () async {
            await SharedPreferenceUtil.clearData();
            Navigator.of(context).pop();
            Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (route) => false);
          },
          hasCloseButton: true,
        );
      },
    );
  }

  Widget _buildUserInfoSection(BaseState state) {
    return Column(
      children: [
        const SizedBox(height: 50),
        if (state is LoadingState) ...[
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.gray.withOpacity(0.3),
            ),
            child: const Center(
              child: BaseProgressIndicator(
                color: AppColors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Loading cho tên
          Container(
            width: 150,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.gray.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: 100,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.gray.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ] else ...[
          SizedBox(
            width: 80,
            height: 80,
            child: ClipOval(
              child: BaseNetworkImage(
                url: imageUrl,
                width: 80,
                height: 80,
                boxFit: BoxFit.cover,
                borderRadius: 100,
                isFromDatabase: true,
                errorBuilder: Container(
                  color: AppColors.gray,
                  child: PhosphorIcon(
                    size: 40,
                    PhosphorIcons.user(),
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          CustomTextLabel(
            userModel?.fullName ?? 'Người dùng không xác định',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColors.white,
          ),
          const SizedBox(height: 5),
          CustomTextLabel(
            userModel?.studentCode ?? 'Không xác định',
            color: AppColors.white,
          ),
        ],
        const SizedBox(height: 20),
      ],
    );
  }

  Widget dashBoardCard({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextLabel(title),
          const SizedBox(
            height: 20,
          ),
          CustomTextLabel(
            value,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            gradient: AppColors.base_gradient_1,
          )
        ],
      ),
    );
  }
}