import 'package:proximity/l10n/app_localizations.dart';

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get dzd => 'دج';

  @override
  String get ishop => 'Ishop';
  @override
  String get ishopSlogan => 'The best shopping experience.';

  /// [authentication]
  @override
  String get email => 'البريد الإلكتروني';
  @override
  String get emailAddress => 'عنوان البريد الإلكتروني';
  @override
  String get password => 'كلمة المرور';
  @override
  String get createPassword => 'ضع كلمة مرور';
  @override
  String get confirmPassword => 'تأكيد كلمة المرور';
  @override
  String get forgotPassword => 'هل نسيت كلمة السر؟';
  @override
  String get weSentYouCode => 'تم إرسال رمز التأكيد إلى هاتفك';
  @override
  String get weSentYouCodeMessage => 'أدخل الرمز أدناه للتحقق من رقم هاتفك.';
  @override
  String get verificationCode => 'رمز التأكيد';
  @override
  String get didNotReceiveCode => 'لم يصلك رمز التأكيد؟';
  @override
  String get firstName => 'الإسم';
  @override
  String get lastName => 'اللقب العائلي';
  @override
  String get whereAreYouLocated => 'من أي ولاية أنت؟';
  @override
  String get birthDate => 'تاريخ الميلاد';
  @override
  String get phoneNumber => 'رقم الهاتف';
  @override
  String get addPhoneNumber => 'إضافة رقم هاتف';
  @override
  String get addPhoneNumberCaption => 'أدخل رقم الهاتف الذي ترغب بربطه بحساب iShop الخاص بك في الأسفل.';
  @override
  String get address => 'العنوان';
  @override
  String get wilaya => 'الولاية';
  @override
  Map<int, String> get wilayasMap => {
    1: 'أدرار',
    2: 'الشلف',
    3: 'الأغواط',
    4: 'أم البواقي',
    5: 'باتنة',
    6: 'بجاية',
    7: 'بسكرة',
  };
  @override
  String get gender => 'الجنس';
  @override
  Map<int, String> get genders => {
    0: 'أنثى',
    1: 'ذكر',
  };
  @override
  String get register => 'حساب جديد';
  @override
  String get login => 'تسجيل الدخول';
  @override
  String get logout => 'تسجيل الخروج';
  @override
  String get termsAndConditions => 'الشروط والأحكام';
  @override
  String get byClickingNextYouAgreeToTermsAndConditions => 'بالظغط على التالي، فإنك توافق على شروطنا أي أنك قرأت الشروط والأحكام الخاصة بنا.';
  @override
  String get createYourIshopAccount => 'قم بإنشاء حساب iShop الخاص بك';
  @override
  String get validate => 'ثبت';
  @override
  String get cancel => 'إلغاء';
  @override
  String get next => 'التالي';
  @override
  String get gettingStarted => 'ابدء';
  @override
  String get collapse => 'إخفاء';

  /// [Cart]
  @override
  String get cart => 'السَلَّة';
  @override
  String get totalPrice => 'السُّومَةُ الكلية';
  @override
  String get productDeletionMessage => 'تم حذف المنتج بنجاح من سلة التسوق!';
  @override
  String get orderDeletionMessage => 'تم حذف الطلب بنجاح من سلة التسوق!';
  @override
  String get emptyCartCaption => 'سَلَّة التسوق الخاصة بك فارغة ، ضع في اعتبارك إضافة منتجات إليها.';

  /// [Wishlist]
  @override
  String get wishlist => 'قائمة الرَّغبَات';
  @override
  String get emptyWishlistCaption => '💔\nقائمة رغباتك خاوية.';

  /// [UserHomePage]
  @override
  String get home => 'إكتشف';
  @override
  String get searchProduct => 'البحث عن منتج...';
  @override
  String get todayDeals => 'عروض اليوم';

  /// [Profile]
  @override
  String get profile => 'الحساب';
  @override
  String get editProfile => 'تعديل الملف الشخصي';
  @override
  String get updateProfile => 'تحديث الملف';
  @override
  String get myUserId => 'اﻟـId الخاص بي: ';
  @override
  String get personalInformation => 'المعلومات الشخصية';
  @override
  String get personalInformationMessage => 'قدم معلوماتك الشخصية رغما على أنّ غرض الحساب تجاري. هاته المعلومات  لن تكون ظاهرة للجميع.';
  @override
  String get about => 'حول';
  @override
  String get help => 'مساعدة';
  @override
  String get edit => 'تعديل';
  @override
  String get promote => 'ترويج';
  @override
  String get freeze => 'تجميد';
  @override
  String get delete => 'حذف';

  /// [Settings]
  @override
  String get settings => 'الإعدادات';
  @override
  String get language => 'اللغات';
  @override
  String get selectedLanguage => 'العربية';
  @override
  String get theme => 'نظام الألوان';
  @override
  String get systemTheme => 'نمط النظام';
  @override
  String get lightTheme => 'النمط المشرق';
  @override
  String get darkTheme => 'النمط المظلم';
  @override
  String get reportProblem => 'التبليغ عن مشكل تقني';
  @override
  String get seeAll => 'اظهار الكل';

  /// [Order]
  // common
  @override
  String get order => 'طلب';
  @override
  String get orders => 'الطلبات';
  @override
  String get orderDetails => 'تفاصيل الطلب';
  @override
  String get yourOrderID => 'اﻟـId الخاص بطلبك';
  @override
  String get orderDate => 'تاريخ الطلب';
  @override
  String get deliveryDate => 'تاريخ التوصيل';
  @override
  String get showOrderedProducts => 'عرض المنتجات المطلوبة';
  @override
  String get qty => 'الكمية';
  @override
  String get yourRating => 'تقييمك';
  @override
  String get total => 'المجموع';
  @override
  String get emptyOrdersCaption => 'قائمة الطلبات فارغة';
  // that of user
  @override
  String get unpaidOrders => 'طلبات غير مدفوعة';
  @override
  String get toBeDelivered => 'طلبات قيد التوصيل';
  @override
  String get orderHistory => 'تاريخ الطلبات';
  @override
  String get delivered => 'الطلبات الموصلة';
  @override
  String get checkout => 'دفع الثمن';
  // that of seller
  @override
  String get recentOrders => 'الطلبات الأخيرة';
  @override
  String get pendingOrders => 'الطلبات المعلقة';
  @override
  String get deliveryToll => 'معدل التوصيل';

  /// [Shop]
  @override
  String get shop => 'حانوت';
  @override
  String get name => 'الإسم';
  @override
  String get description => 'التفاصبل';
  @override
  String get category => 'الفئة';
  @override
  String get categories => 'الفئات';
  @override
  Map<int, String> get categoriesMap => {
    0: 'ملابس',
    1: 'هواتف محمولة',
    2: 'ألعاب الكترونية',
    3: 'محل تجميل',
    4: 'سيارات',
    5: 'معدات رياضية',
    6: 'كتب',
    7: 'فئة أخرى',
  };
  @override
  String get yourShops => 'حوانيتك';
  @override
  String get addShop => 'إضافة الحانوت';
  @override
  String get newShop => 'حانوت جديد';
  @override
  String get newShopMessage => 'فتح حانوت موجود بعناوين مختلفة يبقى ممكنا طالماَ أنّ المالك واحد.';
  @override
  String get editShop => 'تعديل الحانوت';
  @override
  String get freezeShop => 'تجميد الحانوت';
  @override
  String get freezeShopMessage => 'إذا كنت ترغب في إغلاق حانوتك مؤقتًا، لغرض إجازة لبضعة أيام أو شيئا ما، قم بتجميده إذا ❄';
  @override
  String get deleteShop => 'حذف الحانوت';
  @override
  String get deleteShopMessage => 'تحذير: من المحتمل أن يكون هذا إجراءً مدمرًا.';
  @override
  String get reportShop => 'الإبلاغ عن الحانوت';
  @override
  String get aboutShop => 'حول الحانوت';

  /// [ShopAdderScreen] and [ShopEditScreen]
  @override
  String get createANewShop => 'إنشاء حانوت جديد';
  @override
  String get updateShop => 'تحديث الحانوت';
  @override
  String get shopOwner => 'مالك الحانوت';
  @override
  String get shopDetails => 'تفاصيل الحانوت';
  @override
  String get hintShopName => 'أعط اسم لحانوتك';
  @override
  String get hintShopCategory => 'حدد فئة مستهدفة';
  @override
  String get hintShopDescription => 'اكتب تفاصيل حانوتك هنا ...';
  @override
  String get shopAddress => 'عنوان الحانوت';
  @override
  String get hintShopAddress => 'اختر عنوانًا';
  @override
  String get shopCoverImage => 'صورة الحانوت';

  /// [Product]
  // common
  @override
  String get product => 'المنتج';
  @override
  String get products => 'المنتوجات';
  @override
  String get brand => 'الماركة';
  @override
  String get price => 'السعر';
  @override
  String get quantity => 'الكمية';
  @override
  String get outOfStock => 'لم يتبقى';
  @override
  String get likes => 'الإعجابات';
  @override
  String get sells => 'المبيعات';
  @override
  String get rating => 'التقييم';
  @override
  String get aboutProduct => 'حول المنتج';
  // that of user
  @override
  String get reviews => 'تقييم';
  @override
  String get left => 'باقي';
  @override
  String get addToCart => 'أَضِف إلى السَلَّة';
  @override
  String get addToCartMessage => 'تمت إضَافة المنتج إلى السَلة بنجاح!';
  @override
  String get addToWishlist => 'أَضِف إلى قائمة الرَّغبَات';
  @override
  String get addToWishlistMessage => 'تمت إضَافة المنتج إلى قائمة الرَّغبات!';
  @override
  String get removeFromWishlistMessage => 'تم حذف المنتج من قائمة الرَّغبات!';
  @override
  String get reportProduct => 'الإبلاغ عن المنتج';
  // that of seller
  @override
  String get addProduct => 'إضافة المنتوج';
  @override
  String get newProduct => 'منتوج جديد';
  @override
  String get productDetails => 'تفاصيل المنتوج';
  @override
  String get editProduct => 'تعديل المنتوج';
  @override
  String get deleteProduct => 'حذف المنتوج';
  @override
  String get deleteProductMessage => 'تحذير: من المحتمل أن يكون هذا إجراءً مدمرًا.';

  /// [ProductAdderScreen] and [ProductEditScreen]
  @override
  String get createNewProduct => 'إنشاء منتوج جديد';
  @override
  String get updateProduct => 'تحديث المنتوج';
  @override
  String get hintProductShop => 'إختر حانوت المنتوج';
  @override
  String get hintProductName => 'سمي منتوجك';
  @override
  String get hintProductBrand => 'أي شركة صنعت هذا المنتج؟';
  @override
  String get hintProductDescription => 'اكتب بضعة أسطر تصف منتجك لزبائنك ...';
  @override
  String get yourOffer => 'عرضك';
  @override
  String get hintProductPrice => 'كم السعر وحدة واحدة؟';
  @override
  String get hintProductQuantity => 'المخزون الافتتاحي لهذا المنتوج';
  @override
  String get productImages => 'صور المنتوج';
}
