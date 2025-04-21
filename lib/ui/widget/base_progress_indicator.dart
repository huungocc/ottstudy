import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../res/resources.dart';

class BaseProgressIndicator extends StatelessWidget {
  final double? size;
  final Color color;

  const BaseProgressIndicator({Key? key, this.size, this.color = AppColors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loading = SpinKitFadingCircle(
      color: color,
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
