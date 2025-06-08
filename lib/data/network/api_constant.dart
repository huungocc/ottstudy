import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstant {
  static final apiHost = dotenv.env['API_URL'].toString();
  // static final apiHost = dotenv.env['API_URL_LOCAL'].toString();

  //Auth
  static final login = "auth/login";
  static final signup = "auth/register";
  static final forgotPassword = "auth/forgot_password";
  static final verifyOtp = "auth/verify_reset_token";
  static final resetPassword = "auth/reset_password";

  //Account
  static final changePassword = "auth/change_password";
  static final updateProfile = "auth/update_profile";
  static final userInfo = "auth/user_info";

  static final uploadFile = "upload";
  static final delete = "admin/delete";

  //Course
  static final listCourse = "course/list";
  static final createCourse = "admin/create/course";
  static final courseInfo = "course/info";

  //Lesson
  static final createLesson = "admin/create/lesson";
  static final listLesson = "lesson/list";
  static final lessonInfo = "lesson/info";

  //Test
  static final createTest = "admin/create/test";
  static final testInfo = "test/info";

  //Question
  static final createQuestion = "admin/create/question";
  static final listQuestion = "question/list";

  //Registration
  static final createRegistration = "registration/create";
  static final registrationStatus = "registration/status";
  static final listRegistration = "admin/registration/list";
  static final approveRegistration = "admin/registration/accept";
  static final userInfoByAdmin = "admin/user_info";
  static final updateTestCubit = "registration/update_test";
  static final myListRegistration = "registration/list";

  //Rank
  static final rank = "rank/list";
  static final myRank = "rank/my_rank";
  static final updateStudyTime = "registration/add_study_time";

  //Gemini Key
  static final geminiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";
  static final geminiKey = dotenv.env['GEMINI_KEY'].toString();
}
