import 'package:flutter/material.dart';
import 'package:ottstudy/res/colors.dart';
import 'package:ottstudy/ui/screen/admin/registration_screen.dart';
import 'package:ottstudy/ui/screen/admin/student_manage_screen.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/ui/widget/custom_tab_bar.dart';

import '../../../data/models/course_model.dart';
import 'admin_course_info_screen.dart';

class AdminCourseManageScreen extends StatelessWidget {
  final CourseModel? arg;

  const AdminCourseManageScreen({Key? key, this.arg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<CustomTab> tabs = [
      const CustomTab(label: 'Thông tin'),
      const CustomTab(label: 'Học sinh'),
      const CustomTab(label: 'Đơn đăng ký'),
    ];

    final List<Widget> views = [
      AdminCourseInfoScreen(arg: arg,),
      const StudentManageScreen(),
      RegistrationScreen(arg: arg),
    ];

    return BaseScreen(
      title: 'Thông tin khóa học',
      colorBackground: AppColors.background_white,
      body: CustomTabBar(
        tabs: tabs,
        views: views,
        backgroundColor: AppColors.white,
        selectedLabelColor: AppColors.black,
        unselectedLabelColor: AppColors.gray,
        indicatorColor: AppColors.black,
        indicatorWeight: 3.0,
      ),
    );
  }
}
