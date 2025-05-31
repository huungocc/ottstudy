import 'package:flutter/material.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/ui/widget/common_widget.dart';
import '../../../gen/assets.gen.dart';

import '../../../res/colors.dart';
import '../../widget/custom_text_label.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      hiddenIconBack: true,
      colorBackground: AppColors.background_white,
      colorAppBar: AppColors.background_white,
      title: const Align(
        alignment: Alignment.centerLeft,
        child: CustomTextLabel(
          'Bảng xếp hạng',
          gradient: AppColors.base_gradient_3,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      rightWidgets: [Assets.images.icChart.image(), SizedBox(width: 20,)],
      body: Column(
        children: [
          SizedBox(height: 20,),
          CommonWidget.notificationInfo()
        ],
      ),
    );
  }
}

