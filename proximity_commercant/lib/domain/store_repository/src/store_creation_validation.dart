import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:proximity/config/values.dart';
import 'package:proximity/domain_repository/domain_repository.dart';
import 'package:proximity_commercant/domain/store_repository/store_repository.dart';

class StoreCreationValidation with ChangeNotifier {
  String? _id;
  ValidationItem _storeName = ValidationItem(null, null);
  ValidationItem _storeDescription = ValidationItem(null, null);
  ValidationItem _storeCategory = ValidationItem(null, null);
  bool _selfPickup = false;
  bool _selfPickupFree = false;
  bool _selfPickupPartial = false;
  bool _selfPickupTotal = false;
  bool _delivery = false;
  double? _tax;
  double? _selfPickupPrice;
  bool? _openWeekend;
  bool? _openDay;
  bool? _openNight;
  TimeOfDay? _openTime = TimeOfDay(hour: 09, minute: 00);
  TimeOfDay? _closeTime = TimeOfDay(hour: 18, minute: 00);
  Address _storeAddress = Address();
  List<dynamic> _storeImages = [];
  List<String> _deletedImages = [];

  StoreCreationValidation();

  StoreCreationValidation.setStore(Store store) {
    _id = store.id;
    _storeName = ValidationItem(store.name, null);
    // _storeCategory = ValidationItem(store.category?.toString(), null);
    _storeDescription = ValidationItem(store.description, null);
    if (store.policy != null) {
      _selfPickupFree = store.policy!.shippingMethods!
          .contains(ShippingMethod.selfPickupFree);
      _selfPickupPartial = store.policy!.shippingMethods!
          .contains(ShippingMethod.selfPickupPartial);
      _selfPickupTotal = store.policy!.shippingMethods!
          .contains(ShippingMethod.selfPickupTotal);
      _selfPickup = _selfPickupFree || _selfPickupPartial || _selfPickupTotal;
      _delivery =
          (store.policy!.shippingMethods!.contains(ShippingMethod.delivery));
      _tax = store.policy!.tax;
      _selfPickupPrice = store.policy!.selfPickUpPrice;
      _openWeekend = store.policy!.openWeekend;
      _openDay = store.policy!.openDay;
      _openNight = store.policy!.openNight;
      // _openTime = DateTime.parse(store.policy!.openTime!);
      // _closeTime = DateTime.parse(store.policy!.closeTime!);
    }
    if (store.address != null) {
      _storeAddress = store.address!;
    }
    if (store.image != null) {
      _storeImages = [store.image!];
    }
  }

  // Getters
  ValidationItem get storeName => _storeName;

  ValidationItem get storeCategory => _storeCategory;

  ValidationItem get storeDescription => _storeDescription;

  bool? get selfPickup => _selfPickup;

  bool? get selfPickupFree => _selfPickupFree;

  bool? get selfPickupPartial => _selfPickupPartial;

  bool? get selfPickupTotal => _selfPickupTotal;

  bool? get delivery => _delivery;

  double? get tax => _tax;

  double? get selfPickupPrice => _selfPickupPrice;

  bool? get openWeekend => _openWeekend;

  TimeOfDay? get openTime => _openTime;

  TimeOfDay? get closeTime => _closeTime;

  Address get storeAddress => _storeAddress;

  List<dynamic> get storeImages => _storeImages;

  List<String> get deletedImages => _deletedImages;

  // checks if forms is valid and verified
  bool get isValid {
    if (_storeName.value != null &&
        _storeDescription.value != null &&
        (_selfPickup || _delivery) &&
        // _shopCategory.value != null &&
        _storeAddress.isAddressValid) {
      return true;
    } else {
      return false;
    }
  }

  // Setters
  void changeStoreName(String value) {
    if (value.length > 3) {
      _storeName = ValidationItem(value, null);
      notifyListeners();
    } else if (value.isEmpty) {
      _storeName = ValidationItem(null, null);
      notifyListeners();
    } else {
      _storeName = ValidationItem(null, "Name must be at least 3 characters");
    }
    Future.delayed(largeAnimationDuration, () {
      notifyListeners();
    });
  }

  void changeStoreCategory(int value, int index) {
    _storeCategory = ValidationItem(value.toString(), null);
    notifyListeners();
  }

  void changeStoreDescription(String value) {
    if (value.length > 20) {
      _storeDescription = ValidationItem(value, null);
      notifyListeners();
    } else if (value.isEmpty) {
      _storeDescription = ValidationItem(null, null);
      notifyListeners();
    } else {
      _storeDescription =
          ValidationItem(null, "Description must be at least 20 characters");
    }
    Future.delayed(largeAnimationDuration, () {
      notifyListeners();
    });
  }

  /// Policy Form Validators
  void toggleSelfPickup() {
    _selfPickup = !_selfPickup;
    notifyListeners();
  }

  void toggleSelfPickupFree(bool value) {
    _selfPickupFree = value;
    if (value) {
      _selfPickupPartial = false;
      _selfPickupTotal = false;
    }
    notifyListeners();
  }

  void toggleSelfPickupPartial(bool value) {
    _selfPickupPartial = value;
    if (value) {
      _selfPickupFree = false;
      _selfPickupTotal = false;
    }
    notifyListeners();
  }

  void toggleSelfPickupTotal(bool value) {
    _selfPickupTotal = value;
    if (value) {
      _selfPickupFree = false;
      _selfPickupPartial = false;
    }
    notifyListeners();
  }

  void toggleDelivery() {
    _delivery = !_delivery;
    if (!_delivery) {
      _tax = null;
    }
    notifyListeners();
  }

  void changeTax(String value) {
    _tax = double.tryParse(value);
    notifyListeners();
  }

  void changeSelfPickupPrice(String value) {
    _selfPickupPrice = double.tryParse(value);
    notifyListeners();
  }

  /// Address Form Validators
  void changeAddress(Address newAddress) {
    _storeAddress = newAddress;
    notifyListeners();
  }

  void changeFullAddress(String value) {
    _storeAddress.fullAddress = value;
    notifyListeners();
  }

  void changeStreetName(String value) {
    _storeAddress.streetName = value;
    notifyListeners();
  }

  void changeCountry(String code, int index) {
    _storeAddress.countryCode = code;
    _storeAddress.countryName = countryList[code];
    notifyListeners();
  }

  void changeRegion(String value) {
    _storeAddress.region = value;
    notifyListeners();
  }

  void changeCity(String value) {
    _storeAddress.city = value;
    notifyListeners();
  }

  void changePostalCode(String value) {
    _storeAddress.postalCode = value;
    notifyListeners();
  }

  /// image Picker
  void addStoreImage(List<dynamic> imageList) {
    _storeImages = imageList;
    notifyListeners();
  }

  void removeStoreImage(int index) {
    _storeImages.removeAt(index);
    notifyListeners();
  }

  getStartTime(BuildContext context, TimeOfDay? initTime) async {
    var newOpenTime = await showTimePicker(
      context: context,
      initialTime: initTime!,
    );
    if (newOpenTime == null) {
      return;
    } else {
      _openTime = newOpenTime;
    }
    notifyListeners();
  }

  getClosingTime(BuildContext context, TimeOfDay? initTime) async {
    var newCloseTime =
        await showTimePicker(context: context, initialTime: initTime!);
    // notifyListeners();

    if (newCloseTime == null) {
      return;
    } else {
      _closeTime = newCloseTime;
    }
    notifyListeners();
  }

  /// A method to convert this form validator into a Store object
  FormData toFormData() {
    FormData _formData = FormData.fromMap({
      "name": storeName.value,
      "description": storeDescription.value,
      // "isVerified": false,
      "location": '''{
        "type": "Point",
        "coordinates": [${storeAddress.lat ?? 0.0}, ${storeAddress.lng ?? 0.0}]
      }''',
      "address": '''{
        "city": "${storeAddress.city ?? ""}",
        "streetName": "${storeAddress.streetName ?? ""}",
        "postalCode": "${storeAddress.postalCode ?? ""}",
        "fullAdress": "${storeAddress.fullAddress ?? ""}",
        "region": "${storeAddress.region ?? ""}",
        "country": "${storeAddress.countryName ?? ""}",
        "countryCode": "FR"
      }''',
      "policies": '''{
        "selfPickUp": "${(selfPickupFree ?? false) ? "free" : (selfPickupPartial ?? false) ? "partial" : (selfPickupTotal ?? false) ? "total" : ""}",
        "selfPickUpPrice": ${_selfPickupPrice ?? 0},
        "delivery": ${delivery ?? false},
        "tax": ${tax ?? 0},
        "openWeekend": true,
        "openTime": "8:00",
        "closeTime": "17:00"
      }'''
    });
    if (_storeImages.isNotEmpty) {
      if (_storeImages.first is File) {
        print("pef" + _storeImages.first.path);
        _formData.files.add(MapEntry(
            'image', MultipartFile.fromFileSync(_storeImages.first.path)));
      }
    }
    return _formData;
  }
}