import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../res/colors.dart';
import 'base_network_image.dart';
import 'widget.dart';

class CommonWidget {
  static Widget explorerCourseCard({String? url, String? courseName, String? teacherName, String? className,
    EdgeInsets? margin, GestureTapCallback? onTap
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
                url: url ?? '',
                width: 90,
                height: 90,
                borderRadius: 15,
              ),
            ),
            SizedBox(width: 15,),
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextLabel(courseName, fontSize: 16,),
                  SizedBox(height: 5,),
                  courseInfo(
                    iconData: Icons.person_2_rounded,
                    info: teacherName ?? ''
                  ),
                  SizedBox(height: 5,),
                  courseInfo(
                      iconData: Icons.menu_book_rounded,
                      info: className ?? ''
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  static Widget courseInfo_4() {
    List<Map<String, dynamic>> courseInfos = [
      {'icon': Icons.play_arrow_rounded, 'info': '12 bài học'},
      {'icon': Icons.person_2_rounded, 'info': '100 học sinh'},
      {'icon': Icons.menu_book_rounded, 'info': 'Môn toán'},
      {'icon': Icons.emoji_emotions, 'info': '100 lượt thích'},
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

  static Widget lessonInfo({GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        color: AppColors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextLabel('01', gradient: AppColors.base_gradient_2, fontWeight: FontWeight.bold, fontSize: 25,),
            SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextLabel('100 bài toán đầu tiên cộng trừ đơn giản giúp bé làm quen với môn toán'),
                  SizedBox(height: 10,),
                  courseInfo(iconData: Icons.play_arrow_rounded, info: 'Video')
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  static Widget examInfo({GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: AppColors.base_gradient_2
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
                  courseInfo(iconData: Icons.play_arrow_rounded, info: '60p', color: AppColors.white),
                  const SizedBox(height: 5,),
                  courseInfo(iconData: Icons.menu_book_rounded, info: 'Trắc nghiệm', color: AppColors.white)
                ],
              )
            )
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

  static Widget myCourseCard({required bool isFinished}) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        children: [
          CustomTextLabel('300 bài toán thiếu nhi dễ như ăn kẹo ai cũng làm được', fontWeight: FontWeight.bold,
            fontSize: 16, maxLines: 2,),
          SizedBox(height: 10,),
          isFinished
          ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: courseInfo(iconData: Icons.person_2_rounded, info: 'Nguyễn Văn A'),
          )
          : Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: 5/10,
                  minHeight: 5,
                  backgroundColor: AppColors.gray_border,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.base_blue),
                ),
              ),
              SizedBox(height: 10,),
              Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextLabel('5/10', fontWeight: FontWeight.bold,)
              ),
            ],
          ),
          SizedBox(height: 10,),
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
                child: Icon(isFinished ? Icons.check : Icons.play_arrow_rounded, size: 35, color: AppColors.white,),
              ),
            ),
          )
        ],
      ),
    );
  }

  static Widget adminCourseCard({String? url, String? courseName, int? studentNumber,
    EdgeInsets? margin, GestureTapCallback? onTap
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
                url: url ?? '',
                width: 90,
                height: 90,
                borderRadius: 15,
              ),
            ),
            SizedBox(width: 15,),
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextLabel(courseName, fontSize: 16,),
                  SizedBox(height: 5,),
                  courseInfo(
                      iconData: Icons.person_2_rounded,
                      info: '$studentNumber học sinh'
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  static Widget studentCard({String? url, String? studentName, String? studentId,
    EdgeInsets? margin, GestureTapCallback? onTap, bool? isFinished = false
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
            BaseNetworkImage(
              url: url ?? '',
              width: 70,
              height: 70,
              borderRadius: 15,
            ),
            SizedBox(width: 15,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextLabel(studentName ?? '', fontSize: 16,),
                  SizedBox(height: 5,),
                  courseInfo(
                      iconData: Icons.person_2_rounded,
                      info: studentId ?? ''
                  ),
                ],
              ),
            ),
            SizedBox(width: 15,),
            isFinished == true
            ? Column(
              children: [
                CustomTextLabel('Điểm'),
                SizedBox(height: 5,),
                CustomTextLabel(9.4, fontWeight: FontWeight.bold,)
              ],
            )
            : Column(
              children: [
                CustomTextLabel('Đang học'),
                SizedBox(height: 5,),
                CustomTextLabel('5/10', fontWeight: FontWeight.bold,)
              ],
            )
          ],
        ),
      ),
    );
  }
}
