import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:proximity/config/backend.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/data_persistence/data_persistence.dart';
import 'package:proximity_client/domain/store_repository/store_repository.dart';
import 'package:proximity_client/domain/product_repository/product_repository.dart';
import 'package:proximity_client/domain/user_repository/models/address_item_model.dart';

class StoreService with ChangeNotifier {
  String _storeId = '';
  Store? _store;
  TextEditingController _cityController = TextEditingController();

  Address _storeAddress = Address();

  Address _searchAddress = Address();
  late List<Store>? _stores = [];
  List<Product>? _products;
  late List<Store> _filterSearchResults = [];
  String _searchFilter = '';
  String get searchFilter => _searchFilter;
  List<Store> get filterSearchResults => _filterSearchResults;

  late List<Store> _searchResults = [];
  String _query = "";

  // essential values for the UI
  // loading to render circular progress bar when waiting for server response
  bool _loading = false;

  // getters
  TextEditingController get cityController => _cityController;
  String get storeId => _storeId;

  Store? get store => _store;
  Address get storeAddress => _storeAddress;
  Address get searchAddress => _searchAddress;
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

  String? getSearchAddresse() {
    if (_searchAddress.city == null) {
      var credentialsBox = Boxes.getCredentials();

      AddressItem _adresse = credentialsBox.get('address');
      _storeAddress.city = _adresse.city;
      _storeAddress.lat = _adresse.lat;
      _storeAddress.lng = _adresse.lng;
      return _storeAddress.city;
    } else {
      return _searchAddress.city!;
    }
  }

  void changeSearchAddresse(Address newAddress) {
    _searchAddress = newAddress;
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

  void changeStoreAddress(Address newAddress) {
    _storeAddress = newAddress;
    notifyListeners();
  }

  void changeCity(String value) {
    _searchAddress.city = value;
    _cityController.text = value;

    notifyListeners();
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

  addSearchFilter(String value) {
    _searchFilter = value;
    notifyListeners();
  }

  deleteSearchFilter() {
    _searchFilter = '';
    notifyListeners();
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
    _searchResults.add(Store(
        id: '1',
        name: 'Nike Store',
        description:
            'Shop the latest Nike athletic shoes, apparel, and accessories. Find your favorite sports gear for running, basketball, and more.',
        address: Address(
            streetName: '123 Main Street, Anytown, USA',
            lat: 40.1234,
            lng: -75.5678),
        category: 'Sports & Outdoors'));
    _searchResults.add(Store(
        id: '3',
        name: 'Bookworm Bookstore',
        description:
            'Discover a wide range of books from various genres at Bookworm Bookstore. Get lost in captivating stories and expand your knowledge.',
        address: Address(
            streetName: '789 Oak Road, Readington, Australia',
            lat: -33.4567,
            lng: 150.9876),
        category: 'Accessoires'));

    /// dataForm is already a parameter

    /*  /// post the dataForm via dio call
    try {
      Dio dio = Dio();

      dio.options.headers["token"] = "Bearer $_token";

      var res = await dio.get(BASE_API_URL +
          '/search/?radius=${radius.toString()}&latitude=${latitude.toString()}&langitude=${langitude.toString()}&name=${(name)}');
      print("search" + res.statusCode.toString());
      if (res.statusCode == 200) {
        _searchResults = [];
        _searchResults.addAll(Store.storesFromJsonList(res.data));
        _searchResults.add(Store(
            id: '1',
            name: 'Nike Store',
            description:
                'Shop the latest Nike athletic shoes, apparel, and accessories. Find your favorite sports gear for running, basketball, and more.',
            address: Address(
                streetName: '123 Main Street, Anytown, USA',
                lat: 40.1234,
                lng: -75.5678),
            category: 'Sports & Outdoors'));
        _searchResults.add(Store(
            id: '3',
            name: 'Bookworm Bookstore',
            description:
                'Discover a wide range of books from various genres at Bookworm Bookstore. Get lost in captivating stories and expand your knowledge.',
            address: Address(
                streetName: '789 Oak Road, Readington, Australia',
                lat: -33.4567,
                lng: 150.9876),
            category: 'Accessoires'));

        print("search" + _searchResults.length.toString());
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
    }*/
  }

  void filterStoresByCategorie() {
    _filterSearchResults = [];
    for (Store store in _searchResults) {
      print('cat' + store.category.toString());
      if (store.category == searchFilter) {
        _filterSearchResults.add(store);
      }
    }
    notifyListeners();
  }

  void filterStoresByAddress(String value) {
    _searchResults.where((store) {
      Address? address = store.address;
      return address!.lat?.toString().contains(value) == true ||
          address.lng?.toString().contains(value) == true ||
          address.city?.contains(value) == true ||
          address.fullAddress!.contains(value) == true ||
          address.streetName?.contains(value) == true ||
          address.postalCode?.contains(value) == true ||
          address.countryCode?.contains(value) == true ||
          address.countryName?.contains(value) == true ||
          address.locality?.contains(value) == true ||
          address.region?.contains(value) == true;
    }).toList();
    notifyListeners();
  }
}
// // essential methods for the UI
// bool isOutOfStock(String id) {
//   return (products.firstWhere((element) => element.id == id).quantity ==
//       null) ||
//       (products.firstWhere((element) => element.id == id).quantity == 0);
// }


