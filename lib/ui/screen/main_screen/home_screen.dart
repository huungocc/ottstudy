import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/ui/widget/custom_text_label.dart';
import 'package:ottstudy/util/common.dart';

import '../../../blocs/navigation_tab_cubit.dart';
import '../../../gen/assets.gen.dart';
import '../../../res/colors.dart';
import '../../../util/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _todayStudyTime = 365;

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      customAppBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: AppColors.background_white,
        title: Container(
          margin: const EdgeInsets.symmetric(vertical: 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Assets.images.imgGirlHome.image(scale: 2.5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextLabel('Xin chào, Nguyễn Hữu Ngọc!', gradient: AppColors.base_gradient_4,
                    fontWeight:
                    FontWeight.bold, fontSize: 16,),
                  _todayStudyTime == null
                      ? CustomTextLabel('Bạn muốn học gì hôm nay?')
                      : CustomTextLabel('Hôm nay bạn đã học được ${Common.formatTimeGps(_todayStudyTime)}')
                ],
              )
            ],
          ),
        ),
      ),
      colorBackground: AppColors.background_white,
      body:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            explorerHomeCard(),
            SizedBox(height: 20,),
            Row(
              children: [
                Expanded(child: notificationCard()),
                Expanded(child: myCourseCard())
              ],
            ),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  CustomTextLabel('Tiếp tục học', fontWeight: FontWeight.bold,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget explorerHomeCard() {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<NavigationTabCubit>(context).changeIndex(1);
      },
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: AppColors.base_gradient_1,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Assets.images.icExplorerWhite.image(scale: 2),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextLabel('Bạn muốn cải thiện kiến thức\nKhám phá ngay.', fontWeight: FontWeight.bold, color:
                AppColors.white, fontSize: 16,),
                Icon(Icons.arrow_forward_rounded, size: 50, color: AppColors.white,)
              ],
            )
          ],
        )
      ),
    );
  }

  // Widget timeTodayCard() {
  //   return GestureDetector(
  //     onTap: () {
  //
  //     },
  //     child: Container(
  //       height: 120,
  //       width: double.infinity,
  //       padding: EdgeInsets.all(15),
  //       margin: EdgeInsets.only(left: 20, right: 10),
  //       decoration: BoxDecoration(
  //         gradient: AppColors.base_gradient_2,
  //         borderRadius: BorderRadius.circular(20.0),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           // CustomTextLabel('Hôm nay,\nBạn đã học được', fontWeight: FontWeight.bold, color:
  //           // AppColors.white, fontSize: 16),
  //           // CustomTextLabel('1h25p', fontWeight: FontWeight.bold, color:
  //           // AppColors.white, fontSize: 30,)
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget notificationCard() {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<NavigationTabCubit>(context).changeIndex(2);
      },
      child: Container(
        width: double.infinity,
        height: 120,
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(left: 20, right: 10),
        decoration: BoxDecoration(
          gradient: AppColors.base_gradient_2,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Assets.images.icClockWhite.image(scale: 2.2),
            CustomTextLabel('Kiểm tra hòm thư', fontWeight: FontWeight.bold, color:
            AppColors.white, fontSize: 16,)
          ],
        ),
      ),
    );
  }

  Widget myCourseCard() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.myCourseScreen);
      },
      child: Container(
        width: double.infinity,
        height: 120,
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(left: 10, right: 20),
        decoration: BoxDecoration(
          gradient: AppColors.base_gradient_2,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Assets.images.icBrainWhite.image(scale: 2.2),
            CustomTextLabel('Khóa học của tôi', fontWeight: FontWeight.bold, color:
            AppColors.white, fontSize: 16,)
          ],
        ),
      ),
    );
  }
}

