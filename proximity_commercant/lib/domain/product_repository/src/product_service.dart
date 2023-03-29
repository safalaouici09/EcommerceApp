import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_commercant/domain/data_persistence/data_persistence.dart';
import 'package:proximity_commercant/domain/product_repository/models/offer_model.dart';
import 'package:proximity_commercant/domain/product_repository/product_repository.dart';

class ProductService with ChangeNotifier {
  late List<Product>? _products;
  late List<dynamic>? _productsOffers;
  late int _currentPage;
  late bool _fetchMore;
  String? _idStore;

  String? _discountType = 'amount';
  double? _discountAmount;
  int? _discountPercentage;
  int? _offerStock;
  List<Offer>? _storeOffers;
  bool? _isPercentage;

  // essential values for the UI
  late bool _loading;
  late bool _formsLoading;
  String? _offerId;
  // getters
  List<Product>? get products => _products;
  List<dynamic>? get productsOffers => _productsOffers;

  bool get fetchMore => _fetchMore;

  String? get idStore => _idStore;
  bool? get isPercentage => _isPercentage;
  bool get loading => _loading;
  bool get formsLoading => _formsLoading;
  String? get discountType => _discountType;
  double? get discountAmount => _discountAmount;
  int? get discountPercentage => _discountPercentage;
  int? get offerStock => _offerStock;
  Offer? _productOffer;
  Offer? get productOffer => _productOffer;
  List<Offer>? get storeOffers => _storeOffers;

  // setters
  set idStore(String? idStore) {
    _idStore = idStore;
    notifyListeners();
  }

  set products(List<Product>? products) {
    _products = products;
    notifyListeners();
  }

  // constructor
  ProductService() {
    _currentPage = 1;
    _fetchMore = true;
    _idStore = idStore;
    _loading = false;
    _formsLoading = false;
    _isPercentage = _discountType == 'amount' ? false : true;
    getStoreProducts();
    // getStoreOffers();
  }

  reloadList(ProductProxy productProxy) {
    if (_idStore != productProxy.idStore) {
      _currentPage = 1;
      _fetchMore = true;
      _idStore = productProxy.idStore;
      getStoreProducts();
    }
  }

  Future getStoreProducts() async {
    _products = null;
    _loading = true;
    notifyListeners();

    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    // String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";

      var res = await dio.get(BASE_API_URL + '/product/store/$idStore');
      _loading = false;

      notifyListeners();
      if (res.statusCode == 200) {
        print('prrr' + Product.productsFromJsonList(res.data).toString());
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

  Future getProduct(String id) async {
    /*
    var box = Hive.box('mybox');
    var accessToken = box.get('accessToken');
    var refreshToken = box.get('refreshToken');
    Product _product = _products?.firstWhere((element) => element.id == id);
    var res = await Dio()
        .get(SELLER_API_URL + '/seller/product',
            queryParameters: {'_i': id, '_s': _idShop},
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
    print(res.data['product']);
    _product.brand = Product.fromJson(res.data['product']).brand;
    _product.description = Product.fromJson(res.data['product']).description;
    _product.quantity = Product.fromJson(res.data['product']).quantity;
    _product.likes = Product.fromJson(res.data['product']).likes;
    _product.sells = Product.fromJson(res.data['product']).sells;
    _product.rating = Product.fromJson(res.data['product']).rating;
    notifyListeners();
    */

    Future.delayed(const Duration(seconds: 4), () {
      notifyListeners();
    });
  }

  void changeDisountType(String value, int index) {
    _discountType = value;
    if (value == "percentage") {
      _isPercentage = true;
    } else {
      _isPercentage = false;
    }

    notifyListeners();
  }

  void changeDisountPercentage(String value, int index) {
    _discountPercentage = int.parse(value);

    notifyListeners();
  }

  void changeDiscountAmount(String value) {
    _discountAmount = double.tryParse(value);
    notifyListeners();
  }

  void changeOfferStock(String value) {
    _offerStock = int.tryParse(value);
    notifyListeners();
  }

  Future getProductByIndex(int index) async {
    /*
    var box = Hive.box('mybox');
    var accessToken = box.get('accessToken');
    var refreshToken = box.get('refreshToken');
    Product _product = _products?.firstWhere((element) => element.id == id);
    var res = await Dio()
        .get(SELLER_API_URL + '/seller/product',
            queryParameters: {'_i': id, '_s': _idShop},
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
    print(res.data['product']);
    _product.brand = Product.fromJson(res.data['product']).brand;
    _product.description = Product.fromJson(res.data['product']).description;
    _product.quantity = Product.fromJson(res.data['product']).quantity;
    _product.likes = Product.fromJson(res.data['product']).likes;
    _product.sells = Product.fromJson(res.data['product']).sells;
    _product.rating = Product.fromJson(res.data['product']).rating;
    notifyListeners();
    */

    Future.delayed(const Duration(seconds: 4), () {
      notifyListeners();
    });
  }

  Future getSelectableProducts() async {
    if (_idStore == null) {
      _products = [];
      return;
    }
    Future.delayed(const Duration(seconds: 3), () {
      _products!.addAll(
          Product.products.where((product) => product.storeId == _idStore));
      notifyListeners();
    });
    /*var box = Hive.box('mybox');
    var accessToken = box.get('accessToken');
    var refreshToken = box.get('refreshToken');
    var res = await Dio()
        .get(SELLER_API_URL + '/seller/product',
            queryParameters: {'_i': 0, '_s': _idShop, '_p': _currentPage},
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
    if (res.data['type'] == 'OK') {
      _currentPage++;
      if (res.data['more'] == false) _fetchMore = false;
      _products.addAll(res.data['products']
          .map<Product>((product) => Product.fromJson(product))
          .toList());
    }
    notifyListeners();*/
  }

  Future addProduct(BuildContext context, FormData formData) async {
    _formsLoading = true;
    notifyListeners();

    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
      formData.fields.add(MapEntry("sellerId", _id));
      var res = await dio.post(BASE_API_URL + '/product', data: formData);
      if (res.statusCode == 200) {
        /// Save new Store Data
        _products!.add(Product.fromJson(res.data));
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

  Future editProductDiscount(
      BuildContext context, int index, double? discount) async {
    _formsLoading = true;
    _discountAmount = _discountAmount! / 100;
    // discount = discount! / 100;
    notifyListeners();

    FormData formData = FormData.fromMap({
      "discount": _discountAmount,
    }); //"discountType": discountType});

    print('form data' + formData.fields.toString());

    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";

      formData.fields.add(MapEntry("sellerId", _id));
      formData.fields.add(MapEntry("storeId", idStore!));
      print("form " + formData.fields.toString());

      var res = await dio.put(BASE_API_URL + '/product/${_products![index].id}',
          data: formData);

      print("res" + res.statusCode.toString());
      if (res.statusCode == 200) {
        /// Save new Store Data
        _products!.add(Product.fromJson(res.data));

        notifyListeners();

        /// Display Results Message
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response);

        /// Display Error Response
      } else {
        /// Display Error Message
      }
    }
    _formsLoading = false;
    notifyListeners();
  }

  Future editProduct(BuildContext context, int index, FormData formData) async {
    _formsLoading = true;
    notifyListeners();

    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";

      formData.fields.add(MapEntry("sellerId", _id));
      var res = await dio.put(BASE_API_URL + '/product/${_products![index].id}',
          data: formData);
      print("form " + formData.toString());
      print("res" + res.statusCode.toString());
      if (res.statusCode == 200) {
        /// Save new Store Data
        _products!.add(Product.fromJson(res.data));

        notifyListeners();

        /// Display Results Message
        ToastSnackbar().init(context).showToast(
            message: "${res.statusMessage}", type: ToastSnackbarType.success);
        Navigator.pop(context);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response);

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

  Future<bool> deleteProduct(String id) async {
    /// open hive box
    var credentialsBox = Boxes.getCredentials();

    // String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
      var res = await dio.delete(BASE_API_URL + '/product/$id');
      if (res.statusCode == 200) {
        /// Save new Store Data
        _products!.removeWhere((element) => element.id == id);
        notifyListeners();

        /// return True
        return true;
      }
    } on DioError catch (e) {
      if (e.response != null) {
      } else {}
    }
    return false;
  }

  FormData toFormData() {
    FormData _formData = FormData.fromMap({
      'discountType': _discountType,
      'offerDiscount': _discountAmount,
      'offerStock': _offerStock
    });
    return _formData;
  }

  getOffer(String id) async {
    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    // String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();

      dio.options.headers["token"] = "Bearer $_token";
      // var res = await dio.get(BASE_API_URL + '/offer/all/$idStore');
      var res = await dio.get(BASE_API_URL + '/offer/$id');

      _loading = false;

      notifyListeners();
      if (res.statusCode == 200) {
        // print("res data : " + res.data);

        _productOffer = Offer.fromJson(res.data);
        if (_productOffer != null) {
          _offerId = _productOffer!.id;
          _discountAmount = _productOffer!.offerDiscount;
          _discountType = _productOffer!.discountType;
          _offerStock = _productOffer!.offerStock;
        }

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

  getStoreOffers() async {
    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    // String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();

      dio.options.headers["token"] = "Bearer $_token";
      // var res = await dio.get(BASE_API_URL + '/offer/all/$idStore');
      var res = await dio.get(BASE_API_URL + '/offer/all/$_idStore');

      _loading = false;

      notifyListeners();
      if (res.statusCode == 200) {
        print("store offers : " + res.data);
        _storeOffers = [];
        _storeOffers?.addAll(Offer.productsFromJsonList(res.data));

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

  updateOffer(FormData formData) async {
    /// open hive box
    _formsLoading = true;
    notifyListeners();

    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      debugPrint("Offer update form");

      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";

      print("res1");
      print(formData.fields);
      var res = await dio.put(BASE_API_URL + '/offer/update/$_offerId',
          data: formData);
      print('res2');
      print(res.statusCode);
      if (res.statusCode == 200) {
        /// Save new Store Data

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
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('errr');
        print(e.response);

        /// Display Error Response
        /* ToastSnackbar()
            .init(context)
            .showToast(message: "${e.response}", type: ToastSnackbarType.error);*/
      } else {
        print('errr');

        /// Display Error Message
        /* ToastSnackbar()
            .init(context)
            .showToast(message: e.message, type: ToastSnackbarType.error);*/
      }
    }
    _formsLoading = false;
    notifyListeners();
  }

  archiveOffer() async {
    /// open hive box
    _formsLoading = true;
    notifyListeners();

    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      debugPrint("Offer archive form");

      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";

      print("res1");
      print(_offerId);
      var res = await dio.delete(BASE_API_URL + '/offer/delete/$_offerId');
      print('res2');
      print(res.statusCode);
      if (res.statusCode == 200) {
        /// Save new Store Data

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
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('errr');
        print(e.response);

        /// Display Error Response
        /* ToastSnackbar()
            .init(context)
            .showToast(message: "${e.response}", type: ToastSnackbarType.error);*/
      } else {
        print('errr');

        /// Display Error Message
        /* ToastSnackbar()
            .init(context)
            .showToast(message: e.message, type: ToastSnackbarType.error);*/
      }
    }
    _formsLoading = false;
    notifyListeners();
  }

  Future createOffer(BuildContext context, FormData formData, String id) async {
    _formsLoading = true;
    notifyListeners();

    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      debugPrint("Offer form");

      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
      /* formData.fields.add(MapEntry("sellerId", _id));
      formData.fields.add(MapEntry("storeId", _idStore!));*/
      formData.fields.add(MapEntry("productId", id));

      print("res1");
      var res = await dio.post(BASE_API_URL + '/offer/create', data: formData);

      print(res.statusCode);
      if (res.statusCode == 200) {
        /// Save new Store Data

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
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('errr');
        print(e.response);

        /// Display Error Response
        /* ToastSnackbar()
            .init(context)
            .showToast(message: "${e.response}", type: ToastSnackbarType.error);*/
      } else {
        print('errr');

        /// Display Error Message
        /* ToastSnackbar()
            .init(context)
            .showToast(message: e.message, type: ToastSnackbarType.error);*/
      }
    }
    _formsLoading = false;
    notifyListeners();
  }
}
