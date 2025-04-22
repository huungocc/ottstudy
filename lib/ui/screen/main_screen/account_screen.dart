import 'package:flutter/material.dart';
import 'package:ottstudy/ui/screen/tool/calculator_screen.dart';
import 'package:ottstudy/ui/widget/base_button.dart';
import 'package:ottstudy/ui/widget/base_network_image.dart';
import 'package:ottstudy/ui/widget/custom_text_label.dart';
import 'package:ottstudy/util/shared_preference.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../res/colors.dart';
import '../../../util/common.dart';
import '../../../util/routes.dart';
import '../../widget/base_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  void  onEdit() async {
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
      body: Container(
        decoration: const BoxDecoration(
            gradient: AppColors.base_gradient_1
        ),
        child:Column(
          children: [
            Column(
              children: [
                SizedBox(height: 30,),
                BaseNetworkImage(
                  url: 'https://toquoc.mediacdn.vn/280518851207290880/2022/12/15/p0dnxrcv-16710704848821827978943.jpg',
                  height: 80,
                  width: 80,
                  boxFit: BoxFit.cover,
                  borderRadius: 40,
                ),
                SizedBox(height: 10,),
                CustomTextLabel('Nguyễn Hữu Ngọc', fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.white,),
                SizedBox(height: 5,),
                CustomTextLabel('HS102', color: AppColors.white,),
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

