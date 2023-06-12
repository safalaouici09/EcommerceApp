import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/data_persistence/data_persistence.dart';
import 'package:proximity_client/domain/order_repository/order_repository.dart';
import 'package:proximity_client/ui/pages/pages.dart';

class NotificationService with ChangeNotifier {
  Order? _order;

  late bool _loadingOrder = false;

  Order? get order => _order;
  bool get loadingOrder => _loadingOrder;

  Future getOrder(String order_id, BuildContext context,
      {bool? returnOrder = false, bool? refundOrder = false}) async {
    print("ws lanched : $order_id  ");
    _order = null;
    _loadingOrder = true;
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
      var res = await dio.get(BASE_API_URL + '/order/$order_id');
      notifyListeners();
      if (res.statusCode == 200) {
        print(res.data.length);
        _order = Order.fromJson(res.data);
        _loadingOrder = false;
        notifyListeners();
        if (res.data != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderPage(
                      order: _order,
                      returnOrder: returnOrder,
                      refundOrder: refundOrder)));
        }
      }
    } on DioError catch (e) {
      _loadingOrder = false;
      notifyListeners();
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
