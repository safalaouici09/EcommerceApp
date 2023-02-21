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

  static List<Order> orders = [
    Order(
        id: '070011138000',
        orderStatus: OrderStatus.pending,
        currency: '€',
        totalPrice: 2599,
        orderDate: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
        deliveryDate: null,
        shippingAddress: User.user.address,
        storeAddress: Store.stores[4].address,
        storeId: Store.stores[4].id,
        storeName: Store.stores[4].name,
        storePhone: Store.stores[4].phoneNumber,
        items: [
          OrderItem(
            id: '0',
            name:
                'MacBook Pro',
            variantId: '62ea829a73ff0f593e711112',
            variantName: '',
            categoryName: '',
            characteristics: [
              {'name': 'Color', 'value': 'Silver'},
              {'name': 'Size', 'value': '13 inches'},
            ],
            image: BASE_IMG_URL+'/'+'images/variantes/e52715f5-0b20-43e1-bc9b-654a8983c403macbook-color-2.jfif',
            price: 1299,
            discount: 0.0,
            discountEndDate: DateTime.now().add(
                const Duration(days: 31, hours: 23, minutes: 48, seconds: 3)),
            storeId: '62ea7dceb54f5844e0278dfa',
            orderedQuantity: 2,
          )
        ]),
  ];
}
