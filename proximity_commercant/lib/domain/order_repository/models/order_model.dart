import 'package:proximity/domain_repository/models/address_model.dart';
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
        totalPrice = parsedJson['total'].toDouble(),
        orderStatus = (() {
          switch (parsedJson['status']) {
            case "pending":
              return OrderStatus.pending;
            case "succeeded":
              return OrderStatus.succeeded;
            case "delivered":
              return OrderStatus.delivered;
            case "cancelled":
              return OrderStatus.cancelled;
            default:
              return OrderStatus.pending;
          }
        }()),
        currency = '€',
        orderDate = DateTime.now(),
        deliveryDate = DateTime.now(),
        items = OrderItem.orderItemsFromJsonList(parsedJson['items']),
        storeAddress = Address(
            city: parsedJson['origin']['city'],
            countryName: "France",
            postalCode: parsedJson['origin']['postalCode']),
        shippingAddress = Address(
            city: parsedJson['billingAdress']['city'],
            countryName: "France",
            postalCode: parsedJson['billingAdress']['postalCode'],
            fullAddress: parsedJson['billingAdress']['street1'],
            streetName: parsedJson['billingAdress']['street2']),
        storeId = parsedJson['storeId'],
        userId = parsedJson['userId'],
        userName = 'Abdelmadjid Bouikken Bahi',
        userEmail = 'bouikkenmajid@gmail.com',
        userProfilePic =
            'https://lh3.googleusercontent.com/a-/AFdZucqXI0BZWmCJ_KmHHrlGOxk8IMZ5lED0Kz6ufbhC=s200-p',
        userPhone = parsedJson['billingAdress']['phone'];

  static List<Order> ordersFromJsonList(List<dynamic> parsedJson) {
    List<Order> _list = [];
    for (int i = 0; i < parsedJson.length; i++) {
      _list.add(Order.fromJson(parsedJson[i]));
    }
    return _list;
  }
}
