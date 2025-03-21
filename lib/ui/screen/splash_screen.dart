import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:scale_size/scale_size.dart';
import '../../gen/assets.gen.dart';
import '../../res/resources.dart';
import '../../util/routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashState();
  }
}

class _SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((_) => openScreen(context));
  }

  Widget build(BuildContext context) {
    ScaleSize.init(context, designWidth: 375, designHeight: 812);
    return Scaffold(
      body: Container(
        color: AppColors.base_color,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.images.loginBackground.path),
                  fit: BoxFit.cover,
                ),
              ), /* add child content here */
            ),
          ],
        ),
      ),
    );
  }

  openScreen(BuildContext context) async {
    // String token = await SharedPreferenceUtil.getToken();
    // await Future.delayed(Duration(seconds: 2));
    // if (token.isEmpty) {
    //   Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (route) => false);
    // } else {
    //   Navigator.pushNamedAndRemoveUntil(context, Routes.mainScreen, (route) => false);
    // }
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (route) => false);
  }
}
