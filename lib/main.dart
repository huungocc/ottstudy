import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ngoc_base_flutter/gen/i18n/generated_locales/l10n.dart';
import 'package:ngoc_base_flutter/ui/widget/locale_widget.dart';
import 'package:ngoc_base_flutter/util/navigator.dart';
import 'blocs/cubit.dart';
import 'util/routes.dart';
import 'util/shared_preference.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String language = await SharedPreferenceUtil.getCurrentLanguage();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark, // Màu biểu tượng trên status bar
    ),
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LanguageCubit(),
        ),
      ],
      child: MyApp.language(language),
    ),
  );
}

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  final String? language;

  MyApp.language(this.language);

  @override
  Widget build(BuildContext context) {
    return LocaleWidget(
      builder: (state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorObservers: [routeObserver],
          navigatorKey: NavigationService.instance.navigatorKey,
          localizationsDelegates: [
            AppLocalizations.delegate, // Add this line
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: Locale(state),
          supportedLocales: AppLocalizations.delegate.supportedLocales,
          localeResolutionCallback: (locale, supportedLocales) =>
              _localeCallback(locale, supportedLocales),
          initialRoute: Routes.initScreen(),
          onGenerateRoute: Routes.generateRoute,
        );
      }
    );
  }

  Locale _localeCallback(Locale? locale, Iterable<Locale> supportedLocales) {
    if (locale == null) {
      return supportedLocales.first;
    }
    // Check if the current device locale is supported
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return supportedLocale;
      }
    }
    // If the locale of the device is not supported, use the first one
    // from the list (japanese, in this case).
    return supportedLocales.first;
  }
}

