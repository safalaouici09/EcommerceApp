import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:proximity/config/backend.dart';
import 'package:proximity_client/domain/data_persistence/data_persistence.dart';
import 'package:proximity_client/domain/store_repository/store_repository.dart';
import 'package:proximity_client/domain/product_repository/product_repository.dart';
import 'package:proximity_client/domain/user_repository/models/address_item_model.dart';

class StoreService with ChangeNotifier {
  String _storeId = '';
  Store? _store;
  late List<Store>? _stores = [];
  List<Product>? _products;

  late List<Store> _searchResults;
  String _query = "";

  // essential values for the UI
  // loading to render circular progress bar when waiting for server response
  bool _loading = false;

  // getters
  String get storeId => _storeId;

  Store? get store => _store;

  List<Product>? get products => _products;
  bool get loading => _loading;
  String get query => _query;

  List<Store> get searchResults => _searchResults;
  // List<Store> get stores => _stores;

  // setters
  set storeId(String idShop) {
    _storeId = idShop;
    notifyListeners();
  }

  set store(Store? store) {
    _store = store;
    notifyListeners();
  }

  set products(List<Product>? products) {
    _products = products;
    notifyListeners();
  }

  StoreService() {
    _storeId = storeId;
    getStore();
  }

  loadStore(StoreProxy storeProxy) {
    if (_storeId != storeProxy.idStore) {
      _storeId = storeProxy.idStore;
      getStore();
      getStoreProducts();
    }
  }

  Future<void> getStore({String? storeFetchId = null}) async {
    if (storeFetchId != null) {
      _storeId = storeFetchId;
      notifyListeners();
    }
    _store = null;
    _loading = true;
    notifyListeners();

    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    // String _id = credentialsBox.get('id');
    // String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer ";
      print('/store/$_storeId');
      var res = await dio.get(BASE_API_URL + '/store/$_storeId');
      if (res.statusCode == 200) {
        _store = Store.fromJson(res.data);
        print('get store');
        // print(_store!.workingTime!.fixedHours.toString());
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

  Future<void> getStoreProducts() async {
    _products = null;
    _loading = true;
    notifyListeners();

    /// open hive boxP
    var credentialsBox = Boxes.getCredentials();
    // String _id = credentialsBox.get('id');
    // String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer ";
      var res = await dio.post(BASE_API_URL + '/product/store/$_storeId');
      _loading = false;
      notifyListeners();
      if (res.statusCode == 200) {
        _products = [];
        _products!.addAll(Product.productsFromJsonList(res.data));
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

  Future searchStores({String name = ""}) async {
    /// open hive box
    ///
    ///
    _query = name;
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
          '/search/?radius=${radius.toString()}&latitude=${latitude.toString()}&langitude=${langitude.toString()}&name=${(name)}');
      print(res.statusCode.toString());
      if (res.statusCode == 200) {
        _searchResults = [];
        _searchResults.addAll(Store.storesFromJsonList(res.data));

        print(_searchResults.length.toString());
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
}
// // essential methods for the UI
// bool isOutOfStock(String id) {
//   return (products.firstWhere((element) => element.id == id).quantity ==
//       null) ||
//       (products.firstWhere((element) => element.id == id).quantity == 0);
// }


