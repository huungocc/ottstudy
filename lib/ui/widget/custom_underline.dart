import 'package:flutter/material.dart';
import '../../res/resources.dart';

class CustomUnderLine extends StatelessWidget {
  final Color color;

  const CustomUnderLine({Key? key, this.color = AppColors.base_color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: color,
    );
  }
}
