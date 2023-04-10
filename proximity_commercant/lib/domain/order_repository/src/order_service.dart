import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_commercant/domain/data_persistence/data_persistence.dart';
import 'package:proximity_commercant/domain/order_repository/order_repository.dart';

class OrderService with ChangeNotifier {
  List<Order>? _pendingOrders;
  List<Order>? _selfPickupOrders;
  List<Order>? _deliveryOrders;
  List<Order>? _reservationOrders;
  List<Order>? _returnOrders = [];
  List<Order>? _refundOrders = [];
  List<Order>? _canceledOrders = [];
  List<Order>? _history;

  // essential values for the UI
  late bool _loading;

  List<Order>? get pendingOrders => _pendingOrders;

  List<Order>? get selfPickupOrders => _selfPickupOrders;

  List<Order>? get deliveryOrders => _deliveryOrders;

  List<Order>? get reservationOrders => _reservationOrders;

  List<Order>? get refundOrders => _refundOrders;

  List<Order>? get returnOrders => _returnOrders;

  List<Order>? get canceledOrders => _canceledOrders;

  List<Order>? get history => _history;

  bool get loading => _loading;

  OrderService() {
    _loading = false;
  }

  /// Pay Order
  Future payOrder(BuildContext context, FormData formData) async {
    _loading = true;
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
      var res = await dio.post(BASE_API_URL + '/order/', data: formData);
      notifyListeners();
      if (res.statusCode == 200) {
        /// Display Results Message
        ToastSnackbar().init(context).showToast(
            message: "Order successfully paid!",
            type: ToastSnackbarType.success);

        _loading = false;
        notifyListeners();
        return true;
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
    _loading = false;
    notifyListeners();
    return false;
  }

  Future getPendingOrders() async {
    print("ws lanched");

    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
      var res = await dio.get(BASE_API_URL + '/order/$_id/status/Pending');
      notifyListeners();
      if (res.statusCode == 200) {
        print(res);
        _pendingOrders = [];
        _pendingOrders!.addAll(Order.ordersFromJsonList(res.data));
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

  /// GET methods
  Future getPickUpOrders() async {
    print("ws lanched");

    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
      var res =
          await dio.get(BASE_API_URL + '/order/pickup/$_id/status/Pending');
      notifyListeners();
      if (res.statusCode == 200) {
        print(res);
        _selfPickupOrders = [];
        _selfPickupOrders!.addAll(Order.ordersFromJsonList(res.data));
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

  Future getDeliveryOrders() async {
    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
      var res =
          await dio.get(BASE_API_URL + '/order/delivery/$_id/status/Pending');
      notifyListeners();
      if (res.statusCode == 200) {
        _deliveryOrders = [];
        _deliveryOrders!.addAll(Order.ordersFromJsonList(res.data));
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

  Future getReservationOrders() async {
    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
      var res = await dio
          .get(BASE_API_URL + '/order/reservation/$_id/status/Pending');
      notifyListeners();
      if (res.statusCode == 200) {
        _reservationOrders = [];
        _reservationOrders!.addAll(Order.ordersFromJsonList(res.data));
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

  Future getCanceledOrders() async {
    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
      var res = await dio.get(BASE_API_URL + '/order/$_id/status/delivered');
      notifyListeners();
      if (res.statusCode == 200) {
        _canceledOrders = [];
        _canceledOrders!.addAll(Order.ordersFromJsonList(res.data));
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

  Future getReviewedOrders() async {
    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
      var res = await dio.get(BASE_API_URL + '/order/$_id/status/cancelled');
      notifyListeners();
      if (res.statusCode == 200) {
        _history = [];
        _history!.addAll(Order.ordersFromJsonList(res.data));
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
