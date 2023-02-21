import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:proximity/l10n/l10n.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/user_repository/user_repository.dart';
<<<<<<< HEAD
import 'package:proximity_client/ui/pages/main_pages/view/welcomeScreen.dart';
=======
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
import 'package:proximity_client/ui/pages/pages.dart';

class ProximityApp extends StatelessWidget {
  const ProximityApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// User Settings
<<<<<<< HEAD
    // final userSettings = Provider.of<UserSettings>(context);

    /// Changing the StatusBar and NavigationBar in Andorid
    // bool themeIsDark = userSettings.theme == 'dark';
=======
    final userSettings = Provider.of<UserSettings>(context);
    /// Changing the StatusBar and NavigationBar in Andorid
    bool themeIsDark = userSettings.theme == 'dark';
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
<<<<<<< HEAD
        systemNavigationBarColor: scaffoldBackgroundLightColor,
        // systemNavigationBarColor: themeIsDark
        //    ? scaffoldBackgroundDarkColor
        //  : scaffoldBackgroundLightColor,
=======
        systemNavigationBarColor:
        themeIsDark ? scaffoldBackgroundDarkColor : scaffoldBackgroundLightColor,
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
        statusBarColor: Colors.transparent));

    return MaterialApp(
      title: 'Proximity App',
<<<<<<< HEAD
      theme: lightTheme,
      darkTheme: lightTheme,
      // theme: userSettings.theme == 'dark' ? darkTheme : lightTheme,
      // darkTheme: userSettings.theme == 'light' ? lightTheme : darkTheme,
      //  locale: userSettings.locale,
=======
      theme: userSettings.theme == 'dark' ? darkTheme : lightTheme,
      darkTheme: userSettings.theme == 'light' ? lightTheme : darkTheme,
      locale: userSettings.locale,
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
      supportedLocales: locales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
<<<<<<< HEAD
      home: const WelcomeScreen(),
=======
      home: const OnboardingScreen(),
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
    );
  }
}
