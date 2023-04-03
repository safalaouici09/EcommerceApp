import 'package:proximity/domain_repository/models/address_model.dart';
import 'package:proximity_client/domain/store_repository/store_repository.dart';

class Store {
  String? id;
  String? name;
  String? description;
  double? rating;
  String? phoneNumber;
  String? ownerPhoneNumber;
  dynamic image;
  Address? address;
  Policy? policy;
  List<Category>? categories;
  bool? isActive;

  // List<Offer>? offers;
  // List<Flashdeal>? flashdeals;
  List<dynamic>? followers;

  Store(
      {this.id,
      this.name,
      this.description,
      this.rating,
      this.phoneNumber,
      this.ownerPhoneNumber,
      this.image,
      this.address,
      this.policy,
      this.categories,
      this.followers,
      this.isActive});

  Store.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['_id'],
        name = parsedJson['name'],
        description = parsedJson['description'],
        rating = (parsedJson['ratingSum'] ?? 0.0).toDouble(),
        phoneNumber = '0745431397',
        ownerPhoneNumber = '0745431397',
        image = parsedJson['imageUrl'],
        followers = parsedJson['followers'],
        isActive = parsedJson['isActive'],
        /* policy = Policy(
            shippingMethods: [
              if (parsedJson['policies']['delivery'] ?? false)
                ShippingMethod.delivery,
              if (parsedJson['policies']['selfPickUp'] == "total")
                ShippingMethod.selfPickupTotal
              else if (parsedJson['policies']['selfPickUp'] == "partial")
                ShippingMethod.selfPickupPartial
              else if (parsedJson['policies']['selfPickUp'] == "free")
                ShippingMethod.selfPickupFree
            ],
            tax: (parsedJson['policies']['tax'] ?? 0.0).toDouble(),
            selfPickUpPrice: (parsedJson['policies']['selfPickUp'] == "free")
                ? 0.0
                : (parsedJson['policies']['selfPickUpPrice'] ?? 0.0).toDouble(),
            openWeekend: parsedJson['policies']['openWeekend'] ?? false,
            openNight: parsedJson['policies']['openNight'] ?? false,
            openDay: parsedJson['policies']['openDay'] ?? false,
            openTime: parsedJson['policies']['openTime'] ?? false,
            closeTime: parsedJson['policies']['closeTime'] ?? false),*/
        address = Address(
          lat: (parsedJson['location']['coordinates'][1] ?? 0).toDouble(),
          lng: (parsedJson['location']['coordinates'][0] ?? 0).toDouble(),
          city: parsedJson['address']['city'],
          streetName: parsedJson['address']['streetName'],
          postalCode: parsedJson['address']['postalCode'],
          countryCode: parsedJson['address']['countryCode'],
          countryName: parsedJson['address']['country'],
          fullAddress: parsedJson['address']['fullAdress'],
          locality: parsedJson['address']['region'],
          region: parsedJson['address']['region'],
        ),
        categories = null;

  static List<Store> storesFromJsonList(List<dynamic> parsedJson) {
    List<Store> _list = [];
    for (int i = 0; i < parsedJson.length; i++) {
      _list.add(Store.fromJson(parsedJson[i]));
    }
    return _list;
  }

  bool allFetched() {
    return ((id != null) &&
        (name != null) &&
        (description != null) &&
        (rating != null) &&
        (image != null) &&
        (address != null) &&
        (policy != null));
  }

  static List<Store> stores = [
    Store(
      id: '0',
      name: 'XIAOMI Store',
      description:
          'Xiaomi, a global company producing quality products at honest pricing. Get Xiaomi phones and accessories including Xiaomi 12 Pro✓Redmi Note 11S 5G✓Redmi',
      address: Address(
          streetName: '33 Rue Gaston Febus, Montpellier, France',
          lat: 34.6,
          lng: -4.1),
      policy: Policy.policy,
      rating: 3.7,
      phoneNumber: '+213560834326',
      ownerPhoneNumber: '+213560834326',
      followers: [],
    ),
    Store(
      id: '1',
      name: 'Adidas',
      description:
          "Adidas AG is a German multinational corporation, founded and headquartered in Herzogenaurach, Germany, that designs and manufactures shoes, clothing and accessories. It is the largest sportswear manufacturer in Europe, and the second largest in the world, after Nike.",
      address: Address(
          streetName: 'Rue Cinq Maisons, Montpellier, France',
          lat: 34.9,
          lng: -3.7),
      policy: Policy.policy,
      rating: 4.2,
      phoneNumber: '+213560834326',
      ownerPhoneNumber: '+213560834326',
      followers: [],
    ),
    Store(
      id: '2',
      name: 'GameStop',
      description:
          "GameStop Corp. is a video game, consumer electronics, and gaming merchandise retailer. The company is headquartered in Grapevine, Texas, and is the largest video game retailer worldwide.",
      address: Address(
          streetName: 'Centre Commercial Les pins, Montpellier, France',
          lat: 34.9,
          lng: -3.7),
      policy: Policy.policy,
      rating: 4.2,
      phoneNumber: '+213560834326',
      ownerPhoneNumber: '+213560834326',
      followers: [],
    ),
    Store(
      id: '3',
      name: 'Timberland',
      description:
          "Timberland LLC is an American manufacturer and retailer of outdoors wear, with a focus on footwear, which is often known colloquially as 'Timbs.' It is owned by VF Corporation.\nTimberland footwear is marketed towards people intending outdoor use.\nThe company also sells apparel, such as clothes, watches, glasses, sunglasses, and leather goods.",
      address: Address(
          streetName: 'Centre Commercial Les pins, Montpellier, France',
          lat: 34.9,
          lng: -3.7),
      policy: Policy.policy,
      rating: 4.2,
      phoneNumber: '+213560834326',
      ownerPhoneNumber: '+213560834326',
      followers: [],
    ),
    Store(
      id: '4',
      name: 'Apple Store',
      description: "We sell the latest Apple stores.",
      image: '',
      address: Address(
          streetName: 'Centre Commercial Les pins, Montpellier, France',
          lat: 34.9,
          lng: -3.7),
      policy: Policy.policy,
      rating: 4.2,
      phoneNumber: '+213560834326',
      ownerPhoneNumber: '+213560834326',
      followers: [],
    ),
  ];
}
