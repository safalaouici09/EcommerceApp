import 'package:proximity_commercant/domain/store_repository/store_repository.dart';

class Policy {
  List<ShippingMethod>? shippingMethods;
  double? tax;
  double? selfPickUpPrice;
  Duration? expiration;
  bool? openWeekend;
  bool? openNight;
  bool? openDay;
  String? openTime;
  String? closeTime;
  int? selfPickUpTimeLimit;
  double? deleveryPricing;
  double? shippingLatitude;
  double? shippingLongitude;
  double? radius;
  double? reservationDuration;
  bool? reservationFree;
  bool? reservationPartiel;
  bool? reservationTotal;
  double? reservationCancelationFee;
  double? returnDuration;
  bool? refundShipping;
  double? refundOrder;
  bool? orderValidationMan;
  bool? orderValidationAuto;
  bool? notifRealtime;
  int? notifTime;
  int? notifPerOrdersNbr;
  bool? notifMail;
  bool? notifSms;
  bool? notifPopup;
  bool? notifVibration;
  bool? notifRinging;

  Policy({
    this.shippingMethods,
    this.tax,
    this.selfPickUpPrice,
    this.expiration,
    this.openWeekend,
    this.openNight,
    this.openDay,
    this.openTime,
    this.closeTime,
    this.selfPickUpTimeLimit,
    this.deleveryPricing,
    this.shippingLatitude,
    this.shippingLongitude,
    this.radius,
    this.reservationDuration,
    this.reservationFree,
    this.reservationPartiel,
    this.reservationTotal,
    this.reservationCancelationFee,
    this.returnDuration,
    this.refundShipping,
    this.refundOrder,
    this.orderValidationMan,
    this.orderValidationAuto,
    this.notifRealtime,
    this.notifTime,
    this.notifPerOrdersNbr,
    this.notifMail,
    this.notifSms,
    this.notifPopup,
    this.notifVibration,
    this.notifRinging,
  });
  Policy.fromJson(Map<String, dynamic> parsedJson)
      :
        /*   :shippingMethods = (parsedJson['shippingMethods'] as List<dynamic>?) 
    ?.map((item) => ShippingMethod.fromJson(item)) 
    .toList(), */
        tax = parsedJson['tax']?.toDouble(),
        selfPickUpPrice = parsedJson['selfPickUpPrice']?.toDouble(),
        expiration = parsedJson['expiration'] != null
            ? Duration(milliseconds: parsedJson['expiration'])
            : null,
        openWeekend = parsedJson['openWeekend'],
        openNight = parsedJson['openNight'],
        openDay = parsedJson['openDay'],
        openTime = parsedJson['openTime'],
        closeTime = parsedJson['closeTime'],
        selfPickUpTimeLimit = parsedJson['pickup'] != null
            ? parsedJson['pickup']['timeLimit']
            : null,
        deleveryPricing = parsedJson['delivery'] != null &&
                parsedJson['delivery']['pricing'] != null
            ? (parsedJson['delivery']['pricing']['fixe'] ??
                parsedJson['delivery']['pricing']['km'])
            : null,
        shippingLatitude = parsedJson['delivery'] != null &&
                parsedJson['delivery']['zone'] != null &&
                parsedJson['delivery']['zone']['centerPoint'] != null
            ? parsedJson['delivery']['zone']['centerPoint']['latitude']
                ?.toDouble()
            : null,
        shippingLongitude = parsedJson['delivery'] != null &&
                parsedJson['delivery']['zone'] != null &&
                parsedJson['delivery']['zone']['centerPoint'] != null
            ? parsedJson['delivery']['zone']['centerPoint']['longitude']
                ?.toDouble()
            : null,
        radius = parsedJson['delivery'] != null &&
                parsedJson['delivery']['zone'] != null
            ? parsedJson['delivery']['zone']['raduis']?.toDouble()
            : null,
        reservationDuration = parsedJson['reservation'] != null &&
                parsedJson['reservation']['duration'] != null
            ? parsedJson['reservation']['duration']?.toDouble()
            : null,
        reservationFree = parsedJson['reservation'] != null &&
                parsedJson['reservation']['payment'] != null &&
                parsedJson['reservation']['payment']['free'] != null
            ? parsedJson['reservation']['payment']['free']
            : null,
        reservationPartiel = parsedJson['reservation'] != null &&
                parsedJson['reservation']['payment'] != null &&
                (parsedJson['reservation']['payment']['partial']['fixe'] !=
                        null ||
                    parsedJson['reservation']['payment']['partial']
                            ['percentage'] !=
                        null)
            ? true
            : null,
        reservationTotal = parsedJson['reservation'] != null &&
                parsedJson['reservation']['payment'] != null &&
                parsedJson['reservation']['payment']['total'] != null
            ? parsedJson['reservation']['payment']['total']
            : null,
        reservationCancelationFee = parsedJson['reservation'] != null &&
                parsedJson['reservation']['cancelation'] != null &&
                parsedJson['reservation']['cancelation']['restrictions'] !=
                    null &&
                (parsedJson['reservation']['cancelation']['restrictions']
                            ['fixe'] !=
                        null ||
                    parsedJson['reservation']['cancelation']['restrictions']
                            ['percentage'] !=
                        null)
            ? parsedJson['reservation']['cancelation']['restrictions']['fixe']
            : parsedJson['reservation']['cancelation']['restrictions']
                ['percentage'];

  static Policy policy = Policy(shippingMethods: [
    ShippingMethod.selfPickupTotal,
    ShippingMethod.delivery
  ], expiration: const Duration(days: 15), tax: 1.8, selfPickUpPrice: 1.5);
}
