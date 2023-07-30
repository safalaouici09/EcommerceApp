import 'package:proximity/l10n/app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get ishop => 'Ishop';
  @override
  String get ishopSlogan => 'The best shopping experience.';

  @override
  String get dzd => 'DZD';

  /// [authentication]
  @override
  String get email => 'Email';
  @override
  String get emailAddress => 'Email Address';
  @override
  String get password => 'Password';
  @override
  String get createPassword => 'Create a Password';
  @override
  String get confirmPassword => 'Confirm Password';
  @override
  String get forgotPassword => 'Forgot Password?';
  @override
  String get weSentYouCode => 'We sent you a code';
  @override
  String get weSentYouCodeMessage =>
      'Enter below your code to verify your phone number.';
  @override
  String get verificationCode => 'Verification Code';
  @override
  String get didNotReceiveCode => "Didn't receive code?";
  @override
  String get firstName => 'First name';
  @override
  String get lastName => 'Last name';
  @override
  String get whereAreYouLocated => 'Where are you located?';
  @override
  String get birthDate => 'Birth date';
  @override
  String get phoneNumber => 'Phone number';
  @override
  String get addPhoneNumber => 'Add a phone number';
  @override
  String get addPhoneNumberCaption =>
      'Enter the phone number you want to associated with your iShop account down below.';
  @override
  String get address => 'Address';
  @override
  String get wilaya => 'Wilaya';
  @override
  Map<int, String> get wilayasMap => {
        1: 'Adrar',
        2: 'Chlef',
        3: 'Laghouat',
        4: 'Oum El Bouaghi',
        5: 'Batna',
        6: 'Bejaia',
        7: 'Biskra',
      };
  @override
  String get gender => 'Gender';
  @override
  Map<int, String> get genders => {
        0: 'Female',
        1: 'Male',
      };
  @override
  String get register => 'Register';
  @override
  String get login => 'Login';
  @override
  String get logout => 'Logout';
  @override
  String get termsAndConditions => 'Terms & Conditions';
  @override
  String get byClickingNextYouAgreeToTermsAndConditions =>
      'By clicking Next, you agree to our terms and that you have read our Terms & Conditions.';
  @override
  String get createYourIshopAccount => 'Create your iShop account';
  @override
  String get validate => 'Validate';
  @override
  String get cancel => 'Cancel';
  @override
  String get next => 'Next';
  @override
  String get gettingStarted => 'Getting Started';
  @override
  String get collapse => 'Collapse';

  /// [Cart]
  @override
  String get cart => 'Cart';
  @override
  String get totalPrice => 'Total Price';
  @override
  String get productDeletionMessage =>
      'Product successfully deleted from Cart!';
  @override
  String get orderDeletionMessage => 'Order successfully deleted from Cart!';
  @override
  String get emptyCartCaption =>
      'Your Cart is empty, consider adding products to it.';

  /// [Wishlist]
  @override
  String get wishlist => 'Wishlist';
  @override
  String get emptyWishlistCaption => '💔\nYour Wishlist is empty.';

  /// [UserHomePage]
  @override
  String get home => 'Home';
  @override
  String get searchProduct => 'Search a product...';
  @override
  String get todayDeals => "Today's Deals";

  ///
  String get welcome => "Welcome";

  ///

  /// [Profile]
  @override
  String get profile => 'Profile';
  @override
  String get editProfile => 'Edit profile';
  @override
  String get updateProfile => 'Update profile';
  @override
  String get myUserId => 'My user ID: ';
  @override
  String get personalInformation => 'Personal information';
  @override
  String get personalInformationMessage =>
      "Provider your personal information, even though the account is for business use. These info won't be public to everyone.";
  @override
  String get about => 'About';
  @override
  String get help => 'Help';
  @override
  String get edit => 'Edit';
  @override
  String get promote => 'Promote';
  @override
  String get freeze => 'Freeze';
  @override
  String get delete => 'Delete';

  /// [Settings]
  @override
  String get settings => 'Settings';
  @override
  String get language => 'Language';
  @override
  String get selectedLanguage => 'English';
  @override
  String get theme => 'Theme';
  @override
  String get systemTheme => 'System Theme';
  @override
  String get lightTheme => 'Light Theme';
  @override
  String get darkTheme => 'Dark Theme';
  @override
  String get reportProblem => 'Report a Problem';
  @override
  String get seeAll => 'SEE ALL';

  /// [Order]
  // common
  @override
  String get order => 'Order';
  @override
  String get orders => 'Orders';
  @override
  String get orderDetails => 'Order Details';
  @override
  String get yourOrderID => 'Your Order ID';
  @override
  String get orderDate => 'Order Date';
  @override
  String get deliveryDate => 'Delivery Date';
  @override
  String get showOrderedProducts => 'Show Ordered Products';
  @override
  String get qty => 'Qty';
  @override
  String get yourRating => 'Your Rating';
  @override
  String get total => 'Total';
  @override
  String get emptyOrdersCaption => 'The orders list is empty.';
  // that of user
  @override
  String get unpaidOrders => 'Unpaid Orders';
  @override
  String get toBeDelivered => 'To be delivered';
  @override
  String get orderHistory => 'Order History';
  @override
  String get delivered => 'Delivered';
  @override
  String get checkout => 'Checkout';
  // that of seller
  @override
  String get recentOrders => 'Recent orders';
  @override
  String get pendingOrders => 'Pending orders: ';
  @override
  String get deliveryToll => 'Delivery toll: ';

  /// [Shop]
  @override
  String get shop => 'Shop';
  @override
  String get name => 'Name';
  @override
  String get description => 'Description';
  @override
  String get category => 'Category';
  @override
  String get categories => 'Categories';
  @override
  Map<int, String> get categoriesMap => {
        0: 'Fashion',
        1: 'Phones',
        2: 'Video games',
        3: 'Beauty',
        4: 'Automotive',
        5: 'Sports',
        6: 'Books',
        7: 'Other',
      };
  @override
  String get yourShops => 'Your shops';
  @override
  String get addShop => 'Add shop';
  @override
  String get newShop => 'New shop';
  @override
  String get newShopMessage =>
      'Creating an existing shop with different addresses remains possible as long as the owner is one.';
  @override
  String get editShop => 'Edit shop';
  @override
  String get freezeShop => 'Freeze shop';
  @override
  String get freezeShopMessage =>
      "If you wish to temporarily close your shop, maybe take a vacation for a few days, consider freezing it ❄";
  @override
  String get deleteShop => 'Delete shop';
  @override
  String get deleteShopMessage =>
      'Warning: This is potentially a destructive action.';
  @override
  String get reportShop => 'Report Shop';
  @override
  String get aboutShop => 'About';

  /// [ShopAdderScreen] and [ShopEditScreen]
  @override
  String get createANewShop => 'Create a new shop';
  @override
  String get updateShop => 'Update shop';
  @override
  String get shopOwner => 'Shop owner';
  @override
  String get shopDetails => 'Shop details';
  @override
  String get hintShopName => 'Give your shop a name';
  @override
  String get hintShopCategory => 'Select a targeted category';
  @override
  String get hintShopDescription => 'Write your shop description here...';
  @override
  String get shopAddress => 'Shop address';
  @override
  String get hintShopAddress => 'Select an address';
  @override
  String get shopCoverImage => 'Shop cover image';

  /// [Product]
  // common
  @override
  String get product => 'Product';
  @override
  String get products => 'Products';
  @override
  String get brand => 'Brand name';
  @override
  String get price => 'Price';
  @override
  String get quantity => 'Quantity';
  @override
  String get outOfStock => 'Out of Stock!';
  @override
  String get likes => 'Likes';
  @override
  String get sells => 'Sells';
  @override
  String get rating => 'Rating';
  @override
  String get aboutProduct => 'About';
  // that of user
  @override
  String get reviews => 'Reviews';
  @override
  String get left => 'left';
  @override
  String get addToCart => 'Add to Cart';
  @override
  String get addToCartMessage => 'Product added to Cart';
  @override
  String get addToWishlist => 'Add to Wishlist';
  @override
  String get addToWishlistMessage => 'Product added to Wishlist';
  @override
  String get removeFromWishlistMessage => 'Product removed from Wishlist';
  @override
  String get reportProduct => 'Report Product';
  // that of seller
  @override
  String get addProduct => 'Add product';
  @override
  String get newProduct => 'New products';
  @override
  String get productDetails => 'Product details';
  @override
  String get editProduct => 'Edit product';
  @override
  String get deleteProduct => 'Delete a Product';
  @override
  String get deleteProductMessage => 'Product successfully deleted!';

  /// [ProductAdderScreen] and [ProductEditScreen]
  @override
  String get createNewProduct => 'Create a new product';
  @override
  String get updateProduct => 'Update product';
  @override
  String get hintProductShop => "Choose your product's shop";
  @override
  String get hintProductName => "Your product's name here";
  @override
  String get hintProductBrand => 'Who manufactured this product?';
  @override
  String get hintProductDescription =>
      'Write few lines describing your product to your customers...';
  @override
  String get yourOffer => 'Your offer';
  @override
  String get hintProductPrice => 'How much for one unit?';
  @override
  String get hintProductQuantity => 'Opening stock of this product';
  @override
  String get productImages => 'Product images';
}
