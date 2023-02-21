import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'package:proximity_client/domain/authentication/authentication.dart';
import 'package:proximity_client/domain/cart_repository/cart_repository.dart';
import 'package:proximity_client/domain/order_repository/order_repository.dart';
import 'package:proximity_client/domain/product_repository/product_repository.dart';
import 'package:proximity_client/domain/store_repository/store_repository.dart';
<<<<<<< HEAD
import 'package:proximity_client/domain/user_repository/models/address_item_model.dart';
=======
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
import 'package:proximity_client/domain/user_repository/user_repository.dart';

import 'proximity_app.dart';

void main() async {
<<<<<<< HEAD
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
=======
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
  WidgetsFlutterBinding.ensureInitialized();
  //Safa:
  await Hive.initFlutter();
  Hive.registerAdapter(CartItemAdapter());
  Hive.registerAdapter(CartAdapter());
  Hive.registerAdapter(WishlistItemAdapter());
<<<<<<< HEAD
  Hive.registerAdapter(AddressItemAdapter());
=======
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705

  /// Credentials are to store [Access Token]
  await Hive.openBox('credentials');
  await Hive.openBox<Cart>('cart');
  await Hive.openBox<CartItem>('cart_items');
  await Hive.openBox<WishlistItem>('wishlist');
<<<<<<< HEAD
  await Hive.openBox<AddressItem>('address');

  /// Settings are to store user settings and preferences
  // await Hive.openBox('settings');
=======

  /// Settings are to store user settings and preferences
  await Hive.openBox('settings');
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705

  /// Google Maps Android Hybrid Composition
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => LoginValidation()),
    ChangeNotifierProvider(create: (_) => SignupValidation()),
    ChangeNotifierProvider(create: (_) => OTPValidation()),
    ChangeNotifierProvider(create: (_) => UserService()),
    ChangeNotifierProvider(create: (_) => ProductService()),
    ChangeNotifierProvider(create: (_) => StoreProxy()),
    ChangeNotifierProxyProvider<StoreProxy, StoreService>(
        create: (_) => StoreService(),
        update: (_, __, storeService) =>
            storeService!..loadStore(Provider.of<StoreProxy>(_))),
    ChangeNotifierProvider(create: (_) => OrderService()),
    ChangeNotifierProvider(create: (context) => CartService()),
    ChangeNotifierProvider(create: (_) => WishlistService()),
    ChangeNotifierProvider(create: (context) => UserSettings()),
  ], child: const ProximityApp()));
}
