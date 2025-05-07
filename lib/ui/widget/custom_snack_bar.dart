import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/base_bloc/base.dart';
import '../../res/colors.dart';
import '../../util/constants.dart';
import 'widget.dart';

class CustomSnackBar<T extends Cubit<BaseState>> extends StatelessWidget {
  final double? fontSize;

  const CustomSnackBar({Key? key, this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<T, BaseState>(
        child: Container(),
        listener: (context, state) {
          String? mess;
          if (state is LoadedState && state.message.isNotEmpty) {
            mess = state.message;
          } else if (state is ErrorState) {
            mess = state.data;
          }
          if (mess?.isNotEmpty ?? false) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: CustomTextLabel(
                mess,
                fontSize: fontSize ?? 14,
                gradient: AppColors.base_gradient_1,
                fontWeight: FontWeight.w400,
              ),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(20),
              backgroundColor: AppColors.white,
              duration: Duration(milliseconds: 1400),
            ));
          }
        });
  }

  static showMessage(
      BuildContext context, {
        required String mess,
        double? fontSize,
        Color? textColor,
        Color? backgroundColor,
        int? timeHideMessage,
      }) {
    if (mess.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustomTextLabel(
          mess,
          fontSize: fontSize ?? 14,
          color: textColor ?? Colors.black,
          fontWeight: FontWeight.w600,
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(20),
        backgroundColor: backgroundColor ?? AppColors.white,
        duration: Duration(milliseconds: timeHideMessage ?? 2000),
      ));
    }
  }
}
