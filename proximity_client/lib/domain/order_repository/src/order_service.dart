import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/data_persistence/data_persistence.dart';
import 'package:proximity_client/domain/order_repository/order_repository.dart';

class OrderService with ChangeNotifier {
  List<Order>? _selfPickupOrders;
  List<Order>? _deliveryOrders;
  List<Order>? _canceledOrders;
  List<Order>? _history;

  // essential values for the UI
  late bool _loading;

  List<Order>? get selfPickupOrders => _selfPickupOrders;

  List<Order>? get deliveryOrders => _deliveryOrders;

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
    // String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
      var res = await dio.post(BASE_API_URL + '/order/', data: formData
          // {
          //   "storeId": "62ea7dceb54f5844e0278dfa",
          //   "email": "hm_merabet@esi.dz",
          //   "way": "partial",
          //   "billingAdress": {
          //     "name": "Mohamed malih merabet",
          //     "street2": "75 avenue Fliche Augustin ",
          //     "street1": "Cité U Triolet D21 ",
          //     "phone": "0749140358",
          //     "postalCode": "34000",
          //     "city": "Montpellier"
          //   },
          //   "cardNumber": "4242 4242 4242 4242",
          //   "cvc": "345",
          //   "expMonth": "12",
          //   "expYear": "2024"
          // }
          );
      notifyListeners();
      if (res.statusCode == 200) {
        /// Display Results Message
        ToastSnackbar().init(context).showToast(
            message: "Order successfully paid!",
            type: ToastSnackbarType.success);
        Navigator.pop(context);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        /// Display Error Response
        ToastSnackbar()
            .init(context)
            .showToast(message: "${e.response}", type: ToastSnackbarType.error);
        Navigator.pop(context);
      } else {
        /// Display Error Message
        ToastSnackbar()
            .init(context)
            .showToast(message: e.message, type: ToastSnackbarType.error);
      }
    }
    _loading = false;
    notifyListeners();
  }

  /// GET methods
  Future getUnpaidOrders() async {
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
        _selfPickupOrders = [
          Order(
            id: 'ord456',
            orderStatus: OrderStatus.pending,
            currency: 'EUR',
            totalPrice: 23.75,
            orderDate: DateTime(2022, 4, 1, 11, 15),
            deliveryDate: DateTime(2022, 4, 10, 9, 30),
            items: [
              OrderItem(
                  id: 'item004',
                  name: 'Product D',
                  price: 5.99,
                  orderedQuantity: 2),
              OrderItem(
                  id: 'item005',
                  name: 'Product E',
                  price: 8.50,
                  orderedQuantity: 3),
            ],
            storeAddress: Address(
              streetName: '321 Main St',
              city: 'Paris',
              postalCode: '75001',
              countryName: 'France',
            ),
            shippingAddress: Address(
              streetName: '789 Rue St-Antoine',
              city: 'Montreal',
              postalCode: 'H2Y 3B4',
              countryName: 'Canada',
              fullAddress: '789 Rue St-Antoine, Apt 7C',
            ),
            billId: 'bill002',
            storeId: 'store002',
          )
        ];
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
    // String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// post the dataForm via dio call
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
      var res = await dio.get(BASE_API_URL + '/order/status/succeeded');
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

  Future getCanceledOrders() async {
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
}
