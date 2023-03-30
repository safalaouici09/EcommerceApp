import 'product_variant_model.dart';
import 'package:proximity/config/backend.dart';
import 'package:proximity_client/domain/store_repository/models/policy_model.dart' ;

class ProductCart {
  String? id;
  String? variantId;
  String? name;
  String? variantName;
  String? categoryName;
  List<Map<String , String >>? characteristics;
  String? image;
  double? price;
  int quantity;
  double discount;
  DateTime? discountEndDate;
  String? storeId;
  int orderedQuantity;
  bool reservation;
  double reservationP;
  bool delivery;
  double deliveryP;
  bool pickup;
  bool reservationPolicy;
  bool deliveryPolicy;
  bool pickupPolicy;
  // Policy? policy ;

  ProductCart(
      {
        this.id,
        this.variantId,
        this.name,
        this.variantName,
        this.categoryName,
        this.characteristics,
        this.image,
        this.price,
        this.quantity = 0,
        this.discount = 0.0,
        this.discountEndDate,
        this.storeId,
        this.orderedQuantity = 0,
        this.reservation = false,
        this.reservationP = 0.0,
        this.delivery = false,
        this.deliveryP = 0.0,
        this.pickup = false,
        this.reservationPolicy = true,
        this.deliveryPolicy = true,
        this.pickupPolicy = true,
      });

}
