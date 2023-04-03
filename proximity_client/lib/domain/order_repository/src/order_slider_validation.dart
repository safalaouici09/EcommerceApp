import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:proximity_client/domain/store_repository/models/models.dart';
import 'package:proximity_client/domain/product_repository/product_repository.dart';
import 'package:proximity_client/domain/data_persistence/data_persistence.dart';

class OrderSliderValidation with ChangeNotifier {
  ShippingMethod? _shippingMethod;
  List<ProductCart> _products = [];
  String? _cartId;
  String? _storeId;

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

  String? get cartId => _cartId;
  String? get storeId => _storeId;

  String? get cardNumber => _cardNumber;
  String? get expdate => _expdate;
  String? get cvc => _cvc;
  String? get name => _name;
  String? get phone => _phone;
  String? get city => _city;
  String? get street => _street;
  String? get street2 => _street2;
  String? get postalCode => _postalCode;

  String? get pickupName => _pickupName;
  String? get pickupNif => _pickupNif;

  OrderSliderValidation.initProducts(
      List<ProductCart> new_products, String? newCartId, String? newStoreId) {
    _products.addAll(new_products);
    _cartId = newCartId;
    _storeId = newStoreId;
    notifyListeners();
    if (products.isNotEmpty) print(_products[0].characteristics);
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
                  (1 - item.reservationP) *
                  (1 - item.discount)
            }
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
    double total = 0.0;
    _products.forEach((item) => {
          if (item.reservation != true && item.delivery == true)
            {
              total += item.price! *
                  (item.quantity) *
                  (1 + item.deliveryP) *
                  (1 - item.discount)
            }
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
    Map<String, dynamic> paymentInfos = {
      "deliveryAmount": 0.0,
      "reservationAmount": 0.0,
      "totalAmount": getDeliveryItemsTotal() +
          getPickupItemsTotal() +
          getReservationItemsTotal(),
      "paymentMethodeId": 1,
      "card": {
        "cardNumber": _cardNumber ?? "",
        "ccv": _cvc ?? "",
        "expdate": _expdate ?? "",
        "name": _name ?? "",
        "address_city": _city ?? "",
        "address_line1": _street ?? "",
        "address_line2": _street2 ?? "",
        "postalCode": _postalCode ?? ""
      },
    };

    List<Map<String, dynamic>> itemsOrder = [];

    List<ProductCart> currentItems = getPickupItems();

    currentItems.forEach((element) {
      itemsOrder.add({
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

    FormData _formData = FormData.fromMap({
      "clientId": _id,
      "storeId": _storeId,
      "cartId": _cartId,
      "pickupPerson": {"name": _pickupName ?? "", "nif": _pickupNif ?? ""},
      "deliveryAddresse": null,
      "distance": null,
      "paymentInfos": json.encode(paymentInfos),
      "items": json.encode(itemsOrder),
      "reservation": false,
      "pickUp": true,
      "delivery": false,
      "timeLimit": null,
    });

    return _formData;
  }

  OrderSliderValidation();
}
