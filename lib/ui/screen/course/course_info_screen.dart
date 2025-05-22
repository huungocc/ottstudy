import 'package:flutter/material.dart';
import 'package:ottstudy/ui/widget/base_button.dart';
import 'package:ottstudy/ui/widget/base_network_image.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/ui/widget/common_widget.dart';
import 'package:ottstudy/ui/widget/custom_text_label.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../res/colors.dart';
import '../../../util/routes.dart';

class CourseInfoScreen extends StatelessWidget {
  const CourseInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CourseInfoBody();
  }
}

class CourseInfoBody extends StatefulWidget {
  const CourseInfoBody({super.key});

  @override
  State<CourseInfoBody> createState() => _CourseInfoBodyState();
}

class _CourseInfoBodyState extends State<CourseInfoBody> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Thông tin khóa học',
      colorBackground: AppColors.background_white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            BaseNetworkImage(
              url: 'https://i.ytimg.com/vi/_UR-l3QI2nE/maxresdefault.jpg',
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(radius: 18,),
                      SizedBox(width: 15,),
                      CustomTextLabel('Nguyễn Văn A')
                    ],
                  ),
                  const SizedBox(height: 10,),
                  CustomTextLabel('300 bài toán thiếu nhi dễ như ăn kẹo ai cũng làm được', fontSize: 18, fontWeight:
                  FontWeight.bold,),
                  const SizedBox(height: 10,),
                  CommonWidget.courseInfo_4(),
                  const SizedBox(height: 10,),
                  CustomTextLabel('Bộ tài liệu hơn 300 bài toán lớp 1, bao gồm tất cả các dạng toán cơ bản và nâng cao '
                      'được thầy cô biên soạn nhằm giúp các em ôn tập kiến thức cũ để chuẩn bị tốt nhất cho việc chinh phục kiến thức mới ở lớp 2. Các bài tập bám sát chương trình học, có kèm đáp án giúp ba mẹ và các bé thuận tiện trong việc đối chiếu kết quả. '),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            // CommonWidget.lessonInfo(
            //   onTap: (){
            //     Navigator.pushNamed(context, Routes.videoLessonScreen);
            //     //Navigator.pushNamed(context, Routes.pdfLessonScreen);
            //   }
            // ),
            CommonWidget.examInfo(
              onTap: () {
                Navigator.pushNamed(context, Routes.quizScreen);
                //Navigator.pushNamed(context, Routes.essayScreen);
              }
            )
          ],
        ),
      ),
      bottomBar: BottomAppBar(
        color: AppColors.background_white,
        child: Row(
          children: [
            const Expanded(
              child: BaseButton(
                title: 'Đăng ký học',
                borderRadius: 20,
              ),
            ),
            const SizedBox(width: 10,),
            BaseButton(
              width: 50,
              child: Icon(PhosphorIcons.heart(), color: AppColors.base_pink,),
              backgroundColor: AppColors.white,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.base_pink,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            )
          ],
        ),
      ),
    );
  }
}

