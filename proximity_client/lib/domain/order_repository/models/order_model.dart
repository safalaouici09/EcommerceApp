import 'package:proximity/domain_repository/models/address_model.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/store_repository/models/models.dart';
import 'package:proximity_client/domain/user_repository/models/models.dart';

import 'order_item_model.dart';

enum OrderStatus { pending, succeeded, delivered, cancelled }

class Order {
  String? id;
  OrderStatus? orderStatus;
  String? currency;
  double? totalPrice;
  DateTime? orderDate;
  DateTime? deliveryDate;
  List<OrderItem>? items;
  Address? storeAddress;
  Address? shippingAddress;
  String? storeId;
  String? storeName;
  String? storePhone;

  Order(
      {this.id,
      this.orderStatus,
      this.currency,
      this.totalPrice,
      this.orderDate,
      this.deliveryDate,
      this.items,
      this.storeAddress,
      this.shippingAddress,
      this.storeId,
      this.storeName,
      this.storePhone});

  Order.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['_id'],
        storeId = parsedJson['storeId'],
        totalPrice = parsedJson['total'].toDouble(),
        orderStatus = (() {
          switch(parsedJson['status']) {
            case "pending":
              return OrderStatus.pending;
            case "succeeded":
              return OrderStatus.succeeded;
            case "cancelled":
              return OrderStatus.cancelled;
            case "delivered":
              return OrderStatus.delivered;
            default:
              return OrderStatus.pending;
          }
        } ()),
        currency = '€',
        orderDate = DateTime.now(),
        deliveryDate = DateTime.now(),
        items = OrderItem.orderItemsFromJsonList(parsedJson['items']),
        storeAddress = Address(
            city: parsedJson['origin']['city'],
            countryName: "France",
            postalCode: parsedJson['origin']['postalCode']
        ),
        shippingAddress = Address(
            city: parsedJson['billingAdress']['city'],
            countryName: "France",
            postalCode: parsedJson['billingAdress']['postalCode'],
            fullAddress: parsedJson['billingAdress']['street1'],
            streetName: parsedJson['billingAdress']['street2']
        ),
        storeName = Store.stores[4].name,
        storePhone = Store.stores[4].phoneNumber;

  static List<Order> ordersFromJsonList(List<dynamic> parsedJson) {
    List<Order> _list = [];
    for (int i = 0; i < parsedJson.length; i++) {
      _list.add(Order.fromJson(parsedJson[i]));
    }
    return _list;
  }

}
