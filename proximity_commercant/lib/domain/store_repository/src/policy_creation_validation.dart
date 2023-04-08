import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:proximity/config/backend.dart';
import 'package:proximity/config/values.dart';
import 'package:proximity/domain_repository/domain_repository.dart';
import 'package:proximity/widgets/toast_snackbar/toast_snackbar.dart';
import 'package:proximity_commercant/domain/data_persistence/src/boxes.dart';
import 'package:proximity_commercant/domain/store_repository/store_repository.dart';
import 'package:proximity_commercant/domain/user_repository/src/user_service.dart';
import 'package:proximity_commercant/ui/pages/home_pages/home_pages.dart';

import 'package:proximity_commercant/ui/pages/store_pages/view/store_creation_screen.dart';

class PolicyValidation with ChangeNotifier {
  bool _selfPickup = false;
  bool _shippingFixedPrice = false;
  bool _shippingPerKm = false;
  bool _selfPickupFree = false;
  bool _selfPickupPartial = false;
  bool _selfPickupTotal = false;
  bool _returnShippingFee = false;
  bool _returnTotalFee = false;
  bool _returnPartialFee = false;
  double? _returnPerFee;
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
  Address _deliveryCenter = Address();
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
  bool _reservationAccept = false;
  int _shippingMaxKM = 10;
  Address get deliveryCenter => _deliveryCenter;
  TimeOfDay? get openTime => _openTime;

  TimeOfDay? get closeTime => _closeTime;
  TimeOfDay? _openTime = TimeOfDay(hour: 09, minute: 00);
  TimeOfDay? _closeTime = TimeOfDay(hour: 18, minute: 00);
  int? _reservationDuration;
  int? _notifDuration;
  int? _returnMaxDays;
  int? _selfPickUpMaxDays;
  double? _reservationtax;
  double? _reservationcancelationtax;
  //the getters
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
  double? get returnPerFee => _returnPerFee;
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
  bool? get reservationAccept => _reservationAccept;
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

  int get shippingMaxKM => _shippingMaxKM;

  String? get returnCondition => _returnCondition;
  String? _returnMethode;
  String? get returnMethode => _returnMethode;
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
    if (_reservationAccept == false ||
        (_reservationAccept == true &&
            ((_reservationFree ||
                    (_reservationPartial && _reservationtax != null) ||
                    _reservationTotal) &&
                (_reservationDuration != null) &&
                (_reservationConcelationFree ||
                    (_reservationConcelationPartial &&
                        _reservationcancelationtax != null))))) {
      return true;
    } else {
      return false;
    }
  }

  bool get returnIsValid {
    if (!_returnAccept ||
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

  PolicyValidation();

//setter
//to do : re set
  PolicyValidation.setPolicy(Policy? policy) {
    if (policy != null) {
      /* //set policy
      if (policy.pickupPolicy!.timeLimit != null) {
        _selfPickup = true;
        _selfPickUpMaxDays = policy.pickupPolicy!.timeLimit;
      } //set delivery

      if (policy.deliveryPolicy!.zone!.radius != null) {
        _delivery = true;
        _deliveryCenter.lat =
            policy.deliveryPolicy!.zone!.centerPoint!.latitude;
        _deliveryCenter.lng =
            policy.deliveryPolicy!.zone!.centerPoint!.longitude;
        //  _shippingMaxKM = policy.deliveryPolicy!.zone!.radius!;
        if (policy.deliveryPolicy!.pricing!.fixedPrice != null) {
          _shippingFixedPrice = true;
          _shippingFixedPriceTax = policy.deliveryPolicy!.pricing!.fixedPrice;
        }
        if (policy.deliveryPolicy!.pricing!.kmPrice != null) {
          _shippingPerKm = true;
          _shippingPerKmTax = policy.deliveryPolicy!.pricing!.kmPrice;
        }
      }
      //set reservation
      if (policy.reservationPolicy!.duration != null) {
        _reservationAccept = true;
        if (policy.reservationPolicy!.payment.free != null) {
          _reservationFree = policy.reservationPolicy!.payment.free!;
          _reservationTotal = false;
          _reservationPartial = false;
        }
        if (policy.reservationPolicy!.payment.total != null) {
          _reservationTotal = true;
          _reservationFree = false;

          _reservationPartial = false;
        }

        if (policy.reservationPolicy!.payment.partial!.fixe != null) {
          _reservationPartial = true;
          _reservationtax = policy.reservationPolicy!.payment.partial!.fixe!;
        }
        if (policy.reservationPolicy!.cancelation!.restrictions!.fix == null) {
          _reservationConcelationFree = true;
        } else {
          if (policy.reservationPolicy!.cancelation!.restrictions!.fix !=
              null) {
            _reservationConcelationPartial = true;
            _reservationcancelationtax =
                policy.reservationPolicy!.cancelation!.restrictions!.fix!;
          }
        }
      }
      //set return
      if (policy.returnPolicy!.duration != null) {
        _returnAccept = true;
        _returnMaxDays = policy.returnPolicy!.duration;
        _returnCondition = policy.returnPolicy!.productStatus;
        _returnMethode = policy.returnPolicy!.returnMethod;
        if (policy.returnPolicy!.refund.shipping!.fixe != null) {
          _returnShippingFee = true;
        }
        if (policy.returnPolicy!.refund!.order.fixe != null) {
          _returnPartialFee = true;

          _returnPerFee = policy.returnPolicy!.refund!.order.fixe;
        }
      }

      //set orders
      if (policy.orderPolicy != null) {
        _oredersAutoValidation = policy.orderPolicy!.validation!.auto!;
        _oredersManValidation = policy.orderPolicy!.validation!.manual!;
        //  _oredersMixValidation = policy.orderPolicy!.validation!.both!;
        _notifRealTime = policy.orderPolicy!.notification!.realtime!;
      }

      if (policy.orderPolicy!.notification!.perOrdersNbr != null) {
        _notifBatch = true;
        _notifDuration = policy.orderPolicy!.notification!.perOrdersNbr!;
      }
      if (policy.orderPolicy!.notification!.time != null) {
        _notifHourly = true;
        _notifDuration = policy.orderPolicy!.notification!.perOrdersNbr!;
      }
      _notifEmail = policy.orderPolicy!.notification!.sendMode!.mail!;
      _notifPopUp = policy.orderPolicy!.notification!.sendMode!.popup!;
      _notifSms = policy.orderPolicy!.notification!.sendMode!.sms!;
      _notifInPlateforme =
          policy.orderPolicy!.notification!.sendMode!.vibration!;
    */
    } else {
      return;
    }
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

    notifyListeners();
  }

  void toggleReservationAceept(bool value) {
    _reservationAccept = value;

    notifyListeners();
  }

  /// Policy Form Validators
  void toggleSelfPickup() {
    _selfPickup = !_selfPickup;
    if (_selfPickup) {
      // _delivery = false;
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

  void changeReturnCondition(String value) {
    _returnCondition = value;
    notifyListeners();
  }

  void incrShippingMaxKM() {
    _shippingMaxKM += 10;
    print(_shippingMaxKM);
    notifyListeners();
  }

  void decShippingMaxKM() {
    _shippingMaxKM -= 10;
    notifyListeners();
  }

  void changeReturnMethode(String value) {
    _returnMethode = value;
    notifyListeners();
  }

  void changeResevationDuration(String day, int index) {
    _reservationDuration = int.parse(day);
    // int.parse(day.replaceAll("days", "").replaceAll("day", ""));

    notifyListeners();
  }

  void changeNotifDuration(String hour, int index) {
    _notifDuration = int.parse(hour);

    notifyListeners();
  }

  void changeReturnPerFee(String percentage, int index) {
    _returnPerFee = double.parse(percentage);

    notifyListeners();
  }

  void changeReturnMaxDays(String day, int index) {
    _returnMaxDays =
        int.parse(day.replaceAll("days", "").replaceAll("day", ""));

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
    if (!_delivery) {}
    if (_delivery) {
      // _selfPickup = false;
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

  void changeReservationCancelationTax(String value) {
    _reservationcancelationtax = double.tryParse(value);
    notifyListeners();
  }

  void changeDeliveryCenterdress(Address newAddress) {
    _deliveryCenter = newAddress;
    notifyListeners();
  }

  Future updatePolicy(BuildContext context, Map<String, dynamic> data) async {
    //_loading = true;
    /*  Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StoreCreationScreen(store: Store())));*/
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
        Provider.of<UserService>(context, listen: false).getUserData();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
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
    var pickup = null;
    var delivery = null;
    ReturnPolicy? returnPolicy;
    PickupPolicy? pickupPolicy;
    DeliveryPolicy? deliveryPolicy;
    ReservationPolicy? reservationPolicy;

    WorkingTime workingTime = WorkingTime(
        openTime: _openTime.toString(), closeTime: _closeTime.toString());
    if (_selfPickup) {
      pickupPolicy = PickupPolicy(timeLimit: selfPickUplMaxDays);
    }
    if (_delivery) {
      deliveryPolicy = DeliveryPolicy(
          zone: Zone(
              centerPoint: CenterPoint(
                latitude: _deliveryCenter.lat,
                longitude: _deliveryCenter.lng,
              ),
              radius: _shippingMaxKM),
          pricing: Pricing(
              fixedPrice: shippingFixedPriceTax, kmPrice: shippingPerKmTax));
    }
    if (_returnAccept) {
      returnPolicy = ReturnPolicy(
          duration: _returnMaxDays,
          productStatus: returnCondition,
          returnMethod: returnMethode,
          refund: Refund(
              order: OrderRefund(
                fixe: _returnPerFee,
              ),
              shipping: _returnShippingFee
                  ? ShippingRefund(fixe: _returnPerFee)
                  : null));
    }
    if (_reservationAccept) {
      reservationPolicy = ReservationPolicy(
          duration: _reservationDuration,
          payment: ReservationPayment(
              free: _reservationFree,
              total: _reservationTotal,
              partial: _reservationPartial
                  ? Partial(fixe: _reservationtax, percentage: _reservationtax)
                  : null),
          cancelation: _reservationConcelationFree
              ? null
              : ReservationCancelation(
                  restrictions: Restrictions(fix: _reservationcancelationtax),
                ));
    }

    OrderPolicy orderPolicy = OrderPolicy(
        validation: Validation(
            auto: _oredersAutoValidation,
            manual: _oredersManValidation,
            both: _oredersMixValidation),
        notification: OrderNotification(
            realtime: _notifRealTime,
            time: _notifDuration,
            perOrdersNbr: _notifDuration,
            sendMode: SendMode(
                mail: _notifEmail,
                sms: _notifSms,
                popup: _notifPopUp,
                vibration: _notifInPlateforme)));
    Policy policy = Policy(
        //  workingTimePolicy: workingTime,
        pickupPolicy: pickupPolicy,
        deliveryPolicy: deliveryPolicy,
        reservationPolicy: reservationPolicy,
        returnPolicy: returnPolicy,
        orderPolicy: orderPolicy);
    return {"policy": policy.toJson()};
  }

  Policy getPolicy() {
    var pickup = null;
    var delivery = null;
    ReturnPolicy? returnPolicy;
    PickupPolicy? pickupPolicy;
    DeliveryPolicy? deliveryPolicy;
    ReservationPolicy? reservationPolicy;

    WorkingTime workingTime = WorkingTime(
        openTime: _openTime.toString(), closeTime: _closeTime.toString());
    if (_selfPickup) {
      pickupPolicy = PickupPolicy(timeLimit: selfPickUplMaxDays);
    }
    if (_delivery) {
      deliveryPolicy = DeliveryPolicy(
          zone: Zone(
              centerPoint: CenterPoint(
                latitude: _deliveryCenter.lat,
                longitude: _deliveryCenter.lng,
              ),
              radius: _shippingMaxKM),
          pricing: Pricing(
              fixedPrice: shippingFixedPriceTax, kmPrice: shippingPerKmTax));
    }
    if (_returnAccept) {
      returnPolicy = ReturnPolicy(
          duration: _returnMaxDays,
          productStatus: returnCondition,
          returnMethod: returnMethode,
          refund: Refund(
              order: OrderRefund(
                fixe: _returnPerFee,
              ),
              shipping: _returnShippingFee
                  ? ShippingRefund(fixe: _returnPerFee)
                  : null));
    }
    if (_reservationAccept) {
      reservationPolicy = ReservationPolicy(
          duration: _reservationDuration,
          payment: ReservationPayment(
              free: _reservationFree,
              total: _reservationTotal,
              partial: _reservationPartial
                  ? Partial(fixe: _reservationtax, percentage: _reservationtax)
                  : null),
          cancelation: _reservationConcelationFree
              ? null
              : ReservationCancelation(
                  restrictions: Restrictions(fix: _reservationcancelationtax),
                ));
    }

    OrderPolicy orderPolicy = OrderPolicy(
        validation: Validation(
            auto: _oredersAutoValidation,
            manual: _oredersManValidation,
            both: _oredersMixValidation),
        notification: OrderNotification(
            realtime: _notifRealTime,
            time: _notifDuration,
            perOrdersNbr: _notifDuration,
            sendMode: SendMode(
                mail: _notifEmail,
                sms: _notifSms,
                popup: _notifPopUp,
                vibration: _notifInPlateforme)));
    Policy policy = Policy(
        //  workingTimePolicy: workingTime,
        pickupPolicy: pickupPolicy,
        deliveryPolicy: deliveryPolicy,
        reservationPolicy: reservationPolicy,
        returnPolicy: returnPolicy,
        orderPolicy: orderPolicy);
    return policy;
  }
}
