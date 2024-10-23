import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/cart_repository/cart_repository.dart';
import 'package:proximity_client/domain/data_persistence/data_persistence.dart';
import 'package:proximity_client/domain/order_repository/models/models.dart';
import 'package:proximity_client/domain/order_repository/order_repository.dart';
import 'package:proximity_client/domain/order_repository/src/order_confirmation.dart';
import 'package:proximity_client/domain/product_repository/models/models.dart';
import 'package:proximity_client/domain/store_repository/store_repository.dart';
import 'package:proximity_client/ui/pages/main_pages/view/cart_slider_screen.dart';
import 'package:proximity_client/ui/pages/pages.dart';
import 'dart:convert';
import 'package:proximity/config/backend.dart';
import 'package:proximity_client/domain/order_repository/models/address_order_model.dart';
import 'package:proximity_client/domain/order_repository/models/infosContact_model.dart';

class CartService with ChangeNotifier {
  // Hive box
  var cartBox;
  var cartItemsBox;

  // essential values for the UI
  bool _loadingAdd = false;
  bool _loadingOrder = false;

  // getters
  bool get loadingAdd => _loadingAdd;

  bool get loadingOrder => _loadingOrder;

  // setters
  void addQuantity(String key) {
    CartItem _cartItem = cartItemsBox.get(key);
    _cartItem.orderedQuantity++;
    _cartItem.save();
    notifyListeners();
  }

  void subtractQuantity(String key) {
    CartItem _cartItem = cartItemsBox.get(key);
    if (_cartItem.orderedQuantity != 1) _cartItem.orderedQuantity--;
    _cartItem.save();
    notifyListeners();
  }

  void checkAllOrderedProducts(String key) {
    Cart _cart = cartBox.get(key);
    _cart.checked = !_cart.checked;
    _cart.save();
    List<CartItem> _cartItems = cartItemsBox.values.toList().cast<CartItem>();
    for (int i = 0; i < _cartItems.length; i++) {
      if (_cartItems[i].storeId == key) {
        print('${_cartItems[i].storeId} - $key');
        _cartItems[i].checked = _cart.checked;
        _cartItems[i].save();
      }
    }
    notifyListeners();
  }

  void checkOrderedProduct(String key) {
    /// start by updating the [CartItem]
    CartItem _cartItem = cartItemsBox.get(key);
    _cartItem.checked = !_cartItem.checked;
    _cartItem.save();

    /// if one [CarItem] is unchecked, then the [Cart] is unchecked
    Cart _cart = cartBox.get(_cartItem.storeId);
    if (!_cartItem.checked) {
      _cart.checked = _cartItem.checked;
      _cart.save();
    }

    /// else if all [CarItem] are checked, then the order is checked
    else {
      bool allChecked = true;
      for (var key in _cart.cartItemsKeys!) {
        allChecked = allChecked & cartItemsBox.get(key).checked;
      }
      if (allChecked) _cart.checked = allChecked;
      _cart.save();
    }
    notifyListeners();
  }

  // constructor
  CartService() {
    /// Hive box
    cartBox = Boxes.getCartBox();
    cartItemsBox = Boxes.getCartItemsBox();
  }

  /// Essential methods for the UI
  double getTotalPrice(String storeId) {
    double _totalPrice = 0.0;
    cartItemsBox.values.forEach((item) {
      if (item.storeId == storeId) {
        if (item.checked) {
          if ((item.discount != null) &&
              (item.discountEndDate != null) &&
              DateTime.now().isBefore(item.discountEndDate ?? DateTime(2100))) {
            _totalPrice +=
                (item.price * (1 - item.discount!))! * item.orderedQuantity;
          } else {
            _totalPrice += item.price! * item.orderedQuantity;
          }
        }
      }
    });
    return double.parse(_totalPrice.toStringAsFixed(2));
  }

  int getTotalQuantity(String storeId) {
    int _totalQuantity = 0;
    cartItemsBox.values.forEach((item) {
      if (item.storeId == storeId) {
        if (item.checked) {
          _totalQuantity += (item.orderedQuantity as int);
        }
      }
    });
    return _totalQuantity;
  }

  bool valid(String storeId) {
    return (getTotalQuantity(storeId) > 0);
  }

  /// POST methods
  /// Order a Cart
  Future order(BuildContext context, String? storeId) async {
    /// open hive box
    ///
    print("order");
    var credentialsBox = Boxes.getCredentials();
    String? _id = credentialsBox.get('id');
    String? _token = credentialsBox.get('token');

    if (_token != null) {
      var preOrder = {
        "cartId": null,
        "storeId": storeId,
        "clientId": _id,
        "items":
            "" //check and return with policies and current price + current discount
      };

      /// get total price
      if (storeId != null) {
        final double _totalPrice = getTotalPrice(storeId);

        // /// get Store Policy
        // final Policy _policy = Policy.policy;

        /// convert [List<CartItem>] into [List<OrderItem>]
        final List<OrderItem> _orderItems = [];
        final List<Map<String, dynamic>> _preOrderItems = [];
        cartItemsBox.values.forEach((item) {
          preOrder["cartId"] = item?.id;
          if (item.storeId == storeId) {
            var preOrderItem = {
              "variantId": item.variantId,
              "orderQuantity": item.orderedQuantity,
            };
            _preOrderItems.add(preOrderItem);
            _orderItems.add(OrderItem.fromCartItem(item));
          }
        });
        preOrder["items"] = json.encode(_preOrderItems);
        print(preOrder);

        // _loadingOrder = true;
        // notifyListeners();

        //get pre order item from backend (current values) ;
        try {
          Dio dio = Dio();
          dio.options.headers["token"] = "Bearer $_token";
          var res =
              await dio.post(BASE_API_URL + '/order/preOrder/', data: preOrder);
          if (res.statusCode == 200) {
            // stop the loading animation

            List<ProductCart> preOrderProducts = [];
            print(json.encode(res.data));
            List<PickupPerson> pickupPersons = [];
            if (res.data["pickupPersons"] != null &&
                json.decode(res.data["pickupPersons"]) != null) {
              pickupPersons = PickupPerson.storeCategoriesFromJsonList(
                      json.decode(res.data["pickupPersons"]))
                  .toList();
            }

            print("pickupPersons");
            print(pickupPersons);

            List<InfosContact> cards = [];
            if (res.data["cards"] != null) {
              cards = InfosContact.storeCategoriesFromJsonList(
                  json.decode(res.data["cards"]).toList());
            }

            print("cards");
            print(cards);

            // List<AddressOrder> addressOrder = [];
            // if (res.data["addresses"] != null) {
            //   addressOrder = AddressOrder.storeCategoriesFromJsonList(
            //       json.decode(res.data["addresses"]));
            // }

            // print("addressOrder");
            // print(addressOrder);

            if (res.data["items"] != null) {
              var products = json.decode(res.data["items"]);
              for (var prod in products) {
                if (prod["error"] == null) {
                  String prodName = prod["name"] + " ( ";
                  List<Map<String, String>> preOrderItemCharac = [];
                  prod["characterstics"].forEach((item) {
                    prodName += item["value"].toString() + " , ";
                    preOrderItemCharac.add({
                      "name": item["name"].toString(),
                      "value": item["value"].toString()
                    });
                  });

                  var prodInsert = ProductCart(
                      id: prod["id"],
                      productId: prod["productId"],
                      variantId: prod["variantId"],
                      name: prodName.substring(0, prodName.length - 2) + ")",
                      characteristics: preOrderItemCharac,
                      image: prod["image"],
                      price: double.parse(prod["price"].toString()),
                      quantity: prod["quantity"],
                      discount: prod["discount"].toDouble(),
                      reservationPolicy: ((prod["reservation"] == true ||
                                  prod["reservation"] == 'true') &&
                              prod["reservationPolicy"] != null) ??
                          false,
                      deliveryPolicy: true,
                      pickupPolicy: prod["pickupPolicy"] > 0 ?? false,
                      reservationP:
                          double.parse(prod["reservationP"].toString()),
                      deliveryP: double.parse(prod["deliveryP"].toString()),
                      reservation: prod["reservation"] == true ||
                          prod["reservation"] == 'true',
                      delivery: prod["delivery"] == true ||
                          prod["delivery"] == 'true',
                      pickup:
                          prod["pickup"] == true || prod["pickup"] == 'true',
                      policy: prod['policy'] == null
                          ? null
                          : Policy.fromJson(prod['policy']));
                  preOrderProducts.add(prodInsert);
                }
              }
            }

            _loadingOrder = false;
            notifyListeners();

            /// Display Results Message
            ToastSnackbar().init(context).showToast(
                message: "Loading Order Validation with success",
                type: ToastSnackbarType.success);

            if (preOrderProducts.isNotEmpty) {
              try {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CartSliderScreen(
                            products: preOrderProducts,
                            cartId: res.data["cartId"],
                            storeId: res.data["storeId"],
                            storeAddress: Address(
                              lat: (res.data['storeAdresse']['coordinates']
                                          [1] ??
                                      0)
                                  .toDouble(),
                              lng: (res.data['storeAdresse']['coordinates']
                                          [0] ??
                                      0)
                                  .toDouble(),
                              city: "",
                              streetName: "",
                              postalCode: "",
                              countryCode: "",
                              countryName: "",
                              fullAddress: "",
                              locality: "",
                              region: "",
                            ),
                            maxDeliveryFixe:
                                (res.data['maxDeliveryFixe'] ?? 0).toDouble(),
                            maxDeliveryKm:
                                (res.data['maxDeliveryKm'] ?? 0).toDouble(),
                            reservation: false,
                            pickupPersons: pickupPersons ?? [],
                            cards: cards)));
              } catch (e) {
                print(e.toString());
              }
            }
          } else {
            ToastSnackbar().init(context).showToast(
                message: "Try again !", type: ToastSnackbarType.error);
          }

          _loadingOrder = false;
          notifyListeners();
        } on DioError catch (e) {
          _loadingOrder = false;
          notifyListeners();

          if (e.response != null) {
            /// Display Error Response
            ToastSnackbar().init(context).showToast(
                message: "${e.response}", type: ToastSnackbarType.error);
          } else {
            /// Display Error Message
            ToastSnackbar()
                .init(context)
                .showToast(message: e.message, type: ToastSnackbarType.error);
          }
        }
      }
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SignupScreen()),
          (Route<dynamic> route) => true);
    }
  }

  Future addToCart(BuildContext context, Product product,
      ProductVariant productVariant, Store? store, int quantity,
      {int noredirection = 0}) async {
    // Get all items in the box
    if (store != null) {
      // start the loading animation
      _loadingAdd = true;
      notifyListeners();

      /// if store already exists, add order
      if (cartItemsBox.containsKey(productVariant.id)) {
        final CartItem _cartItem = cartItemsBox.get(productVariant.id);
        _cartItem.orderedQuantity++;
        _cartItem.save();
      } else {
        /// the cartItem that will be modified or inserted
        final CartItem _cartItem =
            CartItem.fromProduct(product, productVariant, quantity, true);
        cartItemsBox.put(productVariant.id, _cartItem);

        /// if store exists, add [CartItem.key] to the existing [CartOrder]
        /// otherwise, creates a new [CartOrder]
        if (cartBox.containsKey(store.id)) {
          Cart _cart = cartBox.get(store.id);
          _cart.cartItemsKeys!.add(productVariant.id!);
          _cart.save();
        } else {
          // the cart that will be modified or inserted
          final Cart _cart = Cart(
            storeId: store.id,
            storeName: store.name,
            cartItemsKeys: [productVariant.id!],
          );
          cartBox.put(store.id, _cart);
        }
      }

      /// open hive box
      var credentialsBox = Boxes.getCredentials();
      String? _id = credentialsBox.get('id');
      String? _token = credentialsBox.get('token');

      /// dataForm is already a parameter

      /// post the dataForm via dio call
      if (_token != null) {
        try {
          Dio dio = Dio();
          dio.options.headers["token"] = "Bearer $_token";
          var res = await dio.post(BASE_API_URL + '/cart/add/', data: {
            "productId": product.id,
            "quantity": quantity,
            "variantId": productVariant.id
          });
          if (res.statusCode == 200) {
            // stop the loading animation
            _loadingAdd = false;
            notifyListeners();

            /// Display Results Message
            ToastSnackbar().init(context).showToast(
                message: "Product Successfully added to Cart!",
                type: ToastSnackbarType.success);
            if (noredirection == 0) {
              Navigator.pop(context);
            } else {
              print("add to cart order");
              order(context, store.id);
            }
          }
        } on DioError catch (e) {
          if (e.response != null) {
            /// Display Error Response
            ToastSnackbar().init(context).showToast(
                message: "${e.response}", type: ToastSnackbarType.error);
          } else {
            /// Display Error Message
            ToastSnackbar()
                .init(context)
                .showToast(message: e.message, type: ToastSnackbarType.error);
          }
        }
      } else {
        /// Display Results Message
        ToastSnackbar().init(context).showToast(
            message: "Product Successfully added to Cart!",
            type: ToastSnackbarType.success);
        if (noredirection == 0) {
          Navigator.pop(context);
        } else {
          order(context, store!.id);
        }
      }
    }
  }

  Future deleteOrderFromCart(String key) async {
    List<String> _itemKeys = [];
    cartItemsBox.values.forEach((item) {
      if (item.storeId == key) _itemKeys.add(item.variantId);
    });
    cartItemsBox.deleteAll(_itemKeys);
    cartBox.delete(key);
    notifyListeners();
  }

  Future deleteItemFromCart(String key) async {
    Cart _cart = cartBox.get(cartItemsBox.get(key).storeId!);
    _cart.cartItemsKeys!.remove(key);
    if (_cart.cartItemsKeys!.isEmpty) cartBox.delete(_cart.storeId);
    cartItemsBox.delete(key);
    notifyListeners();
  }

  Future reservation(BuildContext context, String? orderId) async {
    /// open hive box
    ///
    print("reservation");
    var credentialsBox = Boxes.getCredentials();
    String? _id = credentialsBox.get('id');
    String? _token = credentialsBox.get('token');

    if (_token != null) {
      // _loadingOrder = true;
      // notifyListeners();

      //get pre order item from backend (current values) ;
      try {
        Dio dio = Dio();
        dio.options.headers["token"] = "Bearer $_token";
        var res = await dio.post(BASE_API_URL + '/order/preReeservation',
            data: {"orderId": orderId});
        if (res.statusCode == 200) {
          List<ProductCart> preOrderProducts = [];
          if (res.data["items"] != null) {
            var products = json.decode(res.data["items"]);
            for (var prod in products) {
              if (prod["error"] == null) {
                String prodName = prod["name"] + " ( ";
                List<Map<String, String>> preOrderItemCharac = [];
                prod["characterstics"].forEach((item) {
                  prodName += item["value"].toString() + " , ";
                  preOrderItemCharac.add({
                    "name": item["name"].toString(),
                    "value": item["value"].toString()
                  });
                });

                var prodInsert = ProductCart(
                  id: prod["id"],
                  productId: prod["productId"],
                  variantId: prod["variantId"],
                  name: prodName.substring(0, prodName.length - 2) + ")",
                  characteristics: preOrderItemCharac,
                  image: prod["image"],
                  price: double.parse(prod["price"].toString()),
                  quantity: prod["quantity"],
                  discount: prod["discount"].toDouble(),
                  reservationPolicy: prod["reservationPolicy"] != null,
                  deliveryPolicy: prod["deliveryPolicy"] != null,
                  pickupPolicy: prod["pickupPolicy"] != null,
                  reservationP: double.parse(prod["reservationP"].toString()),
                  deliveryP: double.parse(prod["deliveryP"].toString()),
                  reservation: prod["reservation"] == true ||
                      prod["reservation"] == 'true',
                  delivery:
                      prod["delivery"] == true || prod["delivery"] == 'true',
                  pickup: prod["pickup"] == true || prod["pickup"] == 'true',
                );
                preOrderProducts.add(prodInsert);
              }
            }
          }

          _loadingOrder = false;
          notifyListeners();

          /// Display Results Message
          ToastSnackbar().init(context).showToast(
              message: "Loading Order Validation with success",
              type: ToastSnackbarType.success);

          if (preOrderProducts.isNotEmpty) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CartSliderScreen(
                        products: preOrderProducts,
                        cartId: res.data["cartId"],
                        storeId: res.data["storeId"],
                        orderId: orderId,
                        storeAddress: Address(
                          lat: (res.data['storeAdresse']['coordinates'][1] ?? 0)
                              .toDouble(),
                          lng: (res.data['storeAdresse']['coordinates'][0] ?? 0)
                              .toDouble(),
                          city: "",
                          streetName: "",
                          postalCode: "",
                          countryCode: "",
                          countryName: "",
                          fullAddress: "",
                          locality: "",
                          region: "",
                        ),
                        maxDeliveryFixe:
                            (res.data['maxDeliveryFixe'] ?? 0).toDouble(),
                        maxDeliveryKm:
                            (res.data['maxDeliveryKm'] ?? 0).toDouble(),
                        reservation: true)));
          }
        } else {
          ToastSnackbar()
              .init(context)
              .showToast(message: "Try again !", type: ToastSnackbarType.error);
        }

        _loadingOrder = false;
        notifyListeners();
      } on DioError catch (e) {
        _loadingOrder = false;
        notifyListeners();

        if (e.response != null) {
          /// Display Error Response
          ///
          // stop the loading animation
          print(e.response);
          ToastSnackbar().init(context).showToast(
              message: "${e.response}", type: ToastSnackbarType.error);
        } else {
          print(e.message);

          /// Display Error Message
          ToastSnackbar()
              .init(context)
              .showToast(message: e.message, type: ToastSnackbarType.error);
        }
      }
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SignupScreen()),
          (Route<dynamic> route) => true);
    }
  }
}
