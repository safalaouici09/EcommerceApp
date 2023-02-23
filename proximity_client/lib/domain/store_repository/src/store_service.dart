import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:proximity/config/backend.dart';
import 'package:proximity_client/domain/data_persistence/data_persistence.dart';
import 'package:proximity_client/domain/store_repository/store_repository.dart';
import 'package:proximity_client/domain/product_repository/product_repository.dart';

class StoreService with ChangeNotifier {
  String _storeId = '';
  Store? _store;
  List<Product>? _products;

  // essential values for the UI
  // loading to render circular progress bar when waiting for server response
  bool _loading = false;

  // getters
  String get storeId => _storeId;

  Store? get store => _store;

  List<Product>? get products => _products;

  bool get loading => _loading;

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

  Future<void> getStore() async {
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
      var res = await dio.get(BASE_API_URL + '/store/$_storeId');
      if (res.statusCode == 200) {
        _store = Store.fromJson(res.data);
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
      var res = await dio.get(BASE_API_URL + '/product/store/$_storeId');
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
}
