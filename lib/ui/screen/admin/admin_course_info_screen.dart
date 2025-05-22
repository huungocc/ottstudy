import 'package:flutter/material.dart';
import 'package:ottstudy/res/colors.dart';
import 'package:ottstudy/ui/screen/admin/registration_screen.dart';
import 'package:ottstudy/ui/screen/admin/student_manage_screen.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/ui/widget/custom_tab_bar.dart';

import 'admin_course_edit_screen.dart';

class AdminCourseInfoScreen extends StatelessWidget {
  const AdminCourseInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CustomTab> tabs = [
      const CustomTab(label: 'Thông tin'),
      const CustomTab(label: 'Học sinh'),
      const CustomTab(label: 'Đơn đăng ký'),
    ];

    final List<Widget> views = [
      const AdminCourseEditScreen(),
      const StudentManageScreen(),
      const RegistrationScreen(),
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
