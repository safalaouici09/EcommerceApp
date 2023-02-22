import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/data_persistence/data_persistence.dart';
import 'package:proximity_client/domain/product_repository/product_repository.dart';

class ProductService with ChangeNotifier {
  late List<Product> _products;
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
    _products = [];
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
    print("rs1:");
    print("rs2:");
    // String _id = credentialsBox.get('id');
    //String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      print("rs3:");

      dio.options.headers["token"] = "Bearer " "";

      var res = await dio.get(BASE_API_URL +
          '/search/product/?radius=24444&latitude=48.92920&langitude=2.31860239058733');
      print("rs4:");
      print(res.statusCode.toString());
      print(res.data);
      if (res.statusCode == 200) {
        _products = [];
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
    // String _token = credentialsBox.get('token');

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
