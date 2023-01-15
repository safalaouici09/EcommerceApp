import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations returned
/// by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr')
  ];

  String get ishop;
  String get ishopSlogan;

  String get dzd;

  /// [authentication]
  String get email;
  String get emailAddress;
  String get password;
  String get createPassword;
  String get confirmPassword;
  String get forgotPassword;
  String get weSentYouCode;
  String get weSentYouCodeMessage;
  String get verificationCode;
  String get didNotReceiveCode;
  String get firstName;
  String get lastName;
  String get whereAreYouLocated;
  String get birthDate;
  String get phoneNumber;
  String get addPhoneNumber;
  String get addPhoneNumberCaption;
  String get address;
  String get wilaya;
  Map<int, String> get wilayasMap;
  String get gender;
  Map<int, String> get genders;
  String get register;
  String get login;
  String get logout;
  String get termsAndConditions;
  String get byClickingNextYouAgreeToTermsAndConditions;
  String get createYourIshopAccount;
  String get validate;
  String get cancel;
  String get next;
  String get gettingStarted;
  String get collapse;

  /// [UserHomePage]
  String get home;
  String get searchProduct;
  String get todayDeals;

  /// [Cart]
  String get cart;
  String get totalPrice;
  String get productDeletionMessage;
  String get orderDeletionMessage;
  String get emptyCartCaption;

  /// [Wishlist]
  String get wishlist;
  String get emptyWishlistCaption;


  /// [Profile]
  String get profile;
  String get editProfile;
  String get updateProfile;
  String get myUserId;
  String get personalInformation;
  String get personalInformationMessage;
  String get about;
  String get help;
  String get edit;
  String get promote;
  String get freeze;
  String get delete;

  /// [Settings]
  String get settings;
  String get language;
  String get selectedLanguage;
  String get theme;
  String get systemTheme;
  String get lightTheme;
  String get darkTheme;
  String get reportProblem;
  String get seeAll;

  /// [Order]
  // common
  String get order;
  String get orders;
  String get orderDetails;
  String get yourOrderID;
  String get orderDate;
  String get deliveryDate;
  String get showOrderedProducts;
  String get qty;
  String get yourRating;
  String get total;
  String get emptyOrdersCaption;
  // that of user
  String get unpaidOrders;
  String get toBeDelivered;
  String get orderHistory;
  String get delivered;
  String get checkout;
  // that of seller
  String get recentOrders;
  String get pendingOrders;
  String get deliveryToll;

  /// [Shop]
  String get shop;
  String get name;
  String get description;
  String get category;
  String get categories;
  Map<int, String> get categoriesMap;
  String get yourShops;
  String get addShop;
  String get newShop;
  String get newShopMessage;
  String get editShop;
  String get freezeShop;
  String get freezeShopMessage;
  String get deleteShop;
  String get deleteShopMessage;
  String get reportShop;
  String get aboutShop;

  /// [ShopAdderScreen] and [ShopEditScreen]
  String get createANewShop;
  String get updateShop;
  String get shopOwner;
  String get shopDetails;
  String get hintShopName;
  String get hintShopCategory;
  String get hintShopDescription;
  String get shopAddress;
  String get hintShopAddress;
  String get shopCoverImage;

  /// [Product]
  // common
  String get product;
  String get products;
  String get brand;
  String get price;
  String get quantity;
  String get outOfStock;
  String get likes;
  String get sells;
  String get rating;
  String get aboutProduct;
// that of user
  String get reviews;
  String get left;
  String get addToCart;
  String get addToCartMessage;
  String get addToWishlist;
  String get addToWishlistMessage;
  String get removeFromWishlistMessage;
  String get reportProduct;
  // that of seller
  String get addProduct;
  String get newProduct;
  String get productDetails;
  String get editProduct;
  String get deleteProduct;
  String get deleteProductMessage;

  /// [ProductAdderScreen] and [ProductEditScreen]
  String get createNewProduct;
  String get updateProduct;
  String get hintProductShop;
  String get hintProductName;
  String get hintProductBrand;
  String get hintProductDescription;
  String get yourOffer;
  String get hintProductPrice;
  String get hintProductQuantity;
  String get productImages;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(_lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations _lookupAppLocalizations(Locale locale) {



// Lookup logic when only language code is specified.
switch (locale.languageCode) {
  case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
}


  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
