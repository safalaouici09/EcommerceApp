import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:proximity/config/config.dart';
import 'package:proximity/domain_repository/domain_repository.dart';
import 'package:proximity_commercant/domain/product_repository/models/models.dart';

class ProductCreationValidation with ChangeNotifier {
  String? _id;
  String? _storeId;
  ValidationItem _name = ValidationItem(null, null);
  ValidationItem _description = ValidationItem(null, null);
  ValidationItem _category = ValidationItem(null, null);
  double? _price;
  int? _quantity;
  Map<String, Set<String>> _characteristics = {};
  List<ProductVariant> _variants = [];
  List<dynamic> _images = [];

  ProductCreationValidation();

  ProductCreationValidation.setProduct(Product product) {
    _id = product.id;
    _storeId = product.storeId;
    _name = ValidationItem(product.name, null);
    _description = ValidationItem(product.description, null);
    _category = ValidationItem(product.categoryId, null);
    _price = product.price ?? 0.0;
    _quantity = product.quantity ?? 0;

    /// Setting up Characteristics
    if (product.variants != null) {
      for (var variantCharacteristic
          in product.variants!.first.characteristics!) {
        _characteristics.addAll({variantCharacteristic['name']: <String>{}});
      }
      for (var variant in product.variants!) {
        for (var variantCharacteristic in variant.characteristics!) {
          _characteristics[variantCharacteristic['name']]!
              .add(variantCharacteristic['value']);
        }
      }
    }

    /// Setting up product variants
    if (product.variants != null) {
      _variants.addAll(product.variants!);
    }

    /// Setting up product images
    if (product.images != null) {
      _images = product.images!;
    }
  }

  // Getters
  ValidationItem get name => _name;

  ValidationItem get description => _description;

  ValidationItem get category => _category;

  double? get price => _price;

  int? get quantity => _quantity;

  Map<String, Set<String>> get characteristics => _characteristics;

  String get characteristicsTitle {
    if (_characteristics.isEmpty) {
      return "Edit Characteristics.";
    } else {
      return "${_characteristics.entries.map((e) => "${e.key}(${e.value.length})").toList()}"
          .replaceAll("[", "")
          .replaceAll("]", "");
    }
  }

  List<ProductVariant> get variants => _variants;

  int get variantsMaxSize {
    int _maxSize = 1;
    for (Set<String> e in _characteristics.values) {
      _maxSize = e.length * _maxSize;
    }
    if (_maxSize < 17) {
      return _maxSize;
    } else {
      return 16;
    }
  }

  List<dynamic> get images => _images;

  // checks if forms is valid and verified
  bool get isValid {
    if (_name.value != null && _description.value != null) {
      return true;
    } else {
      return false;
    }
  }

  // Setters
  void changeName(String value) {
    if (value.isEmpty) {
      _name = ValidationItem(null, null);
      notifyListeners();
    } else if (value.length > 3) {
      _name = ValidationItem(value, null);
      notifyListeners();
    } else {
      _name = ValidationItem(null, "Name must be at least 3 characters");
    }
    Future.delayed(largeAnimationDuration, () {
      notifyListeners();
    });
  }

  void changeDescription(String value) {
    if (value.isEmpty) {
      _description = ValidationItem(null, null);
      notifyListeners();
    } else if (value.length > 20) {
      _description = ValidationItem(value, null);
      notifyListeners();
    } else {
      _description =
          ValidationItem(null, "Description must be at least 20 characters");
    }
    Future.delayed(largeAnimationDuration, () {
      notifyListeners();
    });
  }

  void changeCategory(String value, int index) {
    _category = ValidationItem(value, null);
    notifyListeners();
  }

  void changePrice(String value) {
    _price = double.parse(value);
    notifyListeners();
  }

  void changeQuantity(String value) {
    _quantity = int.tryParse(value);
    notifyListeners();
  }

  void changeCharacteristics(Map<String, Set<String>> newCharacteristics) {
    _characteristics =
        newCharacteristics.map((key, value) => MapEntry(key, value.toSet()));
    _variants = [];
    notifyListeners();
  }

  /// variant creator
  void addVariant(ProductVariant variant) {
    _variants.add(variant);
    notifyListeners();
  }

  void removeVariant(int index) {
    _variants.removeAt(index);
    notifyListeners();
  }

  /// image Picker
  void addProductImage(List<dynamic> imageList) {
    _images = imageList;
    notifyListeners();
  }

  void removeProductImage(int index) {
    //if (_shopImages[index] is String) _deletedImages.add(_shopImages[index]);
    _images.removeAt(index);
    notifyListeners();
  }

  String _variantsFormData() {
    String _formData = "[";
    List<String> _car = [];
    for (var v in _variants) {
      _formData += '{"characterstics": [';
      for (var c in v.characteristics!) {
        _formData += '''{
          "name": "${c.key}",
          "value": "${c.value}"
        },''';
      }
      if (_formData.endsWith(',')) {
        _car = _formData.characters.toList();
        _car.removeLast();
        _formData = _car.join("");
      }
      _formData += '], "price": ${v.price}, "quantity": ${v.quantity}},';
    }
    if(_formData.endsWith(',')) {
      _car = _formData.characters.toList();
      _car.removeLast();
      _formData = _car.join("");
    }
    _formData += "]";
    print('XXXX${_formData}');
    return _formData;
  }

  /// A method to convert this form validator into a Store object
  FormData toFormData() {
    FormData _formData = FormData.fromMap({
      "name": name.value,
      "description": description.value,
      "categoryId": category.value,
      "price": price,
      // "quantity": quantity,
      "variantes": _variantsFormData(),
      "storeId": _storeId,
    });
    
    if (_images.isNotEmpty) {
      for (var v in _images) {
      if (v is File) {
        _formData.files.add(MapEntry(
            'images', MultipartFile.fromFileSync(v.path)));
      }}
    }
    if (_variants.isNotEmpty) {
      for (ProductVariant v in _variants) {
        if (v.image is File) {
          _formData.files.add(MapEntry(
              'varientsImages', MultipartFile.fromFileSync(v.image.path)));
        }
      }
    }
    return _formData;
  }
}
