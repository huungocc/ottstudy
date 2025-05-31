import 'package:flutter/material.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/ui/widget/common_widget.dart';

import '../../../res/colors.dart';
import '../../widget/base_text_input.dart';
import '../../widget/widget.dart';

class StudentManageScreen extends StatefulWidget {
  const StudentManageScreen({super.key});

  @override
  State<StudentManageScreen> createState() => _StudentManageScreenState();
}

class _StudentManageScreenState extends State<StudentManageScreen> {
  void _onStudentInfo() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => studentInfo(isApproving: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      hideAppBar: true,
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
          // CommonWidget.studentCard(
          //   margin: EdgeInsets.symmetric(horizontal: 20),
          //   url: 'https://toquoc.mediacdn.vn/280518851207290880/2022/12/15/p0dnxrcv-16710704848821827978943.jpg',
          //   studentName: 'Nguyễn Hữu Ngọc',
          //   studentId: 'HS102',
          //   isFinished: true,
          //   onTap: () {
          //     _onStudentInfo();
          //   }
          // )
        ],
      ),
    );
  }

  Widget studentInfo({required bool isApproving}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: const BoxDecoration(
        color: AppColors.background_white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BaseNetworkImage(
            url: 'https://toquoc.mediacdn.vn/280518851207290880/2022/12/15/p0dnxrcv-16710704848821827978943.jpg',
            height: 100,
            width: 100,
            boxFit: BoxFit.cover,
            borderRadius: 50,
          ),
          SizedBox(height: 20,),
          studentInfoText(
            title: 'Mã học sinh',
            value: 'HS102',
          ),
          studentInfoText(
            title: 'Họ và tên',
            value: 'Nguyễn Hữu Ngọc',
          ),
          studentInfoText(
            title: 'Ngày sinh',
            value: '03/10/2003',
          ),
          studentInfoText(
            title: 'Số điện thoại',
            value: '0362335820',
          ),
          studentInfoText(
            title: 'Lớp',
            value: '5',
          ),
          Visibility(
            visible: isApproving,
            child: BaseButton(
              title: 'Phê duyệt',
              borderRadius: 20,
            ),
          )
        ],
      ),
    );
  }

  Widget studentInfoText({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomTextLabel('$title:', fontWeight: FontWeight.bold,),
          SizedBox(width: 20,),
          CustomTextLabel(value)
        ],
      ),
    );
  }
}
