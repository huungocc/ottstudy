import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../res/colors.dart';
import '../../../util/routes.dart';
import '../../../util/shared_preference.dart';
import '../../widget/base_screen.dart';
import '../../widget/base_text_input.dart';
import '../../widget/common_widget.dart';
import '../../widget/custom_text_label.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminHomeBody();
  }
}

class AdminHomeBody extends StatefulWidget {
  const AdminHomeBody({super.key});

  @override
  State<AdminHomeBody> createState() => _AdminHomeBodyState();
}

class _AdminHomeBodyState extends State<AdminHomeBody> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      hiddenIconBack: true,
      colorBackground: AppColors.background_white,
      colorAppBar: AppColors.background_white,
      title: const Align(
        alignment: Alignment.centerLeft,
        child: CustomTextLabel(
          'Quản lý',
          gradient: AppColors.base_gradient_1,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      rightWidgets: [
        GestureDetector(
          onTap: () {
            //
          },
          child: PhosphorIcon(
            PhosphorIcons.bellSimple(),
            color: AppColors.black,
            size: 30,
          ),
        ),
        SizedBox(width: 20,),
        GestureDetector(
          onTap: () async {
            await SharedPreferenceUtil.clearData();
            Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (route) => false);
          },
          child: PhosphorIcon(
            PhosphorIcons.signOut(),
            color: Colors.red,
            size: 30,
          ),
        ),
        SizedBox(width: 20,)
      ],
      body: Column(
        children: [
          SizedBox(height: 20,),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: CustomTextInput(
                  margin: EdgeInsets.only(left: 20, right: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.white, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.white, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Tìm kiếm',
                  suffixIcon: Icon(Icons.search_rounded),
                ),
              ),
              GestureDetector(
                onTap: () {
                  //
                },
                child: PhosphorIcon(
                  PhosphorIcons.plusCircle(),
                  size: 30,
                ),
              ),
              SizedBox(width: 20,)
            ],
          ),
          SizedBox(height: 20,),
          CommonWidget.adminCourseCard(
              margin: EdgeInsets.symmetric(horizontal: 20),
              url: 'https://i.ytimg.com/vi/_UR-l3QI2nE/maxresdefault.jpg',
              courseName: '300 bài toán thiếu nhi dễ như ăn kẹo',
              studentNumber: 100,
              onTap: () {
                Navigator.pushNamed(context, Routes.adminCourseInfoScreen);
              }
          )
        ],
      ),
    );
  }
}

