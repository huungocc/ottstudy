import 'dart:ui';

import '../ui/widget/base_text_input.dart';

class Constants {
  static const String VI = "vi";
  static const String EN = "en";
  static const SUPPORT_LOCALE = [Locale(VI), Locale(EN)];

  static const TIMEOUT_API = 30000;

  static List<DropdownItem> subjects = [
    DropdownItem(id: 1, value: 'Tiếng Việt', additionalData: 'vietnamese'),
    DropdownItem(id: 2, value: 'Toán', additionalData: 'math'),
    DropdownItem(id: 3, value: 'Đạo đức', additionalData: 'morality'),
    DropdownItem(id: 4, value: 'Tự nhiên và Xã hội', additionalData: 'science_and_society'),
    DropdownItem(id: 5, value: 'Khoa học', additionalData: 'science'),
    DropdownItem(id: 6, value: 'Lịch sử và Địa lý', additionalData: 'history_and_geography'),
    DropdownItem(id: 7, value: 'Tin học và Công nghệ', additionalData: 'ict_and_technology'),
    DropdownItem(id: 8, value: 'Giáo dục thể chất', additionalData: 'physical_education'),
    DropdownItem(id: 9, value: 'Âm nhạc', additionalData: 'music'),
    DropdownItem(id: 10, value: 'Mỹ thuật', additionalData: 'arts'),
    DropdownItem(id: 11, value: 'Tiếng Anh', additionalData: 'english'),
  ];

  static List<DropdownItem> grades = [
    DropdownItem(id: 1, value: 'Lớp 1'),
    DropdownItem(id: 2, value: 'Lớp 2'),
    DropdownItem(id: 3, value: 'Lớp 3'),
    DropdownItem(id: 4, value: 'Lớp 4'),
    DropdownItem(id: 5, value: 'Lớp 5')
  ];

  static List<DropdownItem> answer = [
    DropdownItem(id: 1, value: 'A'),
    DropdownItem(id: 2, value: 'B'),
    DropdownItem(id: 3, value: 'C'),
    DropdownItem(id: 4, value: 'D'),
  ];
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


