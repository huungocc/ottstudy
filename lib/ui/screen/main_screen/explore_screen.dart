import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/course/list_course_cubit.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/ui/widget/base_text_input.dart';
import 'package:ottstudy/ui/widget/common_widget.dart';
import 'package:ottstudy/ui/widget/custom_selector.dart';
import 'package:ottstudy/ui/widget/custom_text_label.dart';

import '../../../gen/assets.gen.dart';
import '../../../res/colors.dart';
import '../../../util/routes.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListCourseCubit(),
      child: ExploreBody(),
    );
  }
}


class ExploreBody extends StatefulWidget {
  const ExploreBody({super.key});

  @override
  State<ExploreBody> createState() => _ExploreBodyState();
}

class _ExploreBodyState extends State<ExploreBody> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      hiddenIconBack: true,
      colorBackground: AppColors.background_white,
      colorAppBar: AppColors.background_white,
      title: const Align(
        alignment: Alignment.centerLeft,
        child: CustomTextLabel(
          'Khám phá',
          gradient: AppColors.base_gradient_1,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      rightWidgets: [Assets.images.icExplorer.image(), SizedBox(width: 20,)],
      body: Column(
        children: [
          SizedBox(height: 20,),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: CustomTextInput(
                  margin: EdgeInsets.only(left: 20, right: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.white, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.white, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Tìm kiếm',
                  suffixIcon: Icon(Icons.search_rounded),
                ),
              ),
              Flexible(
                flex: 1,
                child: CustomTextInput(
                  margin: EdgeInsets.only(right: 20),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.white, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.white, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Lớp',
                  isDropdownTF: true,
                  suffixIconMargin: 0,
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          CustomSelector(
            items: ['Toán', 'Tiếng Việt', 'Tiếng Anh', 'Lịch sử', 'Địa lý'],
            onTap: (index) {

            },
          ),
          SizedBox(height: 20,),
          CommonWidget.explorerCourseCard(
            margin: EdgeInsets.symmetric(horizontal: 20),
            url: 'https://i.ytimg.com/vi/_UR-l3QI2nE/maxresdefault.jpg',
            courseName: '300 bài toán thiếu nhi dễ như ăn kẹo',
            teacherName: 'Nguyễn Văn A',
            className: 'Lớp 1',
            onTap: () {
              Navigator.pushNamed(context, Routes.courseInfoScreen);
            }
          )
        ],
      ),
    );
  }
}
