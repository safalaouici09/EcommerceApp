import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/data_persistence/data_persistence.dart';
import 'package:proximity_client/domain/product_repository/models/policy_model.dart';
import 'package:proximity_client/domain/product_repository/product_repository.dart';
import 'package:proximity_client/domain/user_repository/models/address_item_model.dart';
import 'dart:convert';

class ProductService with ChangeNotifier {
  late List<Product> _products = [];
  late List<Product> _searchResults;
  late List<Product> _todayDeals;
  late Set<Product> _wishList;
  late List<String> _ads;
  String _query = "";

  //final Map<String, String>? _selectedOptions = {};

  // get methods
  late Map<String, String>? _selectedOptions = {};
  Map<String, String>? get selectedOptions => _selectedOptions;

  List<Product> get products => _products;

  List<Product> get searchResults => _searchResults;

  List<Product> get todayDeals => _todayDeals;

  List<Product> get wishList => _wishList.toList();

  String get query => _query;

  List<String> get ads => _ads;
  //Map<String, String>? get selectedOptions => _selectedOptions;

  bool? _loadingProduct = false;

  bool? get loadingProduct => _loadingProduct;

  bool? _loadingProductList = false;

  bool? get loadingProductList => _loadingProductList;
  bool? _loadingdealsList = false;

  bool? get loadingdealsList => _loadingdealsList;

  ProductService() {
    // _products = [];
    _searchResults = [];
    _todayDeals = [];
    _wishList = <Product>{};
    _ads = [];
    _products = [];
    getProximityProducts();
    getTodayDeals();
    getAds();
  }

  /// GET methods
  Future searchProducts(String query) async {
    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    // String _id = credentialsBox.get('id');F
    String? _token = credentialsBox.get('token');
    AddressItem? _adresse = credentialsBox.get('address');
    print({"adreesse": _adresse});

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

  Future getProximityProducts({String name = ""}) async {
    /// open hive box
    ///
    ///
    print("get products list");
    _query = name;
    _loadingProductList = true;
    notifyListeners();
    var credentialsBox = Boxes.getCredentials();
    credentialsBox.put('first_time', false);
    AddressItem _adresse = credentialsBox.get('address');
    var latitude = 0.0;
    var langitude = 0.0;
    var radius = 0;
    /* print({"address": _adresse});
    if (_adresse != null) {
      _adresse = json.decode(_adresse);
      if (_adresse["lat"] != null) {
        latitude = _adresse["lat"];
      }
      if (_adresse["lng"] != null) {
        langitude = _adresse["lng"];
      }
    }*/
    if (_adresse != null) {
      // _adresse = json.decode(_adresse);
      if (_adresse.lat != null) {
        latitude = _adresse.lat!;
      }
      if (_adresse.lng != null) {
        langitude = _adresse.lng!;
      }
    }

    // String _id = credentialsBox.get('id');
    String? _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();

      dio.options.headers["token"] = "Bearer $_token";

      var res = await dio.get(BASE_API_URL +
          '/search/product/?radius=${radius.toString()}&latitude=${latitude.toString()}&langitude=${langitude.toString()}&name=${(name)}');

      if (res.statusCode == 200) {
        if (name == "") {
          _products = [];

          _products.addAll(Product.productsFromJsonList(res.data));
          _todayDeals = [];
          _todayDeals
              .addAll(_products.where((element) => (element.discount != 0)));
        } else {
          _searchResults = [];
          _searchResults.addAll(Product.productsFromJsonList(res.data));
        }

        print(_products.length.toString());
        notifyListeners();
      }
      _loadingProductList = false;
      notifyListeners();
    } on DioError catch (e) {
      if (e.response != null) {
        /// Toast Message to print the message
        print('${e.response!}');
      } else {
        /// Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }

      _loadingProductList = false;
      notifyListeners();
    }
  }

  Future getTodayDeals() async {
    _loadingdealsList = true;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 1000), () {
      _todayDeals = [];
      _todayDeals.addAll(_products.where((element) => (element.discount != 0)));
      _loadingdealsList = false;
      notifyListeners();
    });
  }

  Map<String, List<String>>? getCharacteristics(Product product) {
    Map<String, List<String>>? _characteristics = {};

    for (ProductVariant variant in product.variants!) {
      if (variant.characteristics != null) {
        for (var characteristic in variant.characteristics!) {
          final name = characteristic['name'];
          final value = characteristic['value'];

          if (_characteristics![name] == null) {
            _characteristics![name] = [value];
          } else if (!_characteristics![name]!.contains(value)) {
            _characteristics![name]!.add(value);
          }
        }
      }
    }
    return _characteristics;
  }

  Future<Product?> getProduct(String id) async {
    /// open hive box
    _loadingProduct = true;
    notifyListeners();
    var credentialsBox = Boxes.getCredentials();
    // String _id = credentialsBox.get('id');
    String? _token = credentialsBox.get('token');

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer ";
      print('/product/$id');
      var res = await dio.get(BASE_API_URL + '/product/$id');

      if (res.statusCode == 200) {
        _selectedOptions = {};
        final int _index = _products.indexWhere((element) => element.id == id);
        print(_index);
        _products[_index] = Product.fromJson(res.data);
        print(res.data);

        _loadingProduct = false;
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

    _loadingProduct = false;
    notifyListeners();
    return null;
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

    Future.delayed(const Duration(milliseconds: 1000), () {
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

//filter variants
  List<ProductVariant> filterVariants(List<ProductVariant> variants) {
    print(_selectedOptions.toString());
    if (_selectedOptions == null || _selectedOptions!.isEmpty) {
      // If no options are selected, return the original list of variants
      return variants;
    }
    List<ProductVariant> filteredVariants = variants.where((variant) {
      if (variant.characteristics != null) {
        for (var entry in _selectedOptions!.entries) {
          final selectedCharacteristic = entry.key;
          final selectedValue = entry.value;

          // Check if the variant has the selected characteristic with the selected value
          bool hasSelectedCharacteristic =
              variant.characteristics!.any((characteristic) {
            return characteristic["name"] == selectedCharacteristic &&
                characteristic["value"] == selectedValue;
          });

          // If any of the selected options does not match the variant's characteristics, return false
          if (!hasSelectedCharacteristic) {
            return false;
          }
        }
        // If all selected options match the variant's characteristics, return true
        return true;
      } else {
        return false;
      }
    }).toList();

    // Notify the listener after filtering the variants
    notifyListeners();

    return filteredVariants;
  }

  /*List<ProductVariant> filterVariants(
    List<ProductVariant> variants,
  ) {
    List<ProductVariant> filteredVariants = variants.where((variant) {
      if (variant.characteristics != null) {
        for (var characteristic in variant.characteristics!) {
          if (_selectedOptions!.containsKey(characteristic["name"]) &&
              _selectedOptions![characteristic["name"]] !=
                  characteristic["value"]) {
            // If any selected option does not match the variant's characteristic, return false
            return false;
          }
        }
        // If all selected options match the variant's characteristics, return true
        return true;
      } else {
        return false;
      }
    }).toList();

    // Notify the listener after filtering the variants
    notifyListeners();

    return filteredVariants;
  }*/

  addFilter(String key, String value) {
    _selectedOptions![key] = value;
    notifyListeners();
  }

  void deleteFilter(String key) {
    _selectedOptions!.remove(key);
    notifyListeners();
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
}
