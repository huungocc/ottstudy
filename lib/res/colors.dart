import 'package:flutter/material.dart';

class AppColors {
  // define all your color
  static const Color white = Color(0xffffffff);
  static const Color background_white = Color(0xfff6f5f5);
  static const Color black = Color(0xFF000000);
  static const Color gray = Color(0xFF75818F);
  static const Color base_color = Color(0xFF0085FF);
  static const Color colorError = Color(0xFFFF0000);

  static const Color disable = Color(0xffE6E8EB);
  static const Color focusBorder = Color(0xFF71ADE7);
  static const Color border = Color(0xFFE6E8EB);
  static const Color hintTextColor = Color(0xFFB3B8C1);
  static const Color disableButton = Color(0xfff2f3f4);
  static const Color colorButton = Color(0xff2B68B2);
  static const Color colorTitle = Color(0xff001230);
  static const Color base_color_border_textfield = Color(0xFFD6DCE2);
  static const Color gray_title = Color(0xff747474);
  static const Color gray_border = Color(0xffd5d5d5);
  static const Color base_pink = Color(0xffec6f9e);
  static const Color base_blue = Color(0xff5670ec);

  static const LinearGradient base_gradient_1 = LinearGradient(colors: [
    Color(0xffec6f9e),
    Color(0xffec8b6a),
  ], begin: FractionalOffset.centerLeft, end: FractionalOffset.centerRight, tileMode: TileMode.mirror);

  static const LinearGradient base_gradient_2 = LinearGradient(colors: [
    Color(0xff5670ec),
    Color(0xff07bafe),
  ], begin: FractionalOffset.centerLeft, end: FractionalOffset.centerRight, tileMode: TileMode.mirror);

  static const LinearGradient base_gradient_3 = LinearGradient(colors: [
    Color(0xff4e54c8),
    Color(0xff8f94fb),
  ], begin: FractionalOffset.centerLeft, end: FractionalOffset.centerRight, tileMode: TileMode.mirror);

  static const LinearGradient base_gradient_4 = LinearGradient(colors: [
    Color(0xffff416c),
    Color(0xffff4b2b),
  ], begin: FractionalOffset.centerLeft, end: FractionalOffset.centerRight, tileMode: TileMode.mirror);
}
