import 'package:flutter/material.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/ui/widget/common_widget.dart';

import '../../../res/colors.dart';
import '../../widget/base_pdf_viewer.dart';

class PdfLessonScreen extends StatelessWidget {
  const PdfLessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PdfLessonBody();
  }
}

class PdfLessonBody extends StatefulWidget {
  const PdfLessonBody({super.key});

  @override
  State<PdfLessonBody> createState() => _PdfLessonBodyState();
}

class _PdfLessonBodyState extends State<PdfLessonBody> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Bài 01',
      colorBackground: AppColors.white,
      body: BasePDFViewer(
        sourceType: PDFViewSource.network,
        source: 'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
      ),
      bottomBar: BottomAppBar(
        height: 70,
        color: AppColors.background_white,
        child: CommonWidget.doExerciseButton(),
      ),
    );
  }
}

