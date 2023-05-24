import 'dart:convert';
import 'dart:math' show cos, sqrt, asin, sin, pi;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/store_repository/models/models.dart';
import 'package:proximity_client/domain/product_repository/product_repository.dart';
import 'package:proximity_client/domain/data_persistence/data_persistence.dart';

class OrderSliderValidation with ChangeNotifier {
  ShippingMethod? _shippingMethod;
  List<ProductCart> _products = [];
  String? _cartId;
  String? _storeId;
  String? _orderId;

  // Getters
  ShippingMethod? get shippingMethod => _shippingMethod;
  List<ProductCart> get products => _products;

  String? _cardNumber;
  String? _expdate;
  String? _cvc;
  String? _name;
  String? _phone;
  String? _city;
  String? _street;
  String? _street2;
  String? _postalCode;

  String? _pickupName;
  String? _pickupNif;

  Address? _deliveryAdresse;
  double? _maxDeliveryFixe;
  double? _maxDeliveryKm;
  double? _distance;
  double? _totalDelivery = 0.0;
  Address? _storeAdresse;

  String? get cartId => _cartId;
  String? get storeId => _storeId;
  String? get orderId => _orderId;

  String? get cardNumber => _cardNumber;
  String? get expdate => _expdate;
  String? get cvc => _cvc;
  String? get name => _name;
  String? get phone => _phone;
  String? get city => _city;
  String? get street => _street;
  String? get street2 => _street2;
  String? get postalCode => _postalCode;
  Address? get deliveryAdresse => _deliveryAdresse;
  double? get maxDeliveryFixe => _maxDeliveryFixe;
  double? get maxDeliveryKm => _maxDeliveryKm;
  double? get distance => _distance;
  double? get totalDelivery => _totalDelivery;
  Address? get storeAdresse => _storeAdresse;

  String? get pickupName => _pickupName;
  String? get pickupNif => _pickupNif;

  OrderSliderValidation.initProducts(
      List<ProductCart> new_products,
      String? newCartId,
      String? newStoreId,
      Address? newStoreAddress,
      double? newMaxDeliveryFixe,
      double? newMaxDeliveryKm,
      String? newOrderId) {
    _products.addAll(new_products);
    _cartId = newCartId;
    _storeId = newStoreId;
    _orderId = newOrderId;
    _storeAdresse = newStoreAddress;
    _maxDeliveryFixe = newMaxDeliveryFixe;
    _maxDeliveryKm = newMaxDeliveryKm;
    if (newMaxDeliveryFixe != 0.0) {
      _totalDelivery = newMaxDeliveryFixe;
    }
    notifyListeners();
    if (products.isNotEmpty) print(_products[0].characteristics);
  }

  void changeDeliveryAddress(Address value) {
    _deliveryAdresse = value;
    notifyListeners();
    if (_storeAdresse != null) {
      _distance = distanceBetween(_storeAdresse!.lat ?? 0.0,
          _storeAdresse!.lng ?? 0.0, value.lat ?? 0.0, value.lng ?? 0.0);
    }
    if (_maxDeliveryFixe == 0.0 && _maxDeliveryKm != 0.0 && _distance != 0.0) {
      _totalDelivery = (_maxDeliveryKm ?? 1) * (_distance ?? 1);
    }
  }

  void changecardNumber(String value) {
    _cardNumber = value;
    notifyListeners();
  }

  void changeexpdate(String value) {
    if (value.length < 6) {
      if (value.length == 2 && _expdate!.length == 3) {
        _expdate = value.substring(0, 1);
      } else if (value.length == 2) {
        _expdate = value + "/";
      } else {
        _expdate = value;
      }
    }

    notifyListeners();
  }

  void changecvc(String value) {
    _cvc = value;
    notifyListeners();
  }

  void changename(String value) {
    _name = value;
    notifyListeners();
  }

  void changephone(String value) {
    _phone = value;
    notifyListeners();
  }

  void changecity(String value) {
    _city = value;
    notifyListeners();
  }

  void changestreet(String value) {
    _street = value;
    notifyListeners();
  }

  void changestreet2(String value) {
    _street2 = value;
    notifyListeners();
  }

  void changepostalCode(String value) {
    _postalCode = value;
    notifyListeners();
  }

  void changepickupName(String value) {
    _pickupName = value;
    notifyListeners();
  }

  void changepickupNif(String value) {
    _pickupNif = value;
    notifyListeners();
  }

  // Setters
  void toggleReservation(List<dynamic> value) {
    int index = _products.indexWhere((item) => item.id == value[1]);
    if (index != -1) {
      _products[index].reservation = value[0];
      if (value[0]) {
        if (_products[index].pickupPolicy) {
          _products[index].delivery = false;
          _products[index].pickup = true;
        } else {
          _products[index].delivery = true;
        }
      }
    }
    notifyListeners();
  }

  void togglePickup(List<dynamic> value) {
    int index = _products.indexWhere((item) => item.id == value[1]);
    if (index != -1 && _products[index].deliveryPolicy) {
      _products[index].pickup = value[0];
      if (value[0]) {
        _products[index].delivery = false;
      } else if (!_products[index].delivery) {
        _products[index].pickup = true;
      }
    }
    notifyListeners();
  }

  void toggleDelivery(List<dynamic> value) {
    int index = _products.indexWhere((item) => item.id == value[1]);
    if (index != -1 && _products[index].pickupPolicy) {
      _products[index].delivery = value[0];
      if (value[0]) {
        _products[index].pickup = false;
      } else if (!_products[index].pickup) {
        _products[index].delivery = true;
      }
    }
    notifyListeners();
  }

  void changeQuantity(int value, String? id) {
    int index = _products.indexWhere((item) => item.id == id);
    if (index != -1) {
      _products[index].quantity = value;
    }
    notifyListeners();
  }

  void deleteProduct(String? id) {
    _products.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  List<ProductCart> getReservationItems() {
    List<ProductCart> items = [..._products];
    items.removeWhere((item) => item.reservation != true);
    return items;
  }

  double getReservationItemsTotal() {
    double total = 0.0;
    _products.forEach((item) => {
          if (item.reservation == true)
            {
              total += item.price! *
                  (item.quantity) *
                  (item.reservationP) *
                  (1 - item.discount)
            }
        });
    return total;
  }

  double getReservationFinalizeItemsTotal() {
    double total = 0.0;
    _products.forEach((item) => {
          total += item.price! *
              (item.quantity) *
              (1 - item.reservationP) *
              (1 - item.discount)
        });
    return total;
  }

  List<ProductCart> getDeliveryItems() {
    List<ProductCart> items = [..._products];
    items.removeWhere(
        (item) => (item.reservation == true || item.delivery != true));
    return items;
  }

  double getDeliveryItemsTotal() {
    double total = (_totalDelivery ?? 0.0);
    _products.forEach((item) => {
          if (item.reservation != true && item.delivery == true)
            {total += item.price! * (item.quantity) * (1 - item.discount)}
        });
    return total;
  }

  List<ProductCart> getPickupItems() {
    List<ProductCart> items = [..._products];
    items.removeWhere(
        (item) => (item.reservation == true || item.pickup != true));
    return items;
  }

  double getPickupItemsTotal() {
    double total = 0.0;
    _products.forEach((item) => {
          if (item.reservation != true && item.pickup == true)
            {total += item.price! * (item.quantity) * (1 - item.discount)}
        });
    return total;
  }

  FormData toFormData() {
    var credentialsBox = Boxes.getCredentials();
    String _id = credentialsBox.get('id');

    Map<String, dynamic> card = {
      "cardNumber": _cardNumber ?? "",
      "ccv": _cvc ?? "",
      "expdate": _expdate ?? "",
      "name": _name ?? "",
      "address_city": _city ?? "",
      "address_line1": _street ?? "",
      "address_line2": _street2 ?? "",
      "postalCode": _postalCode ?? ""
    };

    List<dynamic> orders = [];

    List<ProductCart> currentPickupItems = getPickupItems();
    List<ProductCart> currentDeliveryItems = getDeliveryItems();
    List<ProductCart> currentReservationItems = getReservationItems();

    if (currentPickupItems.isNotEmpty) {
      Map<String, dynamic> pickUpPaymentInfos = {
        "deliveryAmount": 0.0,
        "reservationAmount": 0.0,
        "totalAmount": getPickupItemsTotal(),
        "paymentMethodeId": 1,
        "card": card,
      };
      Map<String, dynamic> pickupPerson = {
        "name": _pickupName ?? "",
        "nif": _pickupNif ?? ""
      };
      List<Map<String, dynamic>> itemsPickUpOrder = [];

      currentPickupItems.forEach((element) {
        itemsPickUpOrder.add({
          "productId": element.productId ?? "",
          "variantId": element.variantId ?? "",
          "name": element.name ?? "",
          "image": element.image ?? "",
          "price": element.price ?? "",
          "discount": element.discount ?? 0.0,
          "quantity": element.quantity ?? 0.0,
          "policy": null,
        });
      });

      Map<String, dynamic> pickupOrder = {
        "clientId": _id,
        "storeId": _storeId,
        "cartId": _cartId,
        "pickupPerson": pickupPerson,
        "deliveryAddresse": null,
        "deliveryLocation": null,
        "distance": null,
        "paymentInfos": pickUpPaymentInfos,
        "items": itemsPickUpOrder,
        "reservation": false,
        "pickUp": true,
        "delivery": false,
        "timeLimit": null,
      };

      orders.add(pickupOrder);
    }

    if (currentDeliveryItems.isNotEmpty) {
      Map<String, dynamic> deliveryPaymentInfos = {
        "deliveryAmount": _totalDelivery,
        "reservationAmount": 0.0,
        "totalAmount": getDeliveryItemsTotal(),
        "paymentMethodeId": 1,
        "card": card,
      };

      Map<String, dynamic> shippingAddress = {
        "city": deliveryAdresse?.city ?? "",
        "streetName": deliveryAdresse?.streetName ?? "",
        "postalCode": deliveryAdresse?.postalCode ?? "",
        "fullAdress": deliveryAdresse?.fullAddress ?? "",
        "region": deliveryAdresse?.region ?? "",
        "country": deliveryAdresse?.countryName ?? "",
        "countryCode": "FR"
      };

      Map<String, dynamic> ShippingLocation = {
        "coordinates": [
          deliveryAdresse?.lat ?? 0.0,
          deliveryAdresse?.lng ?? 0.0
        ],
      };
      List<Map<String, dynamic>> itemsDeliveryOrder = [];

      currentDeliveryItems.forEach((element) {
        itemsDeliveryOrder.add({
          "productId": element.productId ?? "",
          "variantId": element.variantId ?? "",
          "name": element.name ?? "",
          "image": element.image ?? "",
          "price": element.price ?? "",
          "discount": element.discount ?? 0.0,
          "quantity": element.quantity ?? 0.0,
          "policy": null,
        });
      });

      Map<String, dynamic> deliveryOrder = {
        "clientId": _id,
        "storeId": _storeId,
        "cartId": _cartId,
        "pickupPerson": null,
        "deliveryAddresse": shippingAddress,
        "deliveryLocation": ShippingLocation,
        "distance": _distance,
        "paymentInfos": deliveryPaymentInfos,
        "items": itemsDeliveryOrder,
        "reservation": false,
        "pickUp": false,
        "delivery": true,
        "timeLimit": null,
      };

      orders.add(deliveryOrder);
    }

    if (currentReservationItems.isNotEmpty) {
      Map<String, dynamic> reservationPaymentInfos = {
        "deliveryAmount": 0.0,
        "reservationAmount": getReservationItemsTotal(),
        "totalAmount": getReservationItemsTotal(),
        "paymentMethodeId": 1,
        "card": card,
      };

      List<Map<String, dynamic>> itemsReservationOrder = [];

      currentReservationItems.forEach((element) {
        itemsReservationOrder.add({
          "productId": element.productId ?? "",
          "variantId": element.variantId ?? "",
          "name": element.name ?? "",
          "image": element.image ?? "",
          "price": element.price ?? "",
          "discount": element.discount ?? 0.0,
          "quantity": element.quantity ?? 0.0,
          "reservation": element.reservationP ?? 0.0,
          "policy": null,
        });
      });

      Map<String, dynamic> deliveryOrder = {
        "clientId": _id,
        "storeId": _storeId,
        "cartId": _cartId,
        "pickupPerson": null,
        "deliveryAddresse": null,
        "deliveryLocation": null,
        "distance": _distance,
        "paymentInfos": reservationPaymentInfos,
        "items": itemsReservationOrder,
        "reservation": true,
        "pickUp": false,
        "delivery": false,
        "timeLimit": null,
      };

      orders.add(deliveryOrder);
    }
    print(orders);

    FormData _formData =
        FormData.fromMap({"orders": json.encode(orders), "orderId": _orderId});

    return _formData;
  }

  OrderSliderValidation();

  static const earthRadiusKm = 6372.8;

  static double distanceBetween(
      double lat1, double lon1, double lat2, double lon2) {
    final latDistance = _toRadians(lat2 - lat1);
    final lonDistance = _toRadians(lon2 - lon1);
    final sinLat = sin(latDistance / 2);
    final sinLon = sin(lonDistance / 2);
    final a = sinLat * sinLat +
        (cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * sinLon * sinLon);
    final c = 2 * asin(sqrt(a));
    return earthRadiusKm * c;
  }

  static double _toRadians(double degree) {
    return degree * pi / 180;
  }
}
