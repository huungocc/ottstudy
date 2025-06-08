import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/base_bloc/base.dart';
import 'package:ottstudy/blocs/base_bloc/count_state.dart';
import 'package:ottstudy/blocs/registration/study_time_cubit.dart';
import 'package:ottstudy/data/models/test_model.dart';
import 'package:ottstudy/ui/widget/base_network_video_player.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/ui/widget/common_widget.dart';
import 'package:ottstudy/ui/widget/custom_text_label.dart';

import '../../../blocs/count_cubit.dart';
import '../../../blocs/lesson/lesson_info_cubit.dart';
import '../../../data/models/lesson_model.dart';
import '../../../res/colors.dart';
import '../../../util/common.dart';
import '../../../util/routes.dart';

class VideoLessonScreen extends StatelessWidget {
  final LessonModel? arg;

  const VideoLessonScreen({Key? key, this.arg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LessonInfoCubit(),
        ),
        BlocProvider(
          create: (_) => StudyTimeCubit(),
        ),
        BlocProvider(
          create: (_) => CountCubit(),
        )
      ],
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
  CountCubit? _countCubit;
  StudyTimeCubit? _studyTimeCubit;

  @override
  void initState() {
    super.initState();
    if (widget.arg != null && widget.arg is LessonModel) {
      getData();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _countCubit = context.read<CountCubit>();
    _studyTimeCubit = context.read<StudyTimeCubit>();
  }

  @override
  void deactivate() {
    if (_countCubit != null && _studyTimeCubit != null) {
      if (!_countCubit!.isClosed && !_studyTimeCubit!.isClosed) {
        final studyTimeInSeconds = _countCubit!.state.currentTime;

        if (studyTimeInSeconds >= 60) {
          final studyTimeInMinutes = (studyTimeInSeconds / 60).round();
          _studyTimeCubit!.updateStudyTime({
            'time_to_add': studyTimeInMinutes
          });
        }

        _countCubit!.resetCount();
      }
    }

    super.deactivate();
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
              context.read<CountCubit>().startCount();
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20,),
                        CustomTextLabel(lessonModel.lessonName ?? 'Không xác định', fontSize: 18, fontWeight:
                        FontWeight.bold,),
                        const SizedBox(height: 10,),
                        BlocBuilder<CountCubit, CountState>(
                          builder: (context, state) {
                            return CommonWidget.courseInfo(iconData: Icons.timelapse_rounded, info: Common
                                .formatTimeGps(state.currentTime));
                          },
                        ),
                        const SizedBox(height: 15,),
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
                ],
              );
            }
            return const SizedBox.shrink();
          }
        ),
      ),
    );
  }
}

