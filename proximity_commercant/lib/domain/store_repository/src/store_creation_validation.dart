import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:proximity/config/backend.dart';
import 'package:proximity/config/values.dart';
import 'package:proximity/domain_repository/domain_repository.dart';
import 'package:proximity/widgets/toast_snackbar/toast_snackbar.dart';
import 'package:proximity_commercant/domain/data_persistence/src/boxes.dart';
import 'package:proximity_commercant/domain/store_repository/store_repository.dart';
import 'package:proximity_commercant/domain/user_repository/models/user_model.dart';
import 'package:proximity_commercant/ui/pages/store_pages/widgets/widgets.dart';

class StoreCreationValidation with ChangeNotifier {
  String? _id;
  ValidationItem _storeName = ValidationItem(null, null);
  ValidationItem _storeDescription = ValidationItem(null, null);
  ValidationItem _storeCategory = ValidationItem(null, null);
  bool _selfPickup = false;
  bool _shippingFixedPrice = false;
  bool _shippingPerKm = false;
  bool _selfPickupFree = false;
  bool _selfPickupPartial = false;
  bool _selfPickupTotal = false;
  bool _returnShippingFee = false;
  bool _returnTotalFee = false;
  bool _returnPartialFee = false;
  int? _returnPerFee;
  String? _returnCondition;
  bool _delivery = false;
  double? _tax;
  double? _shippingPerKmTax;
  double? _shippingFixedPriceTax;
  double? _selfPickupPrice;
  bool? _openWeekend;
  bool? _openDay;
  bool? _openNight;
  bool _notifSms = false;
  bool _notifEmail = false;
  bool _notifInPlateforme = true;
  bool _notifPopUp = false;

  bool? _globalPolicy = false;
  bool? _customPolicy = false;
  TimeOfDay? _openTime = TimeOfDay(hour: 09, minute: 00);
  TimeOfDay? _closeTime = TimeOfDay(hour: 18, minute: 00);
  Address _storeAddress = Address();
  List<dynamic> _storeImages = [];
  List<String> _deletedImages = [];
  double _shippingMaxKM = 10;

  bool _reservationFree = false;

  bool _reservationPartial = false;
  bool _reservationTotal = false;
  bool _reservationConcelationFree = false;
  bool _oredersAutoValidation = false;
  bool _oredersManValidation = false;
  bool _oredersMixValidation = false;
  bool _notifRealTime = false;
  bool _notifHourly = false;
  bool _notifBatch = false;
  bool _reservationConcelationPartial = false;
  bool _returnAccept = false;
  bool _returnNotAccept = false;
  int? _reservationDuration;
  int? _notifDuration;
  int? _returnMaxDays;
  int? _selfPickUpMaxDays;
  double? _reservationtax;
  double? _reservationcancelationtax;
  bool? get reservationFree => _reservationFree;
  bool? get reservationPartial => _reservationPartial;
  bool? get reservationTotal => _reservationTotal;
  bool? get oredersAutoValidation => _oredersAutoValidation;
  bool? get oredersManValidation => _oredersManValidation;
  bool? get oredersMixValidation => _oredersMixValidation;
  bool? get notifRealTime => _notifRealTime;
  bool? get notifHourly => _notifHourly;
  bool? get notifBatch => _notifBatch;
  bool? get returnShippingFee => _returnShippingFee;
  bool? get returnPartialFee => _returnPartialFee;
  bool? get returnTotalFee => _returnTotalFee;
  int? get returnPerFee => _returnPerFee;
  bool? get reservationConcelationFree => _reservationConcelationFree;
  bool? get reservationConcelationPartial => _reservationConcelationPartial;
  int? get reservationDuration => _reservationDuration;
  int? get notifDuration => _notifDuration;
  int? get returnMaxDays => _returnMaxDays;
  int? get selfPickUplMaxDays => _selfPickUpMaxDays;
  double? get reservationtax => _reservationtax;
  double? get shippingPerKmTax => _shippingPerKmTax;
  double? get shippingFixedPriceTax => _shippingFixedPriceTax;

  double? get reservationcancelationtax => _reservationcancelationtax;
  bool? get returnAccept => _returnAccept;
  bool? get returnNotAccept => _returnNotAccept;
  double get shippingMaxKM => _shippingMaxKM;
  bool? get globalPolicy => _globalPolicy;
  bool? get customPolicy => _customPolicy;
  String? get returnCondition => _returnCondition;
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
  bool? get shippingFixedPrice => _shippingFixedPrice;
  bool? get shippingPerKm => _shippingPerKm;

  bool? get selfPickupFree => _selfPickupFree;

  bool? get selfPickupPartial => _selfPickupPartial;

  bool? get selfPickupTotal => _selfPickupTotal;

  bool? get delivery => _delivery;

  double? get tax => _tax;

  double? get selfPickupPrice => _selfPickupPrice;

  bool? get openWeekend => _openWeekend;
  bool? get notifEmail => _notifEmail;
  bool? get notifSms => _notifSms;
  bool? get notifInPlateforme => _notifInPlateforme;
  bool? get notifPopUp => _notifPopUp;

  TimeOfDay? get openTime => _openTime;

  TimeOfDay? get closeTime => _closeTime;

  Address get storeAddress => _storeAddress;

  List<dynamic> get storeImages => _storeImages;

  List<String> get deletedImages => _deletedImages;

  // checks if forms is valid and verified
  bool get isValid {
    if (_storeName.value != null &&
        _storeDescription.value != null &&
        // (_selfPickup || _delivery) &&
        // _shopCategory.value != null &&
        _storeAddress.isAddressValid) {
      return true;
    } else {
      return false;
    }
  }

  bool get shippingIsValid {
    if ((_selfPickup && _selfPickUpMaxDays != null) ||
        (_delivery &
            ((_shippingPerKm && _shippingPerKmTax != null) ||
                (_shippingFixedPrice && _shippingFixedPriceTax != null)))) {
      return true;
    } else {
      return false;
    }
  } /*

  bool get shippingIsValid {
    if ((_selfPickup &
            (_selfPickupFree ||
                (_selfPickupPartial && _selfPickupPrice != null) ||
                (_selfPickupTotal && _selfPickupPrice != null))) ||
        (_delivery &
            ((_shippingPerKm && _shippingPerKmTax != null) ||
                (_shippingFixedPrice && _shippingFixedPriceTax != null)))) {
      return true;
    } else {
      return false;
    }
  }*/

  bool get reservationIsValid {
    if ((_reservationFree ||
            (_reservationPartial && _reservationtax != null) ||
            _reservationTotal) &&
        (_reservationDuration != null) &&
        (_reservationConcelationFree ||
            (_reservationConcelationPartial &&
                _reservationcancelationtax != null))) {
      return true;
    } else {
      return false;
    }
  }

  bool get returnIsValid {
    if (_returnNotAccept ||
        (_returnAccept &&
            (_returnMaxDays != null) &&
            (_returnShippingFee ||
                _returnTotalFee ||
                (_returnPartialFee && _returnPerFee != null)))) {
      return true;
    } else {
      return false;
    }
  }

  bool get ordersIsValid {
    if ((_oredersAutoValidation ||
            _oredersManValidation ||
            _oredersMixValidation) &&
        (_notifRealTime || _notifDuration != null)) {
      return true;
    } else {
      return false;
    }
  }

  void ChangeShippingMaxKM(double value) {
    _shippingMaxKM = value;
    notifyListeners();
  }

  void incrShippingMaxKM() {
    _shippingMaxKM += 10;
    notifyListeners();
  }

  void decShippingMaxKM() {
    _shippingMaxKM -= 10;
    notifyListeners();
  }

  void changeReturnCondition(String value) {
    _returnCondition = value;
    notifyListeners();
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

  void toggleReturnShippingFee(bool value) {
    _returnShippingFee = value;

    notifyListeners();
  }

  void toggleNotifEmail(bool value) {
    _notifEmail = value;

    notifyListeners();
  }

  void toggleNotifSms(bool value) {
    _notifSms = value;

    notifyListeners();
  }

  void toggleNotifInPlateforme(bool value) {
    _notifInPlateforme = value;

    notifyListeners();
  }

  void toggleNotifPopup(bool value) {
    _notifPopUp = value;

    notifyListeners();
  }

  void toggleGlobalPolicy(
    bool value,
  ) {
    _globalPolicy = value;
    if (value) {
      _customPolicy = false;

      //StoreDialogs.gobalPolicy(context!, 1);
    }
    notifyListeners();
  }

  void toggleCustomPolicy(bool value) {
    _customPolicy = value;
    if (value) {
      _globalPolicy = false;
    }

    notifyListeners();
  }

  void toggleReturnTotalFee(bool value) {
    _returnTotalFee = value;
    if (value) {
      _returnPartialFee = false;
    }
    notifyListeners();
  }

  void toggleReturnPartialFee(bool value) {
    _returnPartialFee = value;
    if (value) {
      _returnTotalFee = false;
    }
    notifyListeners();
  }

  void toggleReturnAccept(bool value) {
    _returnAccept = value;
    if (value) {
      _returnNotAccept = false;
    }
    notifyListeners();
  }

  void toggleReturnNotAccept(bool value) {
    _returnNotAccept = value;
    if (value) {
      _returnAccept = false;
    }
    notifyListeners();
  }

  /// Policy Form Validators
  void toggleSelfPickup() {
    _selfPickup = !_selfPickup;
    if (_selfPickup) {
      _delivery = false;
    }
    notifyListeners();
  }

  void toggleShippingFixedPrice() {
    _shippingFixedPrice = !_shippingFixedPrice;
    if (_shippingFixedPrice) {
      _shippingPerKm = false;
    }
    notifyListeners();
  }

  void toggleShippingPerKm() {
    _shippingPerKm = !_shippingPerKm;
    if (_shippingPerKm) {
      _shippingFixedPrice = false;
    }
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

  void toggleReservationFree(bool value) {
    _reservationFree = value;
    if (value) {
      _reservationPartial = false;
      _reservationTotal = false;
    }
    notifyListeners();
  }

  void toggleOrdersAutoValidation(bool value) {
    _oredersAutoValidation = value;
    if (value) {
      _oredersManValidation = false;
      _oredersMixValidation = false;
    }
    notifyListeners();
  }

  void toggleNotifRealTime(bool value) {
    _notifRealTime = value;
    if (value) {
      _notifHourly = false;
      _notifBatch = false;
    }
    notifyListeners();
  }

  void toggleNotifHourly(bool value) {
    _notifHourly = value;
    if (value) {
      _notifRealTime = false;
      _notifBatch = false;
    }
    notifyListeners();
  }

  void toggleNotifBatch(bool value) {
    _notifBatch = value;
    if (value) {
      _notifRealTime = false;
      _notifHourly = false;
    }
    notifyListeners();
  }

  void toggleOredersManValidation(bool value) {
    _oredersManValidation = value;
    if (value) {
      _oredersAutoValidation = false;
      _oredersMixValidation = false;
    }
    notifyListeners();
  }

  void toggleOrdersMixValidation(bool value) {
    _oredersMixValidation = value;
    if (value) {
      _oredersAutoValidation = false;
      _oredersManValidation = false;
    }
    notifyListeners();
  }

  void toggleReservationConcelationFree(bool value) {
    _reservationConcelationFree = value;
    if (value) {
      _reservationConcelationPartial = false;
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

  void toggleReservationPartial(bool value) {
    _reservationPartial = value;
    if (value) {
      _reservationFree = false;
      _reservationTotal = false;
    }
    notifyListeners();
  }

  void toggleReservationConcelationPartial(bool value) {
    _reservationConcelationPartial = value;
    if (value) {
      _reservationConcelationFree = false;
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

  void changeResevationDuration(String day, int index) {
    _reservationDuration = int.parse(day);

    notifyListeners();
  }

  void changeNotifDuration(String hour, int index) {
    _notifDuration = int.parse(hour);

    notifyListeners();
  }

  void changeReturnPerFee(String percentage, int index) {
    _returnPerFee = int.parse(percentage);

    notifyListeners();
  }

  void changeReturnMaxDays(String day, int index) {
    _returnMaxDays = int.parse(day);

    notifyListeners();
  }

  void changeSelfPickUpMaxDays(String day, int index) {
    _selfPickUpMaxDays = int.parse(day);

    notifyListeners();
  }

  void toggleReservationTotal(bool value) {
    _reservationTotal = value;
    if (value) {
      _reservationFree = false;
      _reservationPartial = false;
    }
    notifyListeners();
  }

  void toggleDelivery() {
    _delivery = !_delivery;
    if (!_delivery) {
      _tax = null;
    }
    if (_delivery) {
      _selfPickup = false;
    }
    notifyListeners();
  }

  void changeTax(String value) {
    _tax = double.tryParse(value);
    notifyListeners();
  }

  void changeShippingPerKmTax(String value) {
    _shippingPerKmTax = double.tryParse(value);
    notifyListeners();
  }

  void changeShippingFixedPriceTax(String value) {
    _shippingFixedPriceTax = double.tryParse(value);
    notifyListeners();
  }

  void changeSelfPickupPrice(String value) {
    _selfPickupPrice = double.tryParse(value);
    notifyListeners();
  }

  void changeReservationTax(String value) {
    _reservationtax = double.tryParse(value);
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

  Future updatePolicy(BuildContext context, Map<String, dynamic> data) async {
    //_loading = true;
    notifyListeners();

    /// open hive box
    var credentialsBox = Boxes.getCredentials();
    String _id = credentialsBox.get('id');
    String _token = credentialsBox.get('token');

    /// dataForm is already a parameter

    /// post the dataForm via dio call
    debugPrint(data.toString());
    jsonEncode(data);
    print(jsonEncode(data));
    try {
      Dio dio = Dio();
      dio.options.headers["token"] = "Bearer $_token";
      var res = await dio.put(BASE_API_URL + '/user/$_id', data: data);
      // _loading = false;
      notifyListeners();
      if (res.statusCode == 200) {
        /// Save new User Data
        //  var policy = Policy.fromJson(res.data);
        notifyListeners();

        /// Display Results Message
        ToastSnackbar().init(context).showToast(
            message: "${res.statusMessage}", type: ToastSnackbarType.success);
        Navigator.pop(context);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        /// Display Error Response
        ///
        ToastSnackbar().init(context).showToast(
            message: "${e.response!.data}", type: ToastSnackbarType.error);
      } else {
        /// Display Error Message
        ToastSnackbar()
            .init(context)
            .showToast(message: e.message, type: ToastSnackbarType.error);
      }
    }

    //  _loading = false;
    notifyListeners();
  }

  Map<String, dynamic> policytoFormData() {
    return {
      "pickup": {
        "timeLimit": selfPickUplMaxDays,
      },
      "delivery": {
        "zone": {
          "centerPoint": {
            "latitude": storeAddress.lat ?? 0.0,
            "longitude": storeAddress.lng ?? 0.0,
          },
          "raduis": shippingMaxKM,
        },
        "pricing": {
          "fixe": shippingFixedPrice,
          "km": shippingPerKm,
        },
      },
      "reservation": {
        "duration": reservationDuration,
        "payment": {
          "free": reservationFree,
          "partial": {
            "fixe": reservationtax,
            "percentage": reservationtax,
          },
          "total": reservationTotal,
        },
        "cancelation": {
          "restrictions": {
            "fixe": reservationcancelationtax,
            "percentage": reservationcancelationtax,
          }
        },
      },
      "return": {
        "duration": shippingPerKm,
        "productStatus": returnCondition,
        "returnMethod": returnCondition,
        "refund": {
          "order": {
            "fixe": returnPerFee,
            "percentage": returnPerFee,
          },
          "shipping ": {
            "fixe": returnPerFee,
            "percentage": returnPerFee,
          },
        },
      },
      "order": {
        "validation": {
          "auto": oredersAutoValidation,
          "manual": oredersManValidation,
        },
        "notification": {
          "realtime": notifRealTime,
          "time": notifDuration,
          "perOrdersNbr": notifDuration,
          "sendMode": {
            "mail": notifEmail,
            "sms": notifSms,
            "popup": notifPopUp,
            "vibration": notifInPlateforme,
            "ringing": notifInPlateforme,
          },
        }
      },
    };
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
