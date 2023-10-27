import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:proximity/l10n/l10n.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/user_repository/user_repository.dart';
import 'package:proximity_client/ui/pages/main_pages/view/onBoard.dart';
import 'package:proximity_client/ui/pages/main_pages/view/welcomeScreen.dart';
import 'package:proximity_client/ui/pages/pages.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'domain/data_persistence/src/boxes.dart';

class ProximityApp extends StatefulWidget {
  const ProximityApp({Key? key}) : super(key: key);

  @override
  State<ProximityApp> createState() => _ProximityAppState();
}

class _ProximityAppState extends State<ProximityApp> {
  @override
  void initState() {
    super.initState();
    initPlatform();
  }

  @override
  Widget build(BuildContext context) {
    var credentialsBox = Boxes.getCredentials();
    bool isFirstTime = credentialsBox.get('first_time', defaultValue: true);

    /// User Settings
    final userSettings = Provider.of<UserSettings>(context);

    /// Changing the StatusBar and NavigationBar in Andorid
    bool themeIsDark = userSettings.theme == 'dark';
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: scaffoldBackgroundLightColor,
        // systemNavigationBarColor: themeIsDark
        //    ? scaffoldBackgroundDarkColor
        //  : scaffoldBackgroundLightColor,
        statusBarColor: Colors.transparent));

    return MaterialApp(
        title: 'Proximity App',
        theme: lightTheme,
        darkTheme: lightTheme,
        // theme: userSettings.theme == 'dark' ? darkTheme : lightTheme,
        // darkTheme: userSettings.theme == 'light' ? lightTheme : darkTheme,
        locale: userSettings.locale,
        supportedLocales: locales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: const OnBoard());
  }

  Future<void> initPlatform() async {
    // await OneSignal.shared.setRequiresUserPrivacyConsent(true);
    // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setAppId("647f5e0b-0643-4098-a451-0cbce475e3af");
    await OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((accepted) {
      print("Accepted permission: $accepted");
    });
  }
}
