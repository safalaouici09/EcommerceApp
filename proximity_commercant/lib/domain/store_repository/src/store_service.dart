<<<<<<< HEAD
import 'dart:math';
import 'dart:developer';
=======
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_commercant/domain/data_persistence/data_persistence.dart';
import 'package:proximity_commercant/domain/store_repository/store_repository.dart';
<<<<<<< HEAD
import 'package:proximity_commercant/ui/pages/home_pages/home_pages.dart';
=======
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705

class StoreService with ChangeNotifier {
  List<Store>? _stores;

  // essential values for the UI
  late bool _loading;
  late bool _formsLoading;

  List<Store>? get stores => _stores;

  bool get loading => _loading;
  bool get formsLoading => _formsLoading;

  set stores(List<Store>? stores) {
    _stores = stores;
    notifyListeners();
  }

  StoreService() {
    _loading = false;
    _formsLoading = false;
    getStores();
  }

  Future<void> getStores() async {
    _loading = true;
    notifyListeners();

    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    // String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');
<<<<<<< HEAD

    String _id = credentialsBox.get('id');
    print("_token : " + _token);
=======
    String _id = credentialsBox.get('id');
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
<<<<<<< HEAD
      var res = await dio.get(BASE_API_URL + '/store/seller/' + _id);
      _loading = false;
      print("stores" + res.toString());
=======
      var res = await dio.get(BASE_API_URL + '/store/seller/'+_id);
      _loading = false;
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
      notifyListeners();
      if (res.statusCode == 200) {
        _stores = [];
        _stores!.addAll(Store.storesFromJsonList(res.data));
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

    // Future.delayed(const Duration(seconds: 4), () {
    //   _stores = [];
    //   _stores!.addAll(Store.stores);
    //   notifyListeners();
    // });

    /*
    var box = Hive.box('myBox');
    var accessToken = box.get('accessToken');
    var refreshToken = box.get('refreshToken');
    var res = await Dio()
        .get(SELLER_API_URL + '/seller/shop',
            queryParameters: {'_i': 0},
            options: Options(headers: {
              Headers.wwwAuthenticateHeader: {
                accessToken: accessToken,
                refreshToken: refreshToken
              }
            }))
        .catchError((err) {
      print(err);
      throw err;
    });
    if (res.data['accessToken'] != null)
      box.put('accessToken', res.data['accessToken']);
    _shops =
        res.data['shops'].map<Shop>((shop) => Shop.fromJson(shop)).toList();
    notifyListeners();
     */
  }

  Store getStoreById(String id) {
    return _stores!.firstWhere((element) => element.id == id);
  }

  Future<void> getStoreByIndex(int index) async {
    /*
    var box = Hive.box('myBox');
    var accessToken = box.get('accessToken');
    var refreshToken = box.get('refreshToken');
    var res = await Dio()
        .get(SELLER_API_URL + '/seller/shop',
            queryParameters: {'_i': _shops[index].id},
            options: Options(headers: {
              Headers.wwwAuthenticateHeader: {
                accessToken: accessToken,
                refreshToken: refreshToken
              }
            }))
        .catchError((err) {
      print(err);
      throw err;
    });
    if (res.data['accessToken'] != null)
      box.put('accessToken', res.data['accessToken']);
    print(res.data['shop']);
    _shops[index].description = Shop.fromJson(res.data['shop']).description;
    notifyListeners();
     */
  }

  Future addStore(BuildContext context, FormData formData) async {
    _formsLoading = true;
    notifyListeners();

    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
<<<<<<< HEAD
      debugPrint("store form");

      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
      formData.fields.add(MapEntry("sellerId", _id));
      var res =
          await dio.post(BASE_API_URL + '/store/createStore', data: formData);

      if (res.statusCode == 200) {
        /// Save new Store Data

        getStores();
        //  stores!.add(Store.fromJson(res.data));

        _formsLoading = false;
        notifyListeners();

        /// Display Results Message
        //  ToastSnackbar().init(context).showToast(
        //      message: "${res.statusMessage}", type: ToastSnackbarType.success);
        Future.delayed(largeAnimationDuration, () {
          notifyListeners();
        });

        // Navigator.pop(context);
=======
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
      formData.fields.add(MapEntry("sellerId", _id));
      var res = await dio.post(BASE_API_URL + '/store/createStore', data: formData);
      if (res.statusCode == 200) {
        /// Save new Store Data
        stores!.add(Store.fromJson(res.data));
        notifyListeners();

        /// Display Results Message
        ToastSnackbar().init(context).showToast(
            message: "${res.statusMessage}", type: ToastSnackbarType.success);
        Navigator.pop(context);
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
      }
    } on DioError catch (e) {
      if (e.response != null) {
        /// Display Error Response
        ToastSnackbar()
            .init(context)
            .showToast(message: "${e.response}", type: ToastSnackbarType.error);
      } else {
        /// Display Error Message
        ToastSnackbar()
            .init(context)
            .showToast(message: e.message, type: ToastSnackbarType.error);
      }
    }
    _formsLoading = false;
    notifyListeners();
  }

<<<<<<< HEAD
  Future editStore(BuildContext context, int index, FormData formData,
      List<String> deletedImages) async {
=======
  Future editStore(
      BuildContext context, int index,  FormData formData, List<String> deletedImages) async {
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
    _formsLoading = true;
    notifyListeners();

    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
<<<<<<< HEAD
      var res = await dio.put(BASE_API_URL + '/store/${stores![index].id}',
          data: formData);
=======
      var res = await dio.put(BASE_API_URL + '/store/${stores![index].id}', data: formData);
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
      if (res.statusCode == 200) {
        /// Save new Store Data
        stores![index] = Store.fromJson(res.data);
        notifyListeners();

        /// Display Results Message
        ToastSnackbar().init(context).showToast(
            message: "${res.statusMessage}", type: ToastSnackbarType.success);
        Navigator.pop(context);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        /// Display Error Response
        ToastSnackbar()
            .init(context)
            .showToast(message: "${e.response}", type: ToastSnackbarType.error);
      } else {
        /// Display Error Message
        ToastSnackbar()
            .init(context)
            .showToast(message: e.message, type: ToastSnackbarType.error);
      }
    }
    _formsLoading = false;
    notifyListeners();
  }

  Future<bool> freezeStore(BuildContext context, int index) async {
    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
<<<<<<< HEAD
      var res = await dio.put(BASE_API_URL + '/store/${stores![index].id}',
          data: {"isActive": !stores![index].isActive!});
=======
      var res = await dio.put(BASE_API_URL + '/store/${stores![index].id}', data: {
        "isActive": !stores![index].isActive!
      });
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
      if (res.statusCode == 200) {
        /// Save new Store Data
        stores![index].isActive = res.data['isActive'];
        notifyListeners();

        /// Display Results Message
        ToastSnackbar().init(context).showToast(
            message: "${res.statusMessage}", type: ToastSnackbarType.success);
        return true;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        /// Display Error Response
        ToastSnackbar()
            .init(context)
            .showToast(message: "${e.response}", type: ToastSnackbarType.error);
        return false;
      } else {
        /// Display Error Message
        ToastSnackbar()
            .init(context)
            .showToast(message: e.message, type: ToastSnackbarType.error);
        return false;
      }
    }
    return false;
  }

  Future<bool> deleteStore(String id) async {
    return true;
  }

  /// Categories Methods
  Future addCategory() async {}

  Future editCategory() async {}

  Future getCategories(String storeId) async {
    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    // String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// post the dataForm via dio call
<<<<<<< HEAD
    ///
=======
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
      var res = await dio.get(BASE_API_URL + '/category');
      _loading = false;
      notifyListeners();
      if (res.statusCode == 200) {
        _stores!.firstWhere((element) => element.id == storeId).categories = [];
        _stores!
            .firstWhere((element) => element.id == storeId)
            .categories!
            .addAll((() {
              List<Category> _list = [];
              _list.addAll(Category.categoriesFromJsonList(res.data!));
              // for (int i = 0; i < res.data!.length; i++) {
              //   print('XXXX ${res.data[i]}');
              //   _list.add(Category(name: res.data[i]));
              // }
              return _list;
            }()));
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

  Future deleteCategory() async {}
}
