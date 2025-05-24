import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/base_bloc/base.dart';
import 'package:ottstudy/data/models/test_model.dart';
import 'package:ottstudy/ui/widget/base_network_video_player.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/ui/widget/common_widget.dart';
import 'package:ottstudy/ui/widget/custom_text_label.dart';

import '../../../blocs/lesson/lesson_info_cubit.dart';
import '../../../data/models/lesson_model.dart';
import '../../../res/colors.dart';
import '../../../util/routes.dart';

class VideoLessonScreen extends StatelessWidget {
  final LessonModel? arg;

  const VideoLessonScreen({Key? key, this.arg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LessonInfoCubit(),
      child: VideoLessonBody(arg: arg,),
    );
  }
}

class VideoLessonBody extends StatefulWidget {
  final LessonModel? arg;

  const VideoLessonBody({Key? key, this.arg}) : super(key: key);

  @override
  State<VideoLessonBody> createState() => _VideoLessonBodyState();
}

class _VideoLessonBodyState extends State<VideoLessonBody> {
  @override
  void initState() {
    super.initState();
    if (widget.arg != null && widget.arg is LessonModel) {
      getData();
    }
  }

  void getData() {
    context.read<LessonInfoCubit>().lessonInfo({
      'id': widget.arg!.id
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      colorBackground: AppColors.background_white,
      body: RefreshIndicator(
        color: AppColors.black,
        backgroundColor: AppColors.white,
        onRefresh: () async => getData(),
        child: BlocBuilder<LessonInfoCubit, BaseState>(
          builder: (_, state) {
            if (state is LoadedState<LessonModel>) {
              final lessonModel = state.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseNetworkVideoPlayer(
                    videoUrl: lessonModel.fileUrl,
                    autoPlay: false,
                    isFromDatabase: true,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20,),
                        CustomTextLabel(lessonModel.lessonName ?? 'Không xác định', fontSize: 18, fontWeight:
                        FontWeight.bold,),
                        const SizedBox(height: 20,),
                        CommonWidget.doExerciseButton(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.quizScreen, arguments: TestModel(
                              id: lessonModel.testId
                            ));
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
              );
            }
            return const SizedBox.shrink();
          }
        ),
      )
    );
  }
}

