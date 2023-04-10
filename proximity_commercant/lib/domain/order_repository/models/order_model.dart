import 'package:proximity/domain_repository/models/address_model.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_commercant/domain/order_repository/models/bill_model.dart';
import 'package:proximity_commercant/domain/store_repository/store_repository.dart';
import 'package:proximity_commercant/domain/user_repository/models/models.dart';

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
  String? billId;
  String? storeId;
  String? userId;
  String? userName;
  String? userEmail;
  String? userProfilePic;
  String? userPhone;

  bool? reservation;
  bool? delivery;
  bool? pickup;

  String? storeName;
  String? storePhone;

  Bill? paymentInfo;

  Map<String, String>? pickupPerson;

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
      this.billId,
      this.storeId,
      this.userId,
      this.userName,
      this.userEmail,
      this.userProfilePic,
      this.userPhone});

  Order.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['_id'],
        userId = parsedJson['clientId'],
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
            city: parsedJson['deliveryAddresse'] != null &&
                    parsedJson['deliveryAddresse']["city"] != null
                ? parsedJson['deliveryAddresse']["city"]
                : "",
            countryName: "France",
            postalCode: parsedJson['deliveryAddresse'] != null &&
                    parsedJson['deliveryAddresse']["postalCode"] != null
                ? parsedJson['deliveryAddresse']["postalCode"]
                : "",
            fullAddress: parsedJson['deliveryAddresse'] != null &&
                    parsedJson['deliveryAddresse']["fullAdress"] != null
                ? parsedJson['deliveryAddresse']["fullAdress"]
                : "",
            streetName: parsedJson['deliveryAddresse'] != null &&
                    parsedJson['deliveryAddresse']["streetName"] != null
                ? parsedJson['deliveryAddresse']["streetName"]
                : "",
            region: parsedJson['deliveryAddresse'] != null &&
                    parsedJson['deliveryAddresse']["region"] != null
                ? parsedJson['deliveryAddresse']["region"]
                : ""),
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
        })(),
        userName =
            parsedJson['user'] != null && parsedJson['user']["username"] != null
                ? parsedJson['user']["username"]
                : "",
        userEmail =
            parsedJson['user'] != null && parsedJson['user']["email"] != null
                ? parsedJson['user']["email"]
                : "",
        userProfilePic = parsedJson['user'] != null &&
                parsedJson['user']["profileImage"] != null
            ? BASE_IMG_URL + '/' + parsedJson['user']["profileImage"]
            : "",
        userPhone =
            parsedJson['user'] != null && parsedJson['user']["phone"] != null
                ? parsedJson['user']["phone"]
                : "";

  static List<Order> ordersFromJsonList(List<dynamic> parsedJson) {
    List<Order> _list = [];
    for (int i = 0; i < parsedJson.length; i++) {
      _list.add(Order.fromJson(parsedJson[i]));
    }
    return _list;
  }
}
