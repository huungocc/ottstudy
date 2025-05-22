import 'package:flutter/material.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import '../../../res/colors.dart';
import '../../widget/common_widget.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RegistrationBody();
  }
}

class RegistrationBody extends StatefulWidget {
  const RegistrationBody({super.key});

  @override
  State<RegistrationBody> createState() => _RegistrationBodyState();
}

class _RegistrationBodyState extends State<RegistrationBody> {
  void _onRegistration() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommonWidget.studentInfo(isApproving: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      hideAppBar: true,
      colorBackground: AppColors.background_white,
      body: Column(
        children: [
          SizedBox(height: 20,),
          SizedBox(height: 20,),
          CommonWidget.studentCard(
            margin: EdgeInsets.symmetric(horizontal: 20),
            url: 'https://toquoc.mediacdn.vn/280518851207290880/2022/12/15/p0dnxrcv-16710704848821827978943.jpg',
            studentName: 'Nguyễn Hữu Ngọc',
            studentId: 'HS102',
            isFinished: false,
            onTap: () {
              _onRegistration();
            }
          )
        ],
      ),
    );
  }
}

