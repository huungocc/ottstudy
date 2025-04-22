import 'dart:ui';

class Constants {
  static const String VI = "vi";
  static const String EN = "en";
  static const SUPPORT_LOCALE = [Locale(VI), Locale(EN)];

  static const TIMEOUT_API = 30000;
}

class FormatDate {
  static const String full = "dd/MM/yyyy HH:mm:ss";
  static const String dayMonthYear = "dd/MM/yyyy";
  static const String formatByServer = "yyyyMMdd";
  static const String hhMMss = "HH:mm ss";
  static const String formatTimeServer = "yyyy-MM-ddTHH:mm:ss";
  static const String yyyyMMdd = "yyyyMMdd";
}

class UserRole {
  static const String admin = "admin";
  static const String user = "user";
}


