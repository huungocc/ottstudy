import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/ui/widget/common_widget.dart';

import '../../../blocs/base_bloc/base_state.dart';
import '../../../blocs/base_bloc/count_state.dart';
import '../../../blocs/count_cubit.dart';
import '../../../blocs/lesson/lesson_info_cubit.dart';
import '../../../blocs/registration/study_time_cubit.dart';
import '../../../data/models/lesson_model.dart';
import '../../../data/models/test_model.dart';
import '../../../res/colors.dart';
import '../../../util/common.dart';
import '../../../util/routes.dart';
import '../../widget/base_pdf_viewer.dart';

class PdfLessonScreen extends StatelessWidget {
  final LessonModel? arg;

  const PdfLessonScreen({Key? key, this.arg}) : super(key: key);

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
      child: PdfLessonBody(arg: arg),
    );
  }
}

class PdfLessonBody extends StatefulWidget {
  final LessonModel? arg;

  const PdfLessonBody({Key? key, this.arg}) : super(key: key);

  @override
  State<PdfLessonBody> createState() => _PdfLessonBodyState();
}

class _PdfLessonBodyState extends State<PdfLessonBody> {
  CountCubit? _countCubit;
  StudyTimeCubit? _studyTimeCubit;

  LessonModel lessonModel = LessonModel();

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
      colorBackground: AppColors.white,
      body: RefreshIndicator(
        color: AppColors.black,
        backgroundColor: AppColors.white,
        onRefresh: () async => getData(),
        child: BlocBuilder<LessonInfoCubit, BaseState>(
            builder: (_, state) {
              if (state is LoadedState<LessonModel>) {
                lessonModel = state.data;
                context.read<CountCubit>().startCount();
                return BasePDFViewer(
                  sourceType: PDFViewSource.network,
                  source: lessonModel.fileUrl ?? '',
                  isFromDatabase: true,
                );
              }
              return const SizedBox.shrink();
            }
        ),
      ),
      bottomBar: BottomAppBar(
        height: 100,
        color: AppColors.background_white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<CountCubit, CountState>(
              builder: (context, state) {
                return CommonWidget.courseInfo(iconData: Icons.timelapse_rounded, info: Common
                    .formatTimeGps(state.currentTime));
              },
            ),
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
    );
  }
}