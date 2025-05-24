import 'package:flutter/material.dart';
import 'package:ottstudy/data/models/forgot_password_model.dart';
import 'package:ottstudy/data/models/lesson_model.dart';
import 'package:ottstudy/ui/screen/auth/signup_screen.dart';
import 'package:ottstudy/ui/screen/course/my_course_screen.dart';
import 'package:ottstudy/ui/screen/course/video_lesson_screen.dart';
import 'package:ottstudy/ui/screen/edit_account/change_password_screen.dart';
import 'package:ottstudy/ui/screen/edit_account/edit_account_info_screen.dart';
import 'package:ottstudy/ui/screen/main_screen/account_screen.dart';
import 'package:ottstudy/ui/screen/main_screen/explore_screen.dart';
import 'package:ottstudy/ui/screen/main_screen/home_screen.dart';
import 'package:ottstudy/ui/screen/main_screen/main_screen.dart';
import 'package:ottstudy/ui/screen/tool/chat_bot_screen.dart';
import 'package:page_transition/page_transition.dart';
import '../data/models/course_model.dart';
import '../data/models/test_model.dart';
import '../ui/screen/admin/admin_course_edit_screen.dart';
import '../ui/screen/admin/admin_course_info_screen.dart';
import '../ui/screen/admin/admin_home_screen.dart';
import '../ui/screen/admin/admin_lesson_edit_screen.dart';
import '../ui/screen/auth/forgot_password_screen.dart';
import '../ui/screen/auth/login_screen.dart';
import '../ui/screen/auth/reset_password_screen.dart';
import '../ui/screen/course/course_info_screen.dart';
import '../ui/screen/course/pdf_lesson_screen.dart';
import '../ui/screen/exam/essay_screen.dart';
import '../ui/screen/exam/quiz_screen.dart';
import '../ui/screen/main_screen/chart_screen.dart';
import '../ui/screen/screen.dart';

class Routes {
  Routes._();

  //screen name
  static const String splashScreen = "/splashScreen";
  static const String loginScreen = "/loginScreen";
  static const String signupScreen = "/signupScreen";
  static const String mainScreen = "/mainScreen";
  static const String homeScreen = "/homeScreen";
  static const String explorerScreen = "/explorerScreen";
  static const String courseInfoScreen = "/courseInfoScreen";
  static const String chartScreen = "/chartScreen";
  static const String videoLessonScreen = "/videoLessonScreen";
  static const String pdfLessonScreen = "/pdfLessonScreen";
  static const String quizScreen = "/quizScreen";
  static const String essayScreen = "/essayScreen";
  static const String accountScreen = "/accountScreen";
  static const String myCourseScreen = "/myCourseScreen";
  static const String chatBotScreen = "/chatBotScreen";
  static const String adminHomeScreen = "/adminHomeScreen";
  static const String adminCourseInfoScreen = "/adminCourseInfoScreen";
  static const String adminCourseEditScreen = "/adminCourseEditScreen";
  static const String adminLessonEditScreen = "/adminLessonEditScreen";
  static const String editAccountInfoScreen = "/editAccountInfoScreen";
  static const String changePasswordScreen = "/changePasswordScreen";
  static const String forgotPasswordScreen = "/forgotPasswordScreen";
  static const String resetPasswordScreen = "/resetPasswordScreen";

  //init screen name
  static String initScreen() => splashScreen;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return PageTransition(child: SplashScreen(), type: PageTransitionType.fade);
      case loginScreen:
        return PageTransition(child: LoginScreen(), type: PageTransitionType.fade);
      case signupScreen:
        return PageTransition(child: SignupScreen(), type: PageTransitionType.fade);
      case forgotPasswordScreen:
        return PageTransition(child: ForgotPasswordScreen(), type: PageTransitionType.rightToLeft);
      case resetPasswordScreen:
        ForgotPasswordModel? arg;
        if (settings.arguments is ForgotPasswordModel) {
          arg = settings.arguments as ForgotPasswordModel;
        }
        return PageTransition(
          child: ResetPasswordScreen(
            arg: arg
          ),
          type: PageTransitionType.rightToLeft
        );
      //Main
      case mainScreen:
        return PageTransition(child: MainScreen(), type: PageTransitionType.fade);
      case homeScreen:
        return PageTransition(child: HomeScreen(), type: PageTransitionType.fade);
      case explorerScreen:
        return PageTransition(child: ExploreScreen(), type: PageTransitionType.fade);
      case chartScreen:
        return PageTransition(child: ChartScreen(), type: PageTransitionType.fade);
      case accountScreen:
        return PageTransition(child: AccountScreen(), type: PageTransitionType.fade);
      //Info
      case courseInfoScreen:
        CourseModel? arg;
        if (settings.arguments is CourseModel) {
          arg = settings.arguments as CourseModel;
        }
        return PageTransition(
            child: CourseInfoScreen(
                arg: arg
            ),
            type: PageTransitionType.fade
        );
      case myCourseScreen:
        return PageTransition(child: MyCourseScreen(), type: PageTransitionType.rightToLeft);
      //Lesson
      case videoLessonScreen:
        LessonModel? arg;
        if (settings.arguments is LessonModel) {
          arg = settings.arguments as LessonModel;
        }
        return PageTransition(
            child: VideoLessonScreen(
                arg: arg
            ),
            type: PageTransitionType.rightToLeft
        );
      case pdfLessonScreen:
        LessonModel? arg;
        if (settings.arguments is LessonModel) {
          arg = settings.arguments as LessonModel;
        }
        return PageTransition(
            child: PdfLessonScreen(
                arg: arg
            ),
            type: PageTransitionType.rightToLeft
        );
      //Exam
      case quizScreen:
        TestModel? arg;
        if (settings.arguments is TestModel) {
          arg = settings.arguments as TestModel;
        }
        return PageTransition(
            child: QuizScreen(
                arg: arg
            ),
            type: PageTransitionType.rightToLeft
        );
      case essayScreen:
        return PageTransition(child: EssayScreen(), type: PageTransitionType.rightToLeft);
      //Tool
      case chatBotScreen:
        return PageTransition(child: ChatBotScreen(), type: PageTransitionType.rightToLeft);
      //Admin
      case adminHomeScreen:
        return PageTransition(child: AdminHomeScreen(), type: PageTransitionType.fade);
      case adminCourseInfoScreen:
        return PageTransition(child: AdminCourseInfoScreen(), type: PageTransitionType.rightToLeft);
      case adminCourseEditScreen:
        return PageTransition(child: AdminCourseEditScreen(), type: PageTransitionType.rightToLeft);
      case adminLessonEditScreen:
        return PageTransition(child: AdminLessonEditScreen(), type: PageTransitionType.rightToLeft);
      //Account Info
      case editAccountInfoScreen:
        return PageTransition(child: EditAccountInfoScreen(), type: PageTransitionType.fade);
      case changePasswordScreen:
        return PageTransition(child: ChangePasswordScreen(), type: PageTransitionType.fade);
      default:
        return MaterialPageRoute(builder: (context) => Container());
    }
  }
}
