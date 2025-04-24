import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstant {
  static final apiHost = dotenv.env['API_URL'].toString();

  //Auth
  static final login = "auth/login";
  static final signup = "";

  //Account
  static final changePassword = "auth/change_password";
  static final updateProfile = "auth/update_profile";

  //Gemini Key
  static final geminiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";
  static final geminiKey = dotenv.env['GEMINI_KEY'].toString();
}
