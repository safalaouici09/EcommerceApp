import 'package:proximity/domain_repository/models/address_model.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/order_repository/models/bill_model.dart';
import 'package:proximity_client/domain/store_repository/models/models.dart';
import 'package:proximity_client/domain/user_repository/models/models.dart';

import 'order_item_model.dart';

enum OrderStatus { pending, succeeded, delivered, cancelled }

class Order {
  String? id;
  String? clientId;

  String? storeId;
  String? storeName;
  String? storePhone;
  Address? storeAddress;

  Map<String, String>? pickupPerson;
  Address? shippingAddress;

  Bill? paymentInfo;
  String? currency;

  double? totalPrice;
  DateTime? orderDate;

  bool? reservation;
  bool? delivery;
  bool? pickup;

  DateTime? deliveryDate;
  DateTime? timeLimit;
  List<OrderItem>? items;

  OrderStatus? orderStatus;

  Order(
      {this.id,
      this.clientId,
      this.storeId,
      this.storeName,
      this.storeAddress,
      this.storePhone,
      this.pickupPerson,
      this.shippingAddress,
      this.paymentInfo,
      this.currency,
      this.totalPrice,
      this.orderDate,
      this.reservation,
      this.delivery,
      this.pickup,
      this.deliveryDate,
      this.timeLimit,
      this.items,
      this.orderStatus});

  Order.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['_id'],
        clientId = parsedJson['clientId'],
        storeId = parsedJson['storeId'],
        storeName = parsedJson['store']['name'],
        storePhone = parsedJson['seller']['phone'],
        storeAddress = Address(
            city: parsedJson['store']['address']['city'],
            fullAddress: parsedJson['store']['address']['fullAdress'],
            streetName: parsedJson['store']['address']['streetName'],
            countryName: "France",
            postalCode: parsedJson['store']['postalCode']),
        pickupPerson = parsedJson['pickupPerson'] != null
            ? {
                "name": parsedJson['pickupPerson']["name"],
                "nif": parsedJson['pickupPerson']["nif"]
              }
            : null,
        totalPrice = parsedJson['paymentInfos']['totalAmount'].toDouble(),
        currency = '€',
        orderDate = DateTime.now(),
        deliveryDate = DateTime.now(),
        items = OrderItem.orderItemsFromJsonList(parsedJson['items']),
        paymentInfo = Bill.fromJson(parsedJson['paymentInfos']),
        shippingAddress = Address(
            city: parsedJson['paymentInfos']['card']['address_city'],
            countryName: "France",
            postalCode: parsedJson['paymentInfos']['card']['postalCode'],
            fullAddress: parsedJson['paymentInfos']['card']['address_line2'],
            streetName: parsedJson['paymentInfos']['card']['address_line1']),
        delivery = parsedJson['delivery'],
        pickup = parsedJson['pickUp'],
        reservation = parsedJson['reservation'],
        orderStatus = (() {
          switch (parsedJson['status']) {
            case "Pending":
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
        }());

  static List<Order> ordersFromJsonList(List<dynamic> parsedJson) {
    List<Order> _list = [];
    for (int i = 0; i < parsedJson.length; i++) {
      _list.add(Order.fromJson(parsedJson[i]));
    }
    return _list;
  }
}
