import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/ui/widget/common_widget.dart';

import '../../../blocs/base_bloc/base_state.dart';
import '../../../blocs/lesson/lesson_info_cubit.dart';
import '../../../data/models/lesson_model.dart';
import '../../../res/colors.dart';
import '../../widget/base_pdf_viewer.dart';

class PdfLessonScreen extends StatelessWidget {
  final LessonModel? arg;

  const PdfLessonScreen({Key? key, this.arg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LessonInfoCubit(),
      child: PdfLessonScreen(arg: arg,),
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
      colorBackground: AppColors.white,
      body: BlocBuilder<LessonInfoCubit, BaseState>(
        builder: (_, state) {
          if (state is LoadedState<LessonModel>) {
            final lessonModel = state.data;
            return BasePDFViewer(
              sourceType: PDFViewSource.network,
              source: lessonModel.fileUrl ?? '',
              isFromDatabase: true,
            );
          }
          return const SizedBox.shrink();
        }
      ),
      bottomBar: BottomAppBar(
        height: 70,
        color: AppColors.background_white,
        child: CommonWidget.doExerciseButton(),
      ),
    );
  }
}

