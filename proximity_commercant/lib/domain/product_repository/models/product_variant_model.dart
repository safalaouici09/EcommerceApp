import 'package:proximity/config/backend.dart';

class ProductVariant {
  String? id;
  List<dynamic>? characteristics;
  dynamic image;
  bool? available;
  double? price;
  int? quantity;
  String? variantName;

  ProductVariant({
    this.id,
    this.variantName,
    this.characteristics,
    this.image,
    this.available = true,
    this.quantity,
  });

  ProductVariant.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['_id'],
        variantName = "variant",
        characteristics = parsedJson['characterstics'],
        image = BASE_IMG_URL + '/' + parsedJson['img'],
        price = (parsedJson['price'] ?? 0.0).toDouble(),
        quantity = parsedJson['quantity'],
        available = parsedJson['available'];

  static List<ProductVariant> productVariantsFromJsonList(
      List<dynamic> parsedJson) {
    List<ProductVariant> _list = [];
    for (int i = 0; i < parsedJson.length; i++) {
      _list.add(ProductVariant.fromJson(parsedJson[i]));
    }
    return _list;
  }

  bool get isValid => (characteristics!.every((item) => item != null) &&
      (price != null) &&
      (quantity != null));
}
