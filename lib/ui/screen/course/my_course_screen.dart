import 'package:flutter/material.dart';
import 'package:ottstudy/ui/widget/common_widget.dart';

import '../../../res/colors.dart';
import '../../widget/base_screen.dart';
import '../../widget/base_text_input.dart';

class MyCourseScreen extends StatelessWidget {
  const MyCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyCourseBody();
  }
}

class MyCourseBody extends StatefulWidget {
  const MyCourseBody({super.key});

  @override
  State<MyCourseBody> createState() => _MyCourseBodyState();
}

class _MyCourseBodyState extends State<MyCourseBody> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Khóa học của tôi',
      colorBackground: AppColors.background_white,
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
                  // hintText: 'Lớp',
                  isDropdownTF: true,
                  suffixIconMargin: 0,
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          CommonWidget.myCourseCard(isFinished: false),
          CommonWidget.myCourseCard(isFinished: true)
        ],
      ),
    );
  }
}

