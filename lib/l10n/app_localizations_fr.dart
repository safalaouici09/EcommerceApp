import 'package:proximity/l10n/app_localizations.dart';

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get ishop => 'Ishop';
  @override
  String get ishopSlogan => 'The best shopping experience.';

  @override
  String get dzd => 'DZD';

  /// [authentication]
  @override
  String get email => 'E-mail';
  @override
  String get emailAddress => 'Adresse électronique';
  @override
  String get password => 'Mot de passe';
  @override
  String get createPassword => 'Créer un mot de passe';
  @override
  String get confirmPassword => 'Confirmez le mot de passe';
  @override
  String get forgotPassword => 'Mot de passe oublié?';
  @override
  String get weSentYouCode => 'Nous vous avons envoyé un code';
  @override
  String get weSentYouCodeMessage => 'Entrez ci-dessous votre code pour vérifier votre numéro de téléphone.';
  @override
  String get verificationCode => 'Code de vérification';
  @override
  String get didNotReceiveCode => "Vous n'avez pas reçu de code?";
  @override
  String get firstName => 'Prénom';
  @override
  String get lastName => 'Nom de famille';
  @override
  String get whereAreYouLocated => 'Où es-tu Situé?';
  @override
  String get birthDate => 'Date de naissance';
  @override
  String get phoneNumber => 'N° Tel';
  @override
  String get addPhoneNumber => 'Ajouter un Numéro de téléphone';
  @override
  String get addPhoneNumberCaption => 'Entrez le numéro de téléphone que vous souhaitez associer à votre compte iShop ci-dessous.';
  @override
  String get address => 'Adresse';
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
  String get gender => 'Genre';
  @override
  Map<int, String> get genders => {
    0: 'Femelle',
    1: 'Mâle',
  };
  @override
  String get register => "S'inscrire";
  @override
  String get login => 'Se connecter';
  @override
  String get logout => 'Se déconnecter';
  @override
  String get termsAndConditions => 'Termes et Conditions';
  @override
  String get byClickingNextYouAgreeToTermsAndConditions => 'En cliquant sur Suivant, vous acceptez nos conditions et que vous avez lu nos conditions générales.';
  @override
  String get createYourIshopAccount => 'Créez votre compte iShop';
  @override
  String get validate => 'Valider';
  @override
  String get cancel => 'Annuler';
  @override
  String get next => 'Suivant';
  @override
  String get gettingStarted => 'Commencer';
  @override
  String get collapse => 'Réduire';

  /// [Cart]
  @override
  String get cart => 'Cart';
  @override
  String get totalPrice => 'Total Price';
  @override
  String get productDeletionMessage => 'Product successfully deleted from Cart!';
  @override
  String get orderDeletionMessage => 'Order successfully deleted from Cart!';
  @override
  String get emptyCartCaption => 'Your Cart is empty, consider adding products to it.';

  /// [Wishlist]
  @override
  String get wishlist => 'Wishlist';
  @override
  String get emptyWishlistCaption => '💔\nYour Wishlist is empty.';

  /// [UserHomePage]
  @override
  String get home => 'Home';
  @override
  String get searchProduct => '';
  @override
  String get todayDeals => '';

  /// [Profile]
  @override
  String get profile => 'Profil';
  @override
  String get editProfile => 'Modifier mon profil';
  @override
  String get updateProfile => 'Mettre à jour mon profil';
  @override
  String get myUserId => 'Mon identifiant';
  @override
  String get personalInformation => 'Informations personnelles';
  @override
  String get personalInformationMessage => 'Fournissez vos informations personnelles, même si le compte est à usage professionnel. Ces informations ne seront pas publiques pour tout le monde.';
  @override
  String get about => 'À propos';
  @override
  String get help => 'Aide';
  @override
  String get edit => 'Modifier';
  @override
  String get promote => 'Promouvoir';
  @override
  String get freeze => 'Geler';
  @override
  String get delete => 'Supprimer';

  /// [Settings]
  @override
  String get settings => 'Paramètres';
  @override
  String get language => 'Langues';
  @override
  String get selectedLanguage => 'Français';
  @override
  String get theme => 'Thème';
  @override
  String get systemTheme => 'Thème du système';
  @override
  String get lightTheme => 'Thème lumineux';
  @override
  String get darkTheme => 'Thème sombre';
  @override
  String get reportProblem => 'Reporter un Probleme';
  @override
  String get seeAll => 'VOIR TOUT';

  /// [Order]
  // common
  @override
  String get order => 'Commande';
  @override
  String get orders => 'Commandes';
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
  String get checkout => 'Payer';
  // that of seller
  @override
  String get recentOrders => 'Commandes récentes';
  @override
  String get pendingOrders => 'Commandes en attente: ';
  @override
  String get deliveryToll => 'Livraison Péage: ';
  /// [Shop]
  @override
  String get shop => 'Boutique';
  @override
  String get name => 'Nom';
  @override
  String get description => 'Description';
  @override
  String get category => 'Catégorie';
  @override
  String get categories => 'Catégories';
  @override
  Map<int, String> get categoriesMap => {
    0: 'Mode',
    1: 'Téléphones portables',
    2: 'Jeux vidéo',
    3: 'Beauté',
    4: 'Automobile',
    5: 'Équipements sportifs',
    6: 'Ouvrages',
    7: 'Autre',
  };
  @override
  String get yourShops => 'Mes boutiques';
  @override
  String get addShop => 'Ajouter une boutique';
  @override
  String get newShop => 'Nouvelle Boutique';
  @override
  String get newShopMessage => 'La création d\'une boutique existante avec des adresses différentes reste possible tant que le propriétaire reste le même.';
  @override
  String get editShop => 'Modifier boutique';
  @override
  String get freezeShop => 'Geler boutique';
  @override
  String get freezeShopMessage => 'Si vous souhaitez fermer temporairement votre boutique, peut-être prendre des vacances pendant quelques jours, pensez à la congeler ❄.';
  @override
  String get deleteShop => 'Supprimer la boutique';
  @override
  String get deleteShopMessage => "Avertissement : Il s'agit d'une action potentiellement destructrice.";
  @override
  String get reportShop => 'Report Shop';
  @override
  String get aboutShop => 'Sur la Boutique';

  /// [ShopAdderScreen] and [ShopEditScreen]
  @override
  String get createANewShop => 'Créer une nouvelle boutique';
  @override
  String get updateShop => 'Modifier la boutique';
  @override
  String get shopOwner => 'Propriétaire de la boutique';
  @override
  String get shopDetails => 'Détails de le boutique';
  @override
  String get hintShopName => 'Donner un nom à votre boutique';
  @override
  String get hintShopCategory => 'Selectionner une catégorie';
  @override
  String get hintShopDescription => 'Donner une description à votre boutique';
  @override
  String get shopAddress => 'Addresse de la boutique';
  @override
  String get hintShopAddress => 'Selectionner une addresse';
  @override
  String get shopCoverImage => 'Donner une image';

  /// [Product]
  // common
  @override
  String get product => 'Produit';
  @override
  String get brand => 'Marque';
  @override
  String get price => 'Prix';
  @override
  String get quantity => 'Quantité';
  @override
  String get outOfStock => 'Out of Stock!';
  @override
  String get likes => 'J\'aime';
  @override
  String get sells => 'Ventes';
  @override
  String get rating => 'Note';
  @override
  String get aboutProduct => 'Sur le Produit';
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
  String get products => 'Produits';
  @override
  String get addProduct => 'Ajouter produit';
  @override
  String get newProduct => 'Nouveau produit';
  @override
  String get productDetails => 'Details du produit';
  @override
  String get editProduct => 'Modifier Produit';
  @override
  String get deleteProduct => 'Supprimer Produit';
  @override
  String get deleteProductMessage => "Avertissement : Il s'agit d'une action potentiellement destructrice.";

  /// [ProductAdderScreen] and [ProductEditScreen]
  @override
  String get createNewProduct => 'Créer un nouveau produit';
  @override
  String get updateProduct => 'Mettre à jour un produit';
  @override
  String get hintProductShop => 'Veuilez choisir la boutique de votre produit';
  @override
  String get hintProductName => 'Donner un nom au produit';
  @override
  String get hintProductBrand => 'Il est de quel marque';
  @override
  String get hintProductDescription => 'Décrire votre produit';
  @override
  String get yourOffer => 'Votre offre';
  @override
  String get hintProductPrice => 'Prix d\'une unité ';
  @override
  String get hintProductQuantity => 'Quantité disponible';
  @override
  String get productImages => 'Images du produit';
}
