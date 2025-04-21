import 'package:flutter/material.dart';

import '../../res/resources.dart';
import 'widget.dart';

class BaseButton extends StatelessWidget {
  final String? title;
  final BoxDecoration? decoration;
  final GestureTapCallback? onTap;
  final Widget? child;
  final Color? backgroundColor;
  final double? borderRadius;
  final Color? borderColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final double? width;
  final double? height;
  final bool wrapChild;
  final Color? titleColor;
  final bool isDisable;
  final LinearGradient? gradient;

  const BaseButton(
      {this.child,
        Key? key,
        this.decoration,
        this.onTap,
        this.backgroundColor,
        this.borderRadius,
        this.borderColor = Colors.transparent,
        this.margin,
        this.padding,
        this.alignment,
        this.width,
        this.height,
        this.wrapChild = false,
        this.title,
        this.titleColor,
        this.isDisable = false, this.gradient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderRadius? borderRadiusInWell = BorderRadius.circular(0);
    if (borderRadius != null) {
      borderRadiusInWell = BorderRadius.circular(borderRadius!);
    }

    final bool useGradient = backgroundColor == null && !isDisable;
    final Color effectiveBackgroundColor = isDisable
        ? AppColors.disableButton
        : (backgroundColor ?? AppColors.colorButton);

    return Container(
      margin: margin ?? EdgeInsets.zero,
      alignment: alignment,
      decoration: decoration ??
          BoxDecoration(
            gradient: useGradient
                ? (gradient ??
                AppColors.base_gradient_1)
                : null,
            color: useGradient ? null : effectiveBackgroundColor,
            border: Border.all(color: borderColor!),
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
          ),
      child: Material(
        child: InkWell(
          borderRadius: borderRadiusInWell,
          onTap: isDisable ? null : () {
            FocusScope.of(context).requestFocus(FocusNode());
            onTap?.call();
          },
          child: Container(
              alignment: wrapChild ? null : Alignment.center,
              width: width,
              height: height,
              padding: padding ?? EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              child: renderChild()),
        ),
        color: Colors.transparent,
      ),
    );
  }

  renderChild() {
    if (title != null) {
      return CustomTextLabel(
        title,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: isDisable? AppColors.gray : titleColor ?? AppColors.white,
        textAlign: TextAlign.center,
      );
    }
    return child ?? Container();
  }
}
