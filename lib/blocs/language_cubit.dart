import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../util/constants.dart';
import '../util/localizations.dart';
import '../util/shared_preference.dart';

class LanguageCubit extends Cubit<String> {
  LanguageCubit() : super(Constants.VI);

  void changeLanguage(String language) async {
    await LanguageDelegate().load(Locale(language));
    await SharedPreferenceUtil.setCurrentLanguage(language);
    emit(language);
  }
}
