import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_commercant/domain/data_persistence/data_persistence.dart';
import 'package:proximity_commercant/domain/order_repository/order_repository.dart';

class OrderService with ChangeNotifier {
  List<Order>? _pendingOrders;
  List<Order>? _confirmedOrders;
  List<Order>? _deliveredOrders;
  List<Order>? _rejectedOrders;

  List<Order>? get pendingOrders => _pendingOrders;

  List<Order>? get confirmedOrders => _confirmedOrders;

  List<Order>? get deliveredOrders => _deliveredOrders;

  List<Order>? get rejectedOrders => _rejectedOrders;

  /// GET methods
  Future getPendingOrders() async {
    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    // String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
      var res = await dio.get(BASE_API_URL + '/order/status/pending');
      notifyListeners();
      if (res.statusCode == 200) {
        _pendingOrders = [];
        _pendingOrders!.addAll(Order.ordersFromJsonList(res.data));
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

  Future getConfirmedOrders() async {
    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    // String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
      var res = await dio.get(BASE_API_URL + '/order/status/succeeded');
      notifyListeners();
      if (res.statusCode == 200) {
        _confirmedOrders = [];
        _confirmedOrders!.addAll(Order.ordersFromJsonList(res.data));
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

  Future getDeliveredOrders() async {
    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    // String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
      var res = await dio.get(BASE_API_URL + '/order/status/delivered');
      notifyListeners();
      if (res.statusCode == 200) {
        _deliveredOrders = [];
        _deliveredOrders!.addAll(Order.ordersFromJsonList(res.data));
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

  Future getRejectedOrders() async {
    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    // String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
      var res = await dio.get(BASE_API_URL + '/order/status/cancelled');
      notifyListeners();
      if (res.statusCode == 200) {
        _rejectedOrders = [];
        _rejectedOrders!.addAll(Order.ordersFromJsonList(res.data));
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

  /// PUT Methods
  Future confirmOrder(BuildContext context, String id) async {
    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    // String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
      var res = await dio.put(BASE_API_URL + '/order/billStatus/$id');
      notifyListeners();
      if (res.statusCode == 200) {
        if (_confirmedOrders == null) {
          _confirmedOrders == [];
        }
        _confirmedOrders!.add(_pendingOrders!.firstWhere((element) => element.id == id));
        _pendingOrders!.removeWhere((element) => element.id == id);
        notifyListeners();

        /// Display Results Message
        ToastSnackbar().init(context).showToast(
            message: "${res.statusMessage}", type: ToastSnackbarType.success);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        /// Toast Message to print the message
        ToastSnackbar()
            .init(context)
            .showToast(message: "${e.response}", type: ToastSnackbarType.error);
      } else {
        /// Error due to setting up or sending the request
        ToastSnackbar()
            .init(context)
            .showToast(message: e.message, type: ToastSnackbarType.error);
      }
    }
  }

  Future deliverOrder(BuildContext context, String id) async {
    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    // String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
      var res = await dio.put(BASE_API_URL + '/order/billStatus/delivered/$id');
      notifyListeners();
      if (res.statusCode == 200) {
        if (_deliveredOrders == null) {
          _deliveredOrders == [];
        }
        _deliveredOrders!.add(_confirmedOrders!.firstWhere((element) => element.id == id));
        _confirmedOrders!.removeWhere((element) => element.id == id);
        notifyListeners();

        /// Display Results Message
        ToastSnackbar().init(context).showToast(
            message: "${res.statusMessage}", type: ToastSnackbarType.success);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        /// Toast Message to print the message
        ToastSnackbar()
            .init(context)
            .showToast(message: "${e.response}", type: ToastSnackbarType.error);
      } else {
        /// Error due to setting up or sending the request
        ToastSnackbar()
            .init(context)
            .showToast(message: e.message, type: ToastSnackbarType.error);
      }
    }
  }
}
