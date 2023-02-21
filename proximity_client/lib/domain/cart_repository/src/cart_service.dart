import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/cart_repository/cart_repository.dart';
import 'package:proximity_client/domain/data_persistence/data_persistence.dart';
import 'package:proximity_client/domain/order_repository/models/models.dart';
import 'package:proximity_client/domain/order_repository/src/order_confirmation.dart';
import 'package:proximity_client/domain/product_repository/models/models.dart';
import 'package:proximity_client/domain/store_repository/store_repository.dart';
import 'package:proximity_client/ui/pages/pages.dart';

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
  Future order(BuildContext context, String storeId) async {
    /// get total price
    final double _totalPrice = getTotalPrice(storeId);

    /// get Store Policy
    final Policy _policy = Policy.policy;

    /// convert [List<CartItem>] into [List<OrderItem>]
    final List<OrderItem> _orderItems = [];
    cartItemsBox.values.forEach((item) {
      if (item.storeId == storeId) {
        _orderItems.add(OrderItem.fromCartItem(item));
      }
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderConfirmationScreen(
                  orderItems: _orderItems,
                  totalPrice: _totalPrice,
                  policy: _policy,
                )));
  }

  Future addToCart(BuildContext context, Product product,
      ProductVariant productVariant, Store store, int quantity) async {
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
    String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
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
        Navigator.pop(context);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        /// Display Error Response
        ToastSnackbar()
            .init(context)
            .showToast(message: "${e.response}", type: ToastSnackbarType.error);
      } else {
        /// Display Error Message
        ToastSnackbar()
            .init(context)
            .showToast(message: e.message, type: ToastSnackbarType.error);
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
}
