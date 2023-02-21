import 'package:proximity/config/backend.dart';
import 'package:proximity_commercant/domain/product_repository/models/models.dart';

class OrderItem {
  String? id;
  String? name;
  String? productId;
  String? variantId;
  String? variantName;
  String? categoryName;
  List<dynamic>? characteristics;
  String? image;
  double? price;
  double discount;
  DateTime? discountEndDate;
  String? storeId;
  int orderedQuantity;

  OrderItem({
    this.id,
    this.name,
    this.variantId,
    this.variantName,
    this.categoryName,
    this.characteristics,
    this.image,
    this.price,
    this.discount = 0.0,
    this.discountEndDate,
    this.storeId,
    this.orderedQuantity = 1,
  });

  OrderItem.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['_id'],
        productId = parsedJson['productId'],
        variantId = parsedJson['variantId'],
        orderedQuantity = parsedJson['quantity'],
        price = parsedJson['totalPrice'].toDouble(),
        discount = parsedJson['discount'].toDouble(),
        name = 'MacBook Pro',
        variantName = '',
        categoryName = '',
        characteristics = [
          {'name': 'Color', 'value': 'Blue'},
          {'name': 'Language', 'value': 'English'},
        ],
        image = BASE_IMG_URL+'/'+'images/variantes/c14fd16f-8e3b-4e59-9fca-75d11259aecfw-macbook-color-1.jfif';

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
        discountEndDate: discountEndDate,
        storeId: storeId,
      );
}
