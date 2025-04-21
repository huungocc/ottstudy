import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/ui/widget/base_network_image.dart';
import 'package:ottstudy/ui/widget/base_pdf_viewer.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../blocs/base_bloc/timer_state.dart';
import '../../../blocs/timer_cubit.dart';
import '../../../res/colors.dart';
import '../../../util/common.dart';
import '../../widget/base_button.dart';
import '../../widget/base_screen.dart';
import '../../widget/custom_text_label.dart';

class EssayQuestion {
  final String questionUrl;

  EssayQuestion({
    required this.questionUrl,
  });
}

class EssayScreen extends StatelessWidget {
  const EssayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerCubit(initialTime: 36)..startTimer(),
      child: EssayBody(),
    );
  }
}

class EssayBody extends StatefulWidget {
  const EssayBody({super.key});

  @override
  State<EssayBody> createState() => _EssayBodyState();
}

class _EssayBodyState extends State<EssayBody> {
  File? _selectedPDFFile;

  Future<void> _pickPDFFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _selectedPDFFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Bài kiểm tra 02',
      colorBackground: AppColors.background_white,
      rightWidgets: [
        IconButton(
          icon: PhosphorIcon(
            PhosphorIcons.calculator(),
            color: AppColors.black,
          ),
          onPressed: () {
            Common.showCalculator(context);
          },
        )
      ],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            questionContent(),
            const SizedBox(height: 20),
            answerContent(),
            BlocListener<TimerCubit, TimerState>(
              listenWhen: (previous, current) => !previous.isTimeUp && current.isTimeUp,
              listener: (context, state) {
                if (state.isTimeUp) {
                  //Todo: when time up
                }
              },
              child: const SizedBox.shrink(),
            )
          ],
        ),
      ),
      bottomBar: BottomAppBar(
        color: AppColors.white,
        height: 120,
        child: bottomAppBar(),
      ),
    );
  }

  Widget questionContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextLabel(
            'Đề bài',
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 10,),
          BaseNetworkImage(
            url: 'https://img.loigiaihay.com/picture/2024/0201/20_22.png',
          ),
        ],
      ),
    );
  }

  Widget answerContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextLabel(
                'Bài giải',
                fontWeight: FontWeight.bold,
              ),
              BaseButton(
                onTap: () {
                  _pickPDFFile();
                },
                borderRadius: 20,
                child: Row(
                  children: [
                    CustomTextLabel('Tải file PDF', color: AppColors.white,),
                    SizedBox(width: 20,),
                    PhosphorIcon(
                      PhosphorIcons.filePdf(),
                      color: AppColors.white,
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 15,),
          _selectedPDFFile == null
          ? const Center(
            child: CustomTextLabel('Chưa có file PDF', fontStyle: FontStyle.italic,),
          )
          : SizedBox(
            height: 500,
            child: BasePDFViewer(
              sourceType: PDFViewSource.file,
              source: _selectedPDFFile!.path,
            ),
          )
        ],
      ),
    );
  }

  Widget bottomAppBar() {
    return BlocBuilder<TimerCubit, TimerState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextLabel(
              'Thời gian còn lại: ${Common.formatTimeGps(state.timeLeft)}',
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: state.timeLeft / state.totalTime,
                      minHeight: 48,
                      backgroundColor: AppColors.gray_border,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.base_blue),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: BaseButton(
                    onTap: () {},
                    gradient: AppColors.base_gradient_2,
                    borderRadius: 20,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextLabel(
                          'Nộp bài',
                          color: AppColors.white,
                        ),
                        Icon(Icons.arrow_forward_rounded, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
