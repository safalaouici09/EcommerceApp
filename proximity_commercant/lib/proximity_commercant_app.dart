import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:proximity/l10n/l10n.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_commercant/domain/user_repository/user_repository.dart';
import 'package:proximity_commercant/ui/pages/authentication_pages/view/onBoard.dart';
import 'package:proximity_commercant/ui/pages/authentication_pages/view/view.dart';
import 'package:proximity_commercant/ui/pages/pages.dart';

class ProximityCommercantApp extends StatelessWidget {
  const ProximityCommercantApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// User Settings
    final userSettings = Provider.of<UserSettings>(context);

    /// Changing the StatusBar and NavigationBar in Andorid
    bool themeIsDark = userSettings.theme == 'dark';
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: themeIsDark
            ? scaffoldBackgroundDarkColor
            : scaffoldBackgroundLightColor,
        statusBarColor: Colors.transparent));

    return MaterialApp(
        title: 'Proximity Commercant App',
        theme: userSettings.theme == 'dark' ? darkTheme : lightTheme,
        darkTheme: userSettings.theme == 'light' ? lightTheme : darkTheme,
        locale: userSettings.locale,
        supportedLocales: locales,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: const OnBoard()
        //for testing
        //home: const SignupScreen()
        );
  }
}
