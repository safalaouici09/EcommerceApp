import 'package:proximity/proximity.dart';
import 'package:proximity_commercant/domain/product_repository/models/models.dart';

class OrderItem {
  String? id;
  String? name;
  String? productId;
  String? variantId;
  String? image;
  double? price;
  double discount;
  int orderedQuantity;
  double? reservation;

  OrderItem(
      {this.id,
      this.name,
      this.variantId,
      this.image,
      this.price,
      this.discount = 0.0,
      this.orderedQuantity = 1,
      this.reservation = 0.0});

  OrderItem.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['_id'],
        name = parsedJson['name'],
        productId = parsedJson['productId'],
        variantId = parsedJson['variantId'],
        orderedQuantity = parsedJson['quantity'],
        price = parsedJson['price'].toDouble(),
        discount = parsedJson['discount'].toDouble(),
        reservation = (parsedJson['reservation'] ?? 0.0).toDouble(),
        image = BASE_IMG_URL + '/' + parsedJson['image'];

  static List<OrderItem> orderItemsFromJsonList(List<dynamic> parsedJson) {
    List<OrderItem> _list = [];
    for (int i = 0; i < parsedJson.length; i++) {
      _list.add(OrderItem.fromJson(parsedJson[i]));
    }
    return _list;
  }

  Product toProduct() => Product(
      id: id,
      name: name,
      price: price,
      discount: discount,
      reservation: reservation);
}
