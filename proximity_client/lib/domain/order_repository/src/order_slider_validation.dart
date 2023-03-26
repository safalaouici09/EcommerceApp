import 'package:flutter/material.dart';
import 'package:proximity_client/domain/store_repository/models/models.dart';
import 'package:proximity_client/domain/cart_repository/cart_repository.dart';
import 'package:proximity_client/ui/pages/product_pages/widgets/widgets.dart';
import 'package:proximity_client/domain/product_repository/product_repository.dart';

class OrderSliderValidation with ChangeNotifier  {
  ShippingMethod? _shippingMethod;
  List<ProductCart> _products = [
    ProductCart(
            id : "0" ,
            variantId : "0",
            name : "Xiaomi All",
            variantName : "Variant name",
            categoryName : "Categorie name",
            characteristics : [
                {"name": "Color", "value": "Beige"},
                {"name": "Language", "value": "Français"}
            ],
            image : "images/variantes/product1-variant.png",
            price : 50.00 ,
            quantity : 10,
            discount : 0.0,
            discountEndDate :  DateTime.now().add(const Duration(days: 31, hours: 23, minutes: 48, seconds: 3)),
            storeId : "0",
            orderedQuantity : 5,
            reservation : false ,
            reservationP : 0.2 ,
            delivery : false ,
            deliveryP : 0.05 ,
            pickup : true ,
            reservationPolicy : true,
            deliveryPolicy : true,
            pickupPolicy : true,
    ) , 
    ProductCart(
            id : "1" ,
            variantId : "1",
            name : "Xiaomi Pickup/Delivery",
            variantName : "Variant name 2",
            categoryName : "Categorie name 2",
            characteristics : [
                {"name": "Color", "value": "Vert"},
                {"name": "Language", "value": "Français"}
            ],
            image : "images/products/product3.png",
            price : 70.00 ,
            quantity : 5,
            discount : 0.0,
            discountEndDate :  DateTime.now().add(const Duration(days: 31, hours: 23, minutes: 48, seconds: 3)),
            storeId : "0",
            orderedQuantity : 5,
            reservation : false ,
            reservationP : 0.5 ,
            delivery : false ,
            deliveryP : 0.1 ,
            pickup : true ,
            reservationPolicy : false,
            deliveryPolicy : true,
            pickupPolicy : true,
    ), 
    ProductCart(
            id : "2" ,
            variantId : "2",
            name : "Xiaomi Delivery Only",
            variantName : "Variant name 3",
            categoryName : "Categorie name 3",
            characteristics : [
                {"name": "Color", "value": "Bleu"},
                {"name": "Language", "value": "Français"}
            ],
            image : "images/products/product2.png",
            price : 5.00 ,
            quantity : 3,
            discount : 0.0,
            discountEndDate :  DateTime.now().add(const Duration(days: 31, hours: 23, minutes: 48, seconds: 3)),
            storeId : "0",
            orderedQuantity : 5,
            reservation : false ,
            reservationP : 1.0 ,
            delivery : false ,
            deliveryP : 0.0 ,
            pickup : true ,
            reservationPolicy : false,
            deliveryPolicy : false,
            pickupPolicy : true,
    ) , 
    ProductCart(
            id : "3" ,
            variantId : "3",
            name : "Xiaomi All with Discount",
            variantName : "Variant name 3",
            categoryName : "Categorie name 3",
            characteristics : [
                {"name": "Color", "value": "Beige"},
                {"name": "Language", "value": "Anglais"}
            ],
            image : "images/products/product1.png",
            price : 50.00 ,
            quantity : 10,
            discount : 0.3,
            discountEndDate :  DateTime.now().add(const Duration(days: 31, hours: 23, minutes: 48, seconds: 3)),
            storeId : "0",
            orderedQuantity : 5,
            reservation : false ,
            reservationP : 0.2 ,
            delivery : false ,
            deliveryP : 0.05 ,
            pickup : true ,
            reservationPolicy : true,
            deliveryPolicy : true,
            pickupPolicy : true,
    )
  ];


  // Getters
  ShippingMethod? get shippingMethod => _shippingMethod;
  List<ProductCart> get products => _products;

  // Setters
  void toggleReservation(List<dynamic> value) {
     int index = _products.indexWhere((item) => item.id == value[1]);
      if (index != -1) {
        _products[index].reservation = value[0];
        if(value[0]) {
            if(_products[index].pickupPolicy){
             _products[index].delivery = false;
             _products[index].pickup = true;
            }else {
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
        if(value[0]) {
             _products[index].delivery = false;
        }else if(!_products[index].delivery) {
         _products[index].pickup = true;
        }
      }
    notifyListeners();
  }

  
  void toggleDelivery(List<dynamic> value) {
     int index = _products.indexWhere((item) => item.id == value[1]);
      if (index != -1 && _products[index].pickupPolicy) {
        _products[index].delivery = value[0];
        if(value[0]) {
             _products[index].pickup = false;
        }else if(!_products[index].pickup) {
         _products[index].delivery = true;
        }
      }
    notifyListeners();
  }

  

  
  void changeQuantity(int value , String? id) {
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
    List<ProductCart> items = [..._products] ;
    items.removeWhere((item) => item.reservation != true);
    return items ;
  }

  double getReservationItemsTotal() {
    double total = 0.0 ;
    _products.forEach((item) => {
      if(item.reservation == true) {
        total += item.price! * (item.quantity ) * (1 -  item.reservationP)* (1 - item.discount)     
      }
    });
    return total ;
  }

  List<ProductCart> getDeliveryItems() {
    List<ProductCart> items = [..._products] ;
    items.removeWhere((item) => (item.reservation == true || item.delivery != true));
    return items ;
  }

  double getDeliveryItemsTotal() {
    double total = 0.0 ;
    _products.forEach((item) => {
      if(item.reservation != true  && item.delivery == true) {
        total +=   item.price! * (item.quantity ) *  (1 + item.deliveryP)* (1 - item.discount)
      }
    });
    return total ;
  }

  List<ProductCart> getPickupItems() {
    List<ProductCart> items = [..._products] ;
    items.removeWhere((item) => (item.reservation == true || item.pickup != true));
    return items ;
  }

  double getPickupItemsTotal() {
    double total = 0.0 ;
    _products.forEach((item) => {
      if(item.reservation != true && item.pickup == true) {
        total +=   item.price! * (item.quantity ) * (1 - item.discount)
      }
    });
    return total ;
  }

  OrderSliderValidation();
}
