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
import '../../widget/base_loading.dart';
import '../../widget/base_screen.dart';
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

  void onEdit() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: PhosphorIcon(PhosphorIcons.info()),
                title: const CustomTextLabel(
                  'Cập nhật thông tin cá nhân',
                  fontWeight: FontWeight.bold,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, Routes.editAccountInfoScreen);
                },
              ),
              ListTile(
                leading: PhosphorIcon(PhosphorIcons.password()),
                title: const CustomTextLabel(
                  'Cập nhật mật khẩu',
                  fontWeight: FontWeight.bold,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, Routes.changePasswordScreen);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      hideAppBar: true,
      colorBackground: AppColors.background_white,
      loadingWidget: CustomLoading<UserInfoCubit>(),
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
            decoration: const BoxDecoration(
                gradient: AppColors.base_gradient_1
            ),
            child:Column(
              children: [
                Column(
                  children: [
                    SizedBox(height: 50,),
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
                          )
                      ),
                    ),
                    SizedBox(height: 10,),
                    CustomTextLabel(userModel?.fullName ?? 'Người dùng không xác định', fontWeight: FontWeight.w600,
                      fontSize:
                    16,
                      color:
                    AppColors
                        .white,),
                    SizedBox(height: 5,),
                    CustomTextLabel(userModel?.studentCode ?? 'Không xác định', color: AppColors.white,),
                    IconButton(
                      icon: PhosphorIcon(
                        PhosphorIcons.pencilSimpleLine(),
                        color: AppColors.white,
                      ),
                      onPressed: () {
                        onEdit();
                      },
                    ),
                  ],
                ),
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
                        Row(
                          children: [
                            Expanded(child: dashBoardCard(title: 'Tổng khóa học', value: '100')),
                            const SizedBox(width: 20,),
                            Expanded(child: dashBoardCard(title: 'Tổng giờ học', value: '100'))
                          ],
                        ),
                        const SizedBox(height: 20,),
                        const CustomTextLabel('Công cụ', fontWeight: FontWeight.bold,),
                        const SizedBox(height: 10,),
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
                        const SizedBox(height: 10,),
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
          onTap: () async {
            await SharedPreferenceUtil.clearData();
            Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (route) => false);
          },
        ),
      ),
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
          const SizedBox(height: 20,),
          CustomTextLabel(value, fontSize: 30, fontWeight: FontWeight.bold, gradient: AppColors.base_gradient_1,)
        ],
      ),
    );
  }
}

