import 'package:flutter/material.dart';
import '../../res/resources.dart';

class BaseProgressIndicator extends StatelessWidget {
  final double? size;

  const BaseProgressIndicator({Key? key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loading = CircularProgressIndicator(
      strokeWidth: 3,
      backgroundColor: AppColors.base_color,
      valueColor: new AlwaysStoppedAnimation<Color>(AppColors.base_color),
    );
    return size == null
        ? loading
        : SizedBox(
            width: size,
            height: size,
            child: loading,
          );
  }
}
