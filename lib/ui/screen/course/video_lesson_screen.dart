import 'package:flutter/material.dart';
import 'package:ottstudy/ui/widget/base_network_video_player.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/ui/widget/common_widget.dart';
import 'package:ottstudy/ui/widget/custom_text_label.dart';

import '../../../res/colors.dart';
import '../../../util/routes.dart';

class VideoLessonScreen extends StatelessWidget {
  const VideoLessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VideoLessonBody();
  }
}

class VideoLessonBody extends StatefulWidget {
  const VideoLessonBody({super.key});

  @override
  State<VideoLessonBody> createState() => _VideoLessonBodyState();
}

class _VideoLessonBodyState extends State<VideoLessonBody> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Bài 01',
      colorBackground: AppColors.background_white,
      body: Column(
        children: [
          BaseNetworkVideoPlayer(
            videoUrl: 'http://192.168.1.199:8080/thor.mp4',
            autoPlay: true,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20,),
                CustomTextLabel('100 bài toán cộng trừ đơn giản giúp bé làm quen với môn toán', fontSize: 18, fontWeight:
                FontWeight.bold,),
                const SizedBox(height: 20,),
                CommonWidget.doExerciseButton(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.quizScreen);
                  }
                ),
              ],
            ),
          ),
          const SizedBox(height: 40,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextLabel('Tiếp theo', fontWeight: FontWeight.bold,)
              ),
              const SizedBox(height: 10,),
              //CommonWidget.lessonInfo(),
            ],
          ),
        ],
      ),
    );
  }
}

