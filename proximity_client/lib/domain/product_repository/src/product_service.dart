import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/data_persistence/data_persistence.dart';
import 'package:proximity_client/domain/product_repository/product_repository.dart';

class ProductService with ChangeNotifier {
  late List<Product> _products = [
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
  ];
  late List<Product> _searchResults;
  late List<Product> _todayDeals;
  late Set<Product> _wishList;
  late List<String> _ads;

  // get methods
  List<Product> get products => _products;

  List<Product> get searchResults => _searchResults;

  List<Product> get todayDeals => _todayDeals;

  List<Product> get wishList => _wishList.toList();

  List<String> get ads => _ads;

  ProductService() {
    // _products = [];
    _searchResults = [];
    _todayDeals = [];
    _wishList = <Product>{};
    _ads = [];
    getProximityProducts();
    getTodayDeals();
    getAds();
  }

  /// GET methods
  Future searchProducts(String query) async {
    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    // String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
      var res = await dio.get(BASE_API_URL +
          '/search/aroundme/?radius=24444&latitude=40.719296&langitude=-73.99279&name=$query');
      if (res.statusCode == 200) {
        _searchResults = [];
        _searchResults.addAll(Product.productsFromJsonList(res.data));
        notifyListeners();
      }
    } on DioError catch (e) {
      if (e.response != null) {
        /// Toast Message to print the message
      } else {
        /// Error due to setting up or sending the request
      }
    }
  }

  Future getProximityProducts() async {
    /// open hive box
    ///
    var credentialsBox = Boxes.getCredentials();
    credentialsBox.put('first_time', false);

    // String _id = credentialsBox.get('id');
    String? _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();

      dio.options.headers["token"] = "Bearer $_token";

      var res = await dio.get(BASE_API_URL +
          '/search/product/?radius=24444&latitude=48.92920&langitude=2.31860239058733');
      if (res.statusCode == 200) {
        //   _products = [];
        _products.addAll(Product.productsFromJsonList(res.data));
        notifyListeners();
      }
    } on DioError catch (e) {
      if (e.response != null) {
        /// Toast Message to print the message
        print('${e.response!}');
      } else {
        /// Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }
  }

  Future getTodayDeals() async {
    Future.delayed(const Duration(milliseconds: 6200), () {
      _todayDeals.addAll(_products.where((element) => (element.discount != 0)));
      notifyListeners();
    });
  }

  Future<Product?> getProduct(String id) async {
    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    // String _id = credentialsBox.get('id');
    String? _token = credentialsBox.get('token');

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer ";
      var res = await dio.get(BASE_API_URL + '/product/$id');

      if (res.statusCode == 200) {
        final int _index = _products.indexWhere((element) => element.id == id);
        _products[_index] = Product.fromJson(res.data);
        notifyListeners();
      }
    } on DioError catch (e) {
      if (e.response != null) {
        /// Toast Message to print the message
        print('${e.response!}');
      } else {
        /// Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }
    notifyListeners();
  }

  Future getAds() async {
    // var res = await Dio()
    //     .get(CLIENT_API_URL + '/client/product',
    //     //queryParameters: {'_i': 0},
    //     /*options: Options(headers: {
    //       Headers.wwwAuthenticateHeader: {
    //         accessToken: accessToken,
    //         refreshToken: refreshToken
    //       }
    //     })*/)
    //     .catchError((err) {
    //   print(err);
    //   throw err;
    // });
    // _products =
    //     res.data['products'].map<Product>((product) => Product.fromJson(product)).toList();
    // notifyListeners();

    Future.delayed(const Duration(milliseconds: 3200), () {
      _ads.addAll([
        'assets/img/ads/ad_1.png',
        'assets/img/ads/ad_2.png',
        'assets/img/ads/ad_3.png',
        'assets/img/ads/ad_4.png',
        'assets/img/ads/ad_5.png',
      ]);
      notifyListeners();
    });
  }

  Future reportProduct(BuildContext context, String id, String message) async {
    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    // String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// prepare the dataForm
    var data = {"message": message};

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
      var res =
          await dio.post(BASE_API_URL + '/product/report/$id', data: data);

      if (res.statusCode == 200) {
        Navigator.pop(context);
        ToastSnackbar().showToast(message: 'Product Successfully Reported');
        notifyListeners();
      }
    } on DioError catch (e) {
      if (e.response != null) {
        /// Toast Message to print the message
        print('${e.response!}');
      } else {
        /// Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }
    notifyListeners();
  }

// // essential methods for the UI
// bool isOutOfStock(String id) {
//   return (products.firstWhere((element) => element.id == id).quantity ==
//       null) ||
//       (products.firstWhere((element) => element.id == id).quantity == 0);
// }
}
