import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:proximity_commercant/domain/authentication/authentication.dart';
import 'package:proximity_commercant/domain/authentication/src/reset_password_validation.dart';
import 'package:proximity_commercant/domain/order_repository/order_repository.dart';
import 'package:proximity_commercant/domain/product_repository/product_repository.dart';
import 'package:proximity_commercant/domain/store_repository/store_repository.dart';
import 'package:proximity_commercant/domain/user_repository/user_repository.dart';

import 'proximity_commercant_app.dart';

void main() async {
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  /// Credentials are to store [Access Token]
  await Hive.openBox('credentials');

  /// Settings are to store user settings and preferences
  await Hive.openBox('settings');

  /// Google Maps Android Hybrid Composition
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => LoginValidation()),
    ChangeNotifierProvider(create: (_) => ResetPasswordValidation()),
    ChangeNotifierProvider(create: (_) => SignupValidation()),
    ChangeNotifierProvider(create: (_) => OTPValidation()),
    ChangeNotifierProvider(create: (_) => UserService()),
    ChangeNotifierProxyProvider<LoginValidation, UserService>(
        create: (_) => UserService(),
        update: (_, __, UserService) => UserService!..getUserData()),
    ChangeNotifierProxyProvider<OTPValidation, UserService>(
        create: (_) => UserService(),
        update: (_, __, UserService) => UserService!..getUserData()),
    ChangeNotifierProvider(create: (_) => StoreService()),
    ChangeNotifierProvider(create: (_) => ProductProxy()),
    ChangeNotifierProxyProvider<ProductProxy, ProductService>(
        create: (_) => ProductService(),
        update: (_, __, productService) =>
            productService!..reloadList(Provider.of<ProductProxy>(_))),
    ChangeNotifierProvider(create: (_) => OrderService()),
    ChangeNotifierProvider(create: (_) => UserSettings()),
  ], child: const ProximityCommercantApp()));
}