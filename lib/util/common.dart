import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

import '../ui/screen/tool/calculator_screen.dart';

class Common {
  static DateTime? parserDate(String? date, {String? format}) {
    try {
      if (format == null) {
        return DateTime.parse(date!);
      }
      return DateFormat(format).parse(date!);
    } catch (e) {
      return null;
    }
  }

  static String fromDate(DateTime date, format) {
    try {
      String dateString = DateFormat(format).format(date);
      return dateString;
    } catch (e) {
      return "";
    }
  }

  static String convertDateToFormat(
      String? inputDate, {
        String inputFormat = 'yyyy-MM-ddTHH:mm:ss.SSS',
        String outputFormat = 'dd/MM/yyyy',
      }) {
    if (inputDate == null || inputDate.trim().isEmpty) {
      return '';
    }

    try {
      // Tạo định dạng cho chuỗi đầu vào
      final inputDateFormat = DateFormat(inputFormat);
      // Parse chuỗi đầu vào
      final dateTime = inputDateFormat.parse(inputDate);
      // Tạo định dạng cho chuỗi đầu ra
      final outputDateFormat = DateFormat(outputFormat);
      // Format lại chuỗi theo định dạng đầu ra
      return outputDateFormat.format(dateTime);
    } catch (e) {
      print('Error parsing date: $e');
      return '';
    }
  }


  static int strToInt(String data, {int defaultValue = 0}) {
    try {
      if (data.isEmpty) return defaultValue;
      return int.parse(data);
    } catch (e) {
      return defaultValue ?? -1;
    }
  }

  static num? doubleWithoutDecimalToInt(double? val) {
    if (val == null) {
      return null;
    }
    return val % 1 == 0 ? val.toInt() : val;
  }

  static double strToDouble(String data, {double? defaultValue}) {
    try {
      if (data.isEmpty) return 0;
      return double.parse(data);
    } catch (e) {
      return defaultValue ?? -Math.e;
    }
  }

  static String formatPrice(price, {bool isFormatPriceWithDecimal = false, bool showPrefix = true, String currency = "đ"}) {
    if (price == null) {
      return "";
    }
    try {
      if (isFormatPriceWithDecimal) {
        return formatPriceWithDecimal(price, showPrefix: showPrefix);
      }
      final numberFormat = NumberFormat("#,###", "en-US");
      return numberFormat.format(double.parse(price.toString()).round()) + "${showPrefix ? " $currency" : ""}";
    } catch (e) {
      return price?.toString() ?? "";
    }
  }

  static int getNumberOfDecimalDigitsCurrency(String number) {
    try {
      String numberString = number.toString();
      List<String> parts = numberString.split('.');
      String decimalPart = parts.length > 1 ? parts[1] : '0';
      // decimalPart = strToInt(decimalPart).toString();
      // Đếm số lượng chữ số trong phần thập phân
      return decimalPart.length;
    } catch (e) {}
    return 0;
  }

  static num? strToNum(String? data, {num? defaultValue}) {
    try {
      return num.parse(data!);
    } catch (e) {}
    return defaultValue;
  }

  static String formatPriceWithDecimal(amount, {bool showPrefix = true}) {
    try {
      var dValue = strToNum(amount.toString());
      // Create a NumberFormat instance for Vietnamese locale and currency format
      // Create a NumberFormat instance for Vietnamese locale and currency format
      int decimalDigits = getNumberOfDecimalDigitsCurrency(amount.toString());
      final currencyFormat = NumberFormat.currency(locale: 'en-US', symbol: '', decimalDigits: decimalDigits);
      // Format the amount as currency without a comma
      // String formattedAmount = currencyFormat.format(removeTrailingZeros(amount.toString()));
      String formattedAmount = currencyFormat.format(dValue);
      var result = formattedAmount;
      try {
        RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
        result = formattedAmount.replaceAll(regex, '');
      } catch (e) {}
      if (showPrefix == true) {
        return "${result} đ";
      }
      return result;
    } catch (e) {
      return amount?.toString() ?? "";
    }
  }

  static bool validateEmail(String text) {
    RegExp regex = RegExp("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}");
    return regex.hasMatch(text);
  }

  static bool validatePassword(String text) {
    final passwordRegex = RegExp(
        r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~%^()_+{}\[\]:;<>,.?\/\\|]).{8,}$'
    );
    return passwordRegex.hasMatch(text);
  }

  static bool validatePhone(String text) {
    RegExp regex = RegExp("^[0-9\-\+]{10,15}\$");
    return regex.hasMatch(text);
  }

  static bool validateAccount(String text) {
    RegExp regex = RegExp("^[A-Z0-9a-z]*\$");
    return regex.hasMatch(text);
  }

  static bool validateName(String text) {
    RegExp regex = RegExp("^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*\$");
    return regex.hasMatch(text);
  }

  static String getStringDateToday() {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd/MM/yyyy');
    return formatter.format(now);
  }

  static String getStringDateFirstDayOfMonth() {
    var now = new DateTime.now();
    var date = DateTime(now.year, now.month, 1);
    var formatter = new DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  static String getStringDateLastDayOfMonth() {
    var now = new DateTime.now();
    var date = DateTime(now.year, now.month + 1, 0);
    var formatter = new DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  static String datetimeToSting(DateTime date) {
    var formatter = new DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  static shareContent(String content) {
    Share.share(content);
  }

  static String formatTimeGps(int seconds) {
    if (seconds < 60) {
      return '${seconds}s';
    } else if (seconds < 3600) {
      int minutes = seconds ~/ 60;
      int remainingSeconds = seconds % 60;
      return '${minutes}p${remainingSeconds}s';
    } else {
      int hours = seconds ~/ 3600;
      int minutes = (seconds % 3600) ~/ 60;
      int remainingSeconds = seconds % 60;
      return '${hours}g${minutes}p${remainingSeconds}s';
    }
  }

  static void showCalculator(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CalculatorScreen(),
    );
  }

  static List<List<T>> chunksListWithSize<T>(List<T> list, {int chunkSize = 20}) {
    List<List<T>> chunks = [];
    if (list.isEmpty) {
      return chunks;
    }
    if (chunkSize <= 0) {
      return [list];
    }
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }
}
