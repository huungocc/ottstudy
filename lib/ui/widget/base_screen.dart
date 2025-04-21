import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scale_size/scale_size.dart';
import '../../gen/assets.gen.dart';
import '../../res/resources.dart';
import 'widget.dart';

class BaseScreen extends StatelessWidget {
  final double? toolbarHeight;

  // body của màn hình
  final Widget? body;

  // bottomBar
  final Widget? bottomBar;

  // title của appbar có 2 kiểu String và Widget
  // title là kiểu Widget thì sẽ render widget
  // title là String
  final dynamic title;

  // trường hợp có AppBar đặc biệt thì dùng customAppBar
  final Widget? customAppBar;
  final Color colorAppBar;

  // callBack của onBackPress với trường hợp  hiddenIconBack = false
  final Function? onBackPress;

  // custom widget bên phải của appBar
  final List<Widget>? rightWidgets;

  // loadingWidget để show loading toàn màn hình
  final Widget? loadingWidget;

  // show thông báo
  final Widget? messageNotify;
  final Widget? floatingButton;

  // nếu true => sẽ ẩn backIcon
  final bool hiddenIconBack;
  final IconData? iconBack;
  final double? iconBackSize;

  final Color colorTitle;
  final bool hideAppBar;
  final Color colorBackground;
  final Color? iconBackColor;

  final bool isLightStatusBar;
  final bool isLineBottomBar;  //hiển thị gạch dưới bottom appbar
  final bool resizeToAvoidBottomInset;

  const BaseScreen({
    Key? key,
    this.body,
    this.bottomBar,
    this.title = "",
    this.customAppBar,
    this.colorAppBar = AppColors.white,
    this.onBackPress,
    this.rightWidgets,
    this.hiddenIconBack = false,
    this.iconBack,
    this.iconBackSize,
    this.colorTitle = AppColors.black,
    this.loadingWidget,
    this.hideAppBar = false,
    this.messageNotify,
    this.floatingButton,
    this.colorBackground = AppColors.white,
    this.isLightStatusBar = false,
    this.toolbarHeight,
    this.iconBackColor = AppColors.black,
    this.isLineBottomBar = false,
    this.resizeToAvoidBottomInset = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: hideAppBar ? null : (customAppBar == null ? baseAppBar(context) : customAppBar),
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            children: [
              Container(alignment: Alignment.topCenter, color: colorBackground, child: body),
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                bottom: 0,
                child: loadingWidget ?? Container(),
              ),
              messageNotify ?? Container()
            ],
          ),
        ),
        bottomNavigationBar: bottomBar ?? null,
        floatingActionButton: floatingButton ?? null);
    return Stack(
      children: [
        Positioned.fill(
            child: Container(
              color: colorBackground,
            )),
        // Container(
        //   child: Image.asset(
        //     AppImages.APP_BAR_BACKGROUND,
        //     width: 1.width,
        //     height: toolbarHeight + 1.top,
        //     fit: BoxFit.fill,
        //   ),
        // ),
        scaffold
      ],
    );
  }

  baseAppBar(BuildContext context) {
    var widgetTitle;
    if (title is Widget) {
      widgetTitle = title;
    } else {
      widgetTitle = CustomTextLabel(
        this.title?.toString(),
        maxLines: 2,
        fontWeight: FontWeight.w700,
        fontSize: 16.sw,
        textAlign: TextAlign.center,
        color: colorTitle,
      );
    }
    return AppBar(
      elevation: 0,
      toolbarHeight: toolbarHeight ?? 50.sw,
      backgroundColor: colorAppBar,
      title: widgetTitle,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isLightStatusBar ? Brightness.light : Brightness.dark, // For Android (light)
        statusBarBrightness: isLightStatusBar ? Brightness.dark : Brightness.light, // For iOS (light)
      ),
      automaticallyImplyLeading: false,
      leading: hiddenIconBack
          ? null
          : InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          if (onBackPress != null) {
            onBackPress?.call();
          } else {
            Navigator.pop(context);
          }
        },
        child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 15),
          child: Icon(
            iconBack ?? Icons.arrow_back_rounded,
            color: iconBackColor,
          ),
        ),
      ),
      centerTitle: true,
      actions: rightWidgets ?? [],
      bottom:isLineBottomBar? PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Container(
          color: AppColors.base_color_border_textfield,

          height: 1.0,
        ),
      ):null,
    );

  }
}
