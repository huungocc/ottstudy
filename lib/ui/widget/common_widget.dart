import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ottstudy/data/models/registration_model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../data/models/course_model.dart';
import '../../data/models/lesson_model.dart';
import '../../data/models/question_model.dart';
import '../../data/models/test_model.dart';
import '../../data/models/user_model.dart';
import '../../res/colors.dart';
import '../../util/common.dart';
import '../../util/constants.dart';
import 'base_network_image.dart';
import 'widget.dart';

class CommonWidget {
  static Widget explorerCourseCard(CourseModel model, {EdgeInsets? margin, GestureTapCallback? onTap
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        margin: margin,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: BaseNetworkImage(
                url: model.courseImage ?? '',
                width: 90,
                height: 90,
                borderRadius: 15,
                isFromDatabase: true,
              ),
            ),
            const SizedBox(width: 15,),
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextLabel(model.courseName, fontSize: 16,),
                  const SizedBox(height: 10),
                  courseInfo(
                    iconData: Icons.person_2_rounded,
                    info: model.teacher ?? ''
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  static Widget courseInfo_2({int? studentCount, String? subjectId}) {
    List<Map<String, dynamic>> courseInfos = [
      {'icon': Icons.person_2_rounded, 'info': '${studentCount ?? '0'} học sinh'},
      {'icon': Icons.menu_book_rounded, 'info': 'Môn ${Constants.getSubjectNameById(subjectId ?? '')}'},
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 0,
        childAspectRatio: 5,
      ),
      itemCount: courseInfos.length,
      itemBuilder: (context, index) {
        return courseInfo(
          iconData: courseInfos[index]['icon'] as IconData,
          info: courseInfos[index]['info'] as String,
        );
      },
    );
  }

  static Widget courseInfo({required IconData iconData, required String info, Color? color}) {
    return Row(
      children: [
        Icon(iconData, size: 18, color: color ?? AppColors.gray_title),
        SizedBox(width: 10,),
        CustomTextLabel(info, fontSize: 12, color: color ?? AppColors.gray_title)
      ],
    );
  }

  static Widget lessonInfo(LessonModel model, {int? order, GestureTapCallback? onTap, double? borderRadius}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextLabel(
              order != null ? order < 10 ? '0$order' : '$order' : '',
              gradient: AppColors.base_gradient_2,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
            SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextLabel(model.lessonName ?? ''),
                  SizedBox(height: 10,),
                  courseInfo(iconData: Icons.play_arrow_rounded, info: model.fileType ?? '')
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  static Widget examInfo(TestModel model, {GestureTapCallback? onTap, double? borderRadius, double? finalTestScore = 0
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: AppColors.base_gradient_2,
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextLabel('KT', color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 25,),
            SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomTextLabel('Bài kiểm tra kết thúc khóa học', color: AppColors.white,),
                  const SizedBox(height: 10,),
                  courseInfo(iconData: Icons.play_arrow_rounded, info: '${model.time} p', color: AppColors.white),
                ],
              )
            ),
            SizedBox(width: 10,),
            if (finalTestScore! > 0)
            CustomTextLabel(
              '${Common.doubleWithoutDecimalToInt(finalTestScore)} đ',
              color: AppColors.white,
              fontSize: 20,
            ),
          ],
        ),
      ),
    );
  }

  static Widget notificationInfo() {
    return GestureDetector(
      child: Container(
        color: AppColors.white,
        padding: EdgeInsets.all(15),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BaseNetworkImage(
              url: 'https://i.ytimg.com/vi/_UR-l3QI2nE/maxresdefault.jpg',
              width: 40,
              height: 40,
              borderRadius: 10,
            ),
            SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextLabel('300 bài toán thiếu nhi dễ như ăn kẹo'),
                  SizedBox(height: 10,),
                  CustomTextLabel('Bài kiểm tra kết thúc khóa học đã được chấm. Nhấn để kiểm tra!', color: AppColors
                      .gray_title, fontSize: 12,),
                  SizedBox(height: 10,),
                  CustomTextLabel('14:23 23-02-25', color: AppColors.gray_title, fontSize: 12,),
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  static Widget doExerciseButton({GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: AppColors.base_gradient_2,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextLabel('Làm bài tập để kết thúc bài học', color: AppColors.white,),
            Icon(Icons.arrow_forward_rounded, color: AppColors.white,)
          ],
        ),
      ),
    );
  }

  static Widget scoreCard(int score) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: AppColors.base_gradient_2,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomTextLabel('Tổng điểm:', color: AppColors.white,),
          CustomTextLabel(score, color: AppColors.white, fontWeight: FontWeight.bold,),
        ],
      ),
    );
  }

  static Widget myCourseCard(CourseModel model, {GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextLabel(model.courseName, fontWeight: FontWeight.bold,
              fontSize: 16, maxLines: 2,),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: courseInfo(iconData: Icons.person_2_rounded, info: model.teacher ?? 'N/A'),
            ),
            const SizedBox(height: 5,),
            Align(
              alignment: Alignment.centerRight,
              child: ClipOval(
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    gradient: AppColors.base_gradient_2
                  ),
                  child: Icon(model.finalTestPassed == true ? Icons.check : Icons.play_arrow_rounded, size: 35, color:
                  AppColors.white,),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static Widget adminCourseCard(CourseModel model, {EdgeInsets? margin, GestureTapCallback? onTap
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        margin: margin,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: BaseNetworkImage(
                url: model.courseImage ?? '',
                width: 90,
                height: 90,
                borderRadius: 15,
                isFromDatabase: true,
              ),
            ),
            SizedBox(width: 15,),
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextLabel(model.courseName ?? '', fontSize: 16,),
                  SizedBox(height: 5,),
                  courseInfo(
                      iconData: Icons.person_2_rounded,
                      info: model.studentCount != null ? '${model.studentCount} học sinh' : '0 học sinh',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  static Widget studentCard(RegistrationModel model, {EdgeInsets? margin, GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        margin: margin,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: [
            BaseNetworkImage(
              url: model.studentAvatar ?? '',
              isFromDatabase: true,
              width: 70,
              height: 70,
              borderRadius: 15,
            ),
            SizedBox(width: 15,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextLabel(model.studentName ?? '', fontSize: 16,),
                  SizedBox(height: 5,),
                  courseInfo(
                      iconData: Icons.person_2_rounded,
                      info: model.studentCode ?? ''
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15,),
            model.finalTestScore != null
            ? CustomTextLabel('${Common.doubleWithoutDecimalToInt(model.finalTestScore)} đ', fontSize: 18,
              fontWeight: FontWeight.bold,)
            : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  static Widget addButton({String? title, GestureTapCallback? onTap}) {
    return BaseButton(
      onTap: onTap,
      gradient: AppColors.base_gradient_2,
      borderRadius: 20,
      width: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomTextLabel(
            title,
            color: AppColors.white,
          ),
          const Icon(Icons.add_rounded, color: Colors.white),
        ],
      ),
    );
  }

  static Widget questionInfo(QuestionModel questionModel, {int? order, GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextLabel(order != null ? order < 10 ? '0$order' : '$order' : '', gradient: AppColors.base_gradient_2, fontWeight: FontWeight.bold, fontSize: 25,),
            SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseNetworkImage(
                    url: questionModel.questionImage,
                    isFromDatabase: true,
                  ),
                  SizedBox(height: 10,),
                  CustomTextLabel('Đáp án: ${questionModel.answer}', fontSize: 12, color: AppColors.gray_title)
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  static Widget studentInfo(UserModel userModel, {
    required bool isApproving,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BaseNetworkImage(
          url: userModel.avatarUrl ?? '',
          isFromDatabase: true,
          height: 100,
          width: 100,
          boxFit: BoxFit.cover,
          borderRadius: 50,
        ),
        SizedBox(height: 20),
        studentInfoText(
          title: 'Mã học sinh',
          value: userModel.studentCode ?? 'N/A',
        ),
        studentInfoText(
          title: 'Họ và tên',
          value: userModel.fullName ?? 'N/A',
        ),
        studentInfoText(
          title: 'Ngày sinh',
          value: userModel.birthDate ?? 'N/A',
        ),
        studentInfoText(
          title: 'Số điện thoại',
          value: userModel.phoneNumber ?? 'N/A',
        ),
        studentInfoText(
          title: 'Lớp',
          value: userModel.grade.toString(),
        ),
        Visibility(
          visible: isApproving,
          child: BaseButton(
            title: 'Phê duyệt',
            borderRadius: 20,
            onTap: () {

            },
          ),
        )
      ],
    );
  }

  static Widget studentInfoText({required String title, required String value}) {
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

  static Widget testInfo(TestModel testModel) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          studentInfoText(
            title: 'Id',
            value: testModel.id ?? '',
          ),
          studentInfoText(
            title: 'Thời gian',
            value: '${testModel.time} p',
          ),
          studentInfoText(
            title: 'Điểm yêu cầu',
            value: testModel.minimumScore.toString(),
          ),
        ],
      ),
    );
  }
}
