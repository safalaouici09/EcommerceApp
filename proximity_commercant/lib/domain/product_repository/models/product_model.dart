import 'package:proximity_commercant/domain/product_repository/models/offer_model.dart';

import 'product_variant_model.dart';
import 'package:proximity/config/backend.dart';

class Product {
  String? id;
  String? name;
  String? description;
  double? price;
  int? quantity;
  double discount;
  DateTime? discountEndDate;
  List<dynamic>? images;
  List<ProductVariant>? variants;
  String? categoryId;
  String? categoryName;
  List<dynamic>? tags;
  String? storeId;
  String? offer_id;

  Product(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.quantity,
      this.discount = 0.0,
      this.discountEndDate,
      this.images,
      this.variants,
      this.categoryId,
      this.categoryName,
      // this.tags,

      this.storeId,
      this.offer_id});

  Product.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['_id'],
        name = parsedJson['name'],
        description = parsedJson['description'],
        price = parsedJson['price'].toDouble(),
        quantity = parsedJson['quantity'],
        categoryId = parsedJson['categoryId'],
        images =
            parsedJson['images'].map((el) => BASE_IMG_URL + '/' + el).toList(),
        tags = parsedJson['tags'],
        variants =
            ProductVariant.productVariantsFromJsonList(parsedJson['variants']),
        storeId = parsedJson['storeId'],
        discount = parsedJson['discount'].toDouble(),
        discountEndDate = DateTime.parse(parsedJson['discountExpiration']),
        offer_id = parsedJson['offer'];

  static List<Product> productsFromJsonList(List<dynamic> parsedJson) {
    List<Product> _list = [];
    for (int i = 0; i < parsedJson.length; i++) {
      _list.add(Product.fromJson(parsedJson[i]));
    }
    return _list;
  }

  bool allFetched() {
    return ((id != null) &&
        (name != null) &&
        (description != null) &&
        (price != null) &&
        (discountEndDate != null) &&
        (images != null) &&
        (variants != null) &&
        (categoryName != null) &&
        (storeId != null));
  }

  double getPrice() {
    return double.parse((price! * (1 - discount)).toStringAsFixed(2));
  }

  static List<Product> products = [
    Product(
        id: '0',
        name:
            'Xiaomi Cleargrass -compatible Alarm Clock smart Control Temperature Humidity Display LCD Screen Adjustable Nightlight - gray',
        description: '''Main Features

Description :

ClearGrass CGD1 Bluetooth No Button Alarm Clock Mijia APP Control Temperature Humidity Display LCD Screen Adjustable Nightlight

- Simple Buttonless Design
The product can be pressed as a whole, which realizes no button function, and the operation is very interesting. The internal design of the silicone base has a comfortable pressing feel and a simple appearance design, which can be well integrated in various places in the home.

- Custom Personalized Alarm Clock
Each time you connect your phone via Bluetooth, the time is automatically synchronized and you can easily set the time. You can set 16 groups of alarm clocks, and each group of alarm clocks can be set for snooze function, which is very simple. 8 ringtones optional.

- Temperature And Humidity Display
Using Swiss Sensirion sensor, the temperature measurement accuracy is ± 0.2 ℃, the humidity measurement accuracy is ± 2% RH, and the temperature and humidity changes are sensitively sensed.

- Tap To Light The Night Light
Press the alarm clock, the backlight turns on, you can check the time clearly even at night.

- Adjust The Backlight At Any Time
The intensity of the backlight can be adjusted in different periods, and the duration of the backlight can also be adjusted, from completely off to 30 seconds.

- Comfortable Smart Little Housekeeper
Cooperate with other Mijia equipment to realize automatic adjustment of indoor temperature and humidity. For example: if the temperature is lower than 20 ℃, the heater will be turned on automatically.''',
        price: 19.99,
        discount: 0.1,
        discountEndDate: DateTime.now()
            .add(const Duration(days: 31, hours: 23, minutes: 48, seconds: 3)),
        images: [
          'https://i.ibb.co/nL0M1L7/product-0-0.png',
          'https://i.ibb.co/6mjY1WD/product-0-1.png',
          'https://i.ibb.co/Sypdpj5/product-0-2.png',
          'https://i.ibb.co/ZNP8nJd/product-0-3.png',
        ],
        storeId: '0',
        variants: [
          ProductVariant(
              id: '0-0',
              variantName: '',
              characteristics: [
                {"name": "Color", "value": "Beige"},
                {"name": "Language", "value": "Français"}
              ],
              image: 'https://i.ibb.co/N2d3vP3/product-0-variant-0.png',
              quantity: 5654),
          ProductVariant(
              id: '0-1',
              variantName: '',
              characteristics: [
                {"name": "Color", "value": "Beige"},
                {"name": "Language", "value": "English"}
              ],
              image: 'https://i.ibb.co/RQwZrX8/product-0-variant-1.png',
              quantity: 5654),
          ProductVariant(
              id: '0-2',
              variantName: '',
              characteristics: [
                {"name": "Color", "value": "Mint Green"},
                {"name": "Language", "value": "Français"}
              ],
              image: 'https://i.ibb.co/g7Y7yvc/product-0-variant-2.png',
              quantity: 5654),
          ProductVariant(
              id: '0-3',
              variantName: '',
              characteristics: [
                {"name": "Color", "value": "Mint Green"},
                {"name": "Language", "value": "English"}
              ],
              image: 'https://i.ibb.co/7bN9KJk/product-0-variant-3.png',
              quantity: 5654),
          ProductVariant(
              id: '0-4',
              variantName: '',
              characteristics: [
                {"name": "Color", "value": "Peach"},
                {"name": "Language", "value": "Français"}
              ],
              image: 'https://i.ibb.co/0BZSLgM/product-0-variant-4.png',
              quantity: 5654),
          ProductVariant(
              id: '0-5',
              variantName: '',
              characteristics: [
                {"name": "Color", "value": "Peach"},
                {"name": "Language", "value": "English"}
              ],
              image: 'https://i.ibb.co/CbYfPVL/product-0-variant-5.png',
              quantity: 5654),
          ProductVariant(
              id: '0-6',
              variantName: '',
              characteristics: [
                {"name": "Color", "value": "Blue"},
                {"name": "Language", "value": "Français"}
              ],
              image: 'https://i.ibb.co/FxKnM1p/product-0-variant-6.png',
              quantity: 5654),
          ProductVariant(
              id: '0-7',
              variantName: '',
              characteristics: [
                {"name": "Color", "value": "Blue"},
                {"name": "Language", "value": "English"}
              ],
              image: 'https://i.ibb.co/7zwP1M9/product-0-variant-7.png',
              quantity: 5654)
        ]),
    Product(
        id: '1',
        name: 'Nintendo Switch™ Family - Nintendo',
        description:
            "The Nintendo Switch (ニ ン テ ン ド ー ス イ ッ チ, Nintendō Suitchi) is a video game console produced by Nintendo, succeeding the Wii U.\nIt is the first hybrid console in the history of video games, which could also do as a living room console as a portable console.",
        price: 500.0,
        discount: 1 / 3,
        discountEndDate: DateTime.now()
            .add(const Duration(days: 7, hours: 4, minutes: 48, seconds: 3)),
        images: [
          'https://i.ibb.co/Xpx2N1B/switch1.png',
          'https://i.ibb.co/5M2Nyh2/switch3.png'
        ],
        storeId: '2',
        variants: [
          ProductVariant(
              id: '1-0',
              characteristics: [
                {"name": "Color", "value": "Default"}
              ],
              image: 'https://i.ibb.co/QfdNZHD/product-1-variant-0.png',
              quantity: 5654),
          ProductVariant(
              id: '1-1',
              characteristics: [
                {"name": "Color", "value": "Frost White"}
              ],
              image: 'https://i.ibb.co/D8mV6S4/product-1-variant-1.png',
              quantity: 5654),
          ProductVariant(
              id: '1-2',
              characteristics: [
                {"name": "Color", "value": "Coral"}
              ],
              image: 'https://i.ibb.co/LPdjY8L/product-1-variant-2.png',
              quantity: 5654),
          ProductVariant(
              id: '1-3',
              characteristics: [
                {"name": "Color", "value": "Frost White"}
              ],
              image: 'https://i.ibb.co/HX1Yzrd/product-1-variant-3.png',
              quantity: 5654),
        ]),
    Product(
        id: '2',
        name: 'Playstation 4',
        description:
            "The PlayStation 4 (PS4) is a home video game console developed by Sony Computer Entertainment. ... The console also supports HDR10 High-dynamic-range video and playback of 4K resolution multimedia.",
        price: 340.0,
        discount: 0.0,
        images: ['https://i.ibb.co/TYtFs62/ps4.png'],
        storeId: '2',
        variants: [
          ProductVariant(
              id: '2-0',
              characteristics: [
                {"name": "edition", "value": "PS4 Pro"}
              ],
              image: 'https://i.ibb.co/TYtFs62/ps4.png',
              quantity: 5654)
        ]),
    Product(
        id: '2',
        name: 'Playstation 4',
        description:
            "The PlayStation 4 (PS4) is a home video game console developed by Sony Computer Entertainment. ... The console also supports HDR10 High-dynamic-range video and playback of 4K resolution multimedia.",
        price: 340.0,
        discount: 0.0,
        images: ['https://i.ibb.co/TYtFs62/ps4.png'],
        storeId: '2',
        variants: [
          ProductVariant(
              id: '2-0',
              characteristics: [
                {"name": "edition", "value": "PS4 Pro"}
              ],
              image: 'https://i.ibb.co/TYtFs62/ps4.png',
              quantity: 5654)
        ]),
  ];
}
