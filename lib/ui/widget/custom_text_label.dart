import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../../res/colors.dart';
import '../../util/common.dart';

class CustomTextLabel extends StatelessWidget {
  final dynamic title;
  final double? fontSize;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final Color color;
  final TextAlign textAlign;
  final int maxLines;
  final double? fontHeight;
  final bool formatCurrency;
  final bool isFormatPriceWithDecimal;
  final String? fontFamily;
  final bool isRequired;
  final LinearGradient? gradient;

  const CustomTextLabel(this.title,
      {Key? key,
        this.fontSize,
        this.fontWeight = FontWeight.normal,
        this.fontStyle = FontStyle.normal,
        this.decoration,
        this.decorationColor,
        this.color = Colors.black,
        this.textAlign = TextAlign.start,
        this.maxLines = 50,
        this.fontHeight,
        this.fontFamily,
        this.formatCurrency = false,
        this.isFormatPriceWithDecimal = false,
        this.isRequired = false, this.gradient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isRequired == true) {
      return Row(
        children: [
          renderContent(),
          SizedBox(width: 3),
          Text(
            "*",
            textAlign: textAlign,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
            style: TextStyle(
              height: fontHeight,
              fontSize: fontSize ?? 14,
              fontWeight: fontWeight,
              color: AppColors.colorError,
              fontStyle: fontStyle,
              decoration: decoration,
              decorationColor: decorationColor,
            ),
          )
        ],
      );
    }

    return renderContent();
  }

  Widget renderContent() {
    final textWidget = Text(
      title?.toString() ?? "",
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      style: TextStyle(
        height: fontHeight ?? 22.27 / 19,
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        decoration: decoration,
        decorationColor: decorationColor,
        foreground: gradient != null
            ? (Paint()..shader = gradient!.createShader(Rect.fromLTWH(0, 0, 200, 30)))
            : null,
        color: gradient == null ? color : null,
      )
    );

    return gradient != null
        ? ShaderMask(
      shaderCallback: (bounds) => gradient!.createShader(bounds),
      child: textWidget,
    )
        : textWidget;
  }

  static renderBaseTitle({String? title, FontWeight? fontWeight, bool isRequired = false, Color? titleColor, LinearGradient? gradient}) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: CustomTextLabel(
        title,
        color: titleColor ?? Colors.black,
        gradient: gradient,
        fontSize: 14,
        isRequired: isRequired,
        fontWeight: fontWeight ?? FontWeight.w600,
      ),
    );
  }
}

class ErrorTextWidget extends StatelessWidget {
  final String? errorText;
  final Color? errorTextColor;
  final EdgeInsets? margin;

  const ErrorTextWidget({Key? key, this.errorText, this.errorTextColor, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CustomTextLabel(errorText, color: this.errorTextColor ?? Colors.red, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
