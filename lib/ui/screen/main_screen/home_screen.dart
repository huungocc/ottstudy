import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/auth/user_info_cubit.dart';
import 'package:ottstudy/blocs/base_bloc/base.dart';
import 'package:ottstudy/blocs/rank/my_rank_cubit.dart';
import 'package:ottstudy/blocs/registration/my_registration_cubit.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/ui/widget/custom_text_label.dart';

import '../../../blocs/navigation_tab_cubit.dart';
import '../../../data/models/course_model.dart';
import '../../../data/models/user_model.dart';
import '../../../gen/assets.gen.dart';
import '../../../res/colors.dart';
import '../../../util/routes.dart';
import '../../widget/base_progress_indicator.dart';
import '../../widget/common_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MyRegistrationCubit(),
        ),
        BlocProvider(
          create: (_) => UserInfoCubit(),
        )
      ],
      child: HomeBody(),
    );
  }
}


class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    context.read<MyRegistrationCubit>().getMyRegistration({
      'final_test_passed': 'false'
    });
    context.read<UserInfoCubit>().getUserInfo(null);
  }

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
                  BlocBuilder<UserInfoCubit, BaseState>(
                    builder: (context, state) {
                      if (state is LoadedState<UserModel>) {
                        final UserModel model = state.data;
                        return CustomTextLabel('Xin chào, ${model.fullName}', gradient: AppColors.base_gradient_4,
                          fontWeight:
                          FontWeight.bold, fontSize: 16,);
                      }
                      return const CustomTextLabel('Xin chào bạn nhỏ!', gradient: AppColors.base_gradient_4,
                        fontWeight:
                        FontWeight.bold, fontSize: 16,);
                    },
                  ),
                    const CustomTextLabel('Bạn muốn học gì hôm nay?')
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
            const SizedBox(height: 20,),
            Row(
              children: [
                Expanded(child: notificationCard()),
                Expanded(child: myCourseCard())
              ],
            ),
            const SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: CustomTextLabel('Tiếp tục học', fontWeight: FontWeight.bold,)
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    height: 160,
                    child: BlocBuilder<MyRegistrationCubit, BaseState>(
                      builder: (context, state) {
                        if (state is LoadingState) {
                          return const Center(
                            child: BaseProgressIndicator(color: AppColors.black,),
                          );
                        }
                        if (state is LoadedState<List<CourseModel>>) {
                          final List<CourseModel> courseList = state.data;
                          if (courseList.isNotEmpty) {
                            return ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: courseList.length,
                              itemBuilder: (context, index) {
                                final course = courseList[index];
                                return CommonWidget.myCourseCard(
                                  course,
                                  width: 170,
                                  onTap: () {
                                    Navigator.pushNamed(context, Routes.courseInfoScreen, arguments: course);
                                  },
                                );
                              },
                              separatorBuilder: (context, index) => const SizedBox(width: 10),
                            );
                          } else {
                            return const Center(
                              child: CustomTextLabel('Chưa có khóa học nào'),
                            );
                          }
                        }
                        return const Center(
                          child: CustomTextLabel('Đã có lỗi xảy ra'),
                        );
                      }
                    ),
                  )
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
            Assets.images.icChartWhite.image(scale: 2),
            CustomTextLabel('Thứ hạng của tôi', fontWeight: FontWeight.bold, color:
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

