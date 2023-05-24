import 'package:proximity/domain_repository/models/address_model.dart';
import 'package:proximity_commercant/domain/store_repository/store_repository.dart';
import 'package:proximity_commercant/domain/user_repository/models/models.dart';

import 'order_item_model.dart';

class Order {
  String? id;
  String? orderStatus;
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
  bool? returnOrder;
  bool? refund;
  bool? canceled;
  Map<String, String>? canceledBy;

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
        returnOrder = parsedJson['return'],
        refund = parsedJson['refund'],
        orderStatus = parsedJson['status'],
        canceled = parsedJson['canceled'] ?? false,
        canceledBy = parsedJson['canceledBy'] != null &&
                parsedJson['canceledBy']["userId"] != null
            ? {
                "userId": parsedJson['canceledBy']["userId"],
                "name": parsedJson['canceledBy']["name"],
                "image": BASE_IMG_URL + '/' + parsedJson['canceledBy']["image"],
                "motif": parsedJson['canceledBy']["motif"],
              }
            : null,
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
