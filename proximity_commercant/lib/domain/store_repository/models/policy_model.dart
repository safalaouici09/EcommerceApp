import 'dart:convert';

class Policy {
  // List<ShippingMethod>? shippingMethods;

  WorkingTime? workingTimePolicy;
  PickupPolicy? pickupPolicy;
  DeliveryPolicy? deliveryPolicy;
  ReservationPolicy? reservationPolicy;
  ReturnPolicy? returnPolicy;
  OrderPolicy? orderPolicy;

  Policy({
    //  this.shippingMethods,
    this.workingTimePolicy,
    this.pickupPolicy,
    this.deliveryPolicy,
    this.reservationPolicy,
    this.returnPolicy,
    this.orderPolicy,
  });

  Policy.fromJson(Map<String, dynamic> json) {
    workingTimePolicy = json['workingTime'] == null ? null :  WorkingTime.fromJson(json['workingTime']);
    pickupPolicy = json['pickup'] == null ? null :  PickupPolicy.fromJson(json['pickup']);
    deliveryPolicy = json['delivery'] == null ? null :  DeliveryPolicy.fromJson(json['delivery']);
    returnPolicy = json['return'] == null ? null :  ReturnPolicy.fromJson(json['return']);
    reservationPolicy = json['reservation'] == null ? null :  ReservationPolicy.fromJson(json['reservation']);
    orderPolicy = json['order'] == null ? null :  OrderPolicy.fromJson(json['order']);
  }

  String toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    
    data['workingTime'] = workingTimePolicy == null ? null :  workingTimePolicy!.toJson();
    
    data['pickup'] = pickupPolicy == null ? null :  pickupPolicy!.toJson();

    data['delivery'] = deliveryPolicy == null ? null :  deliveryPolicy!.toJson();

    data['reservation'] = reservationPolicy == null ? null : this.reservationPolicy!.toJson();

    data['return'] = returnPolicy == null ? null :   returnPolicy!.toJson();
    
    data['order'] = orderPolicy == null ? null :   orderPolicy!.toJson();

    print(json.encode(data)) ;
    return json.encode(data);
  }
}

// workingTimeexpiration: const Duration(days: 15),
// tax: 1.8,
// selfPickUpPrice: 1.5);

class PickupPolicy {
  int? timeLimit;

  PickupPolicy({required this.timeLimit});
  factory PickupPolicy.fromJson(Map<String, dynamic> json) {
    return PickupPolicy(
      timeLimit: json['timeLimit'] != null ? json['timeLimit'].toInt() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timeLimit'] = timeLimit;
    return data;
  }
}

class DeliveryPolicy {
  Zone? zone;
  Pricing? pricing;

  DeliveryPolicy({required this.zone, required this.pricing});
  factory DeliveryPolicy.fromJson(Map<String, dynamic> json) {
    return DeliveryPolicy(
      zone: Zone.fromJson(json['zone']),
      pricing: Pricing.fromJson(json['pricing']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (zone != null) {
      data['zone'] = zone!.toJson();
    }
    if (pricing != null) {
      data['pricing'] = pricing!.toJson();
    }

    return data;
  }
}

class Zone {
  CenterPoint? centerPoint;

  int? radius;

  Zone({required this.centerPoint, required this.radius});

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      centerPoint: CenterPoint.fromJson(json['centerPoint']),
      radius: json['radius'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['centerPoint'] = centerPoint!.toJson();
    if (radius == null) {
      print("set policy");
    }
    data['radius'] = radius;
    return data;
  }
}

class CenterPoint {
  double? latitude;
  double? longitude;

  CenterPoint({required this.latitude, required this.longitude});

  factory CenterPoint.fromJson(Map<String, dynamic> json) => CenterPoint(
        latitude: json['latitude'] != null ? json['latitude'].toDouble() : null,
        longitude:
            json['longitude'] != null ? json['longitude'].toDouble() : null,
      );

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}

class Pricing {
  double? fixedPrice;
  double? kmPrice;

  Pricing({this.fixedPrice, this.kmPrice});
  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      fixedPrice: json['fixe'] != null ? json['fixe'].toDouble() : null,
      kmPrice: json['km'] != null ? json['km'].toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fixe'] = fixedPrice;
    data['km'] = kmPrice;
    return data;
  }
}

class ReservationPolicy {
  final int? duration;
  final ReservationPayment payment;
  final ReservationCancelation? cancelation;

  ReservationPolicy(
      {this.duration, required this.payment, required this.cancelation});

  factory ReservationPolicy.fromJson(Map<String, dynamic> json) {
    return ReservationPolicy(
      duration: json['duration'],
      payment:
          ReservationPayment.fromJson(json['payment'] as Map<String, dynamic>),
      cancelation: ReservationCancelation.fromJson(
          json['cancelation'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['duration'] = duration;
    data['payment'] = payment.toJson();
    if (cancelation != null) {
      data['cancelation'] = cancelation!.toJson();
    }

    return data;
  }
}

class ReservationCancelation {
  Restrictions? restrictions;

  ReservationCancelation({this.restrictions});

  ReservationCancelation.fromJson(Map<String, dynamic> json) {
    restrictions = Restrictions.fromJson(json['restrictions']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.restrictions != null) {
      data['restrictions'] = this.restrictions!.toJson();
    }
    return data;
  }
}

class Restrictions {
  double? fix;
  double? percentage;

  Restrictions({this.fix, this.percentage});

  Restrictions.fromJson(Map<String, dynamic> json) {
    fix = json['fixe'] != null ? json['fixe'].toDouble() : null;
    percentage =
        json['percentage'] != null ? json['percentage'].toDouble() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['fixe'] = fix;
    data['percentage'] = percentage;
    return data;
  }
}

class ReservationPayment {
  final bool? free;
  Partial? partial;
  bool? total;

  ReservationPayment({this.free, this.partial, required total});

  factory ReservationPayment.fromJson(Map<String, dynamic> json) {
    return ReservationPayment(
      free: json['free'],
      partial: Partial.fromJson(json['partial']),
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['free'] = free;
    if (partial != null) {
      data['partial'] = partial!.toJson();
    }

    data['total'] = this.total;
    return data;
  }
}

class Partial {
  double? fixe;
  double? percentage;

  Partial({required this.fixe, required this.percentage});

  factory Partial.fromJson(Map<String, dynamic> json) {
    return Partial(
      fixe: json['fixe'] != null ? json['fixe'].toDouble() : null,
      percentage:
          json['percentage'] != null ? json['percentage'].toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'fixe': fixe,
        'percentage': percentage,
      };
}

class ReturnPolicy {
  int? duration;
  String? productStatus;
  String? returnMethod;
  Refund refund;

  ReturnPolicy({
    required this.duration,
    required this.productStatus,
    required this.returnMethod,
    required this.refund,
  });

  factory ReturnPolicy.fromJson(Map<String, dynamic> json) {
    return ReturnPolicy(
      duration: json['duration'],
      productStatus: json['productStatus'],
      returnMethod: json['returnMethod'],
      refund: Refund.fromJson(json['refund']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['duration'] = this.duration;
    data['productStatus'] = this.productStatus;
    data['returnMethod'] = returnMethod;
    data['refund'] = this.refund.toJson();
    return data;
  }
}

class Refund {
  OrderRefund order;
  ShippingRefund? shipping;

  Refund({
    required this.order,
    required this.shipping,
  });

  factory Refund.fromJson(Map<String, dynamic> json) {
    return Refund(
      order: OrderRefund.fromJson(json['order']),
      shipping: ShippingRefund.fromJson(json['shipping']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order'] = order.toJson();
    if (shipping != null) {
      data['shipping'] = shipping!.toJson();
    }

    return data;
  }
}

class OrderRefund {
  double? fixe;
  double? percentage;

  OrderRefund({
    this.fixe,
    this.percentage,
  });

  factory OrderRefund.fromJson(Map<String, dynamic> json) {
    return OrderRefund(
      fixe: json['fixe'] != null ? json['fixe'].toDouble() : null,
      percentage:
          json['percentage'] != null ? json['percentage'].toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fixe'] = this.fixe;
    data['percentage'] = this.percentage;
    return data;
  }
}

class ShippingRefund {
  double? fixe;
  double? percentage;

  ShippingRefund({
    this.fixe,
    this.percentage,
  });

  factory ShippingRefund.fromJson(Map<String, dynamic> json) {
    return ShippingRefund(
      fixe: json['fixe'] != null ? json['fixe'].toDouble() : null,
      percentage:
          json['percentage'] != null ? json['percentage'].toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fixe'] = this.fixe;
    data['percentage'] = this.percentage;
    return data;
  }
}

class WorkingTime {
  String? openTime;
  String? closeTime;

  WorkingTime({
    this.openTime,
    this.closeTime,
  });

  factory WorkingTime.fromJson(Map<String, dynamic> json) {
    return WorkingTime(
      openTime: json['openTime'],
      closeTime: json['closeTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'openTime': openTime,
      'closeTime': closeTime,
    };
  }
}

class OrderPolicy {
  Validation? validation;
  OrderNotification? notification;

  OrderPolicy({this.validation, this.notification});

  factory OrderPolicy.fromJson(Map<String, dynamic> json) {
    return OrderPolicy(
      validation: json['validation'] != null
          ? Validation.fromJson(json['validation'])
          : null,
      notification: json['notification'] != null
          ? OrderNotification.fromJson(json['notification'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (validation != null) {
      data['validation'] = validation!.toJson();
    }
    if (notification != null) {
      data['notification'] = notification!.toJson();
    }
    return data;
  }
}

class Validation {
  bool? auto;
  bool? manual;
  bool? both;
  Validation({this.auto, this.manual, this.both});

  factory Validation.fromJson(Map<String, dynamic> json) {
    return Validation(
        auto: json['auto'] as bool?, manual: json['manual'] as bool?
        // both: json['both']
        );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['auto'] = auto;
    data['manual'] = manual;
    //  data['both'] = both;

    return data;
  }
}

class OrderNotification {
  bool? realtime;
  int? time;
  int? perOrdersNbr;
  SendMode? sendMode;

  OrderNotification(
      {this.realtime, this.time, this.perOrdersNbr, this.sendMode});

  factory OrderNotification.fromJson(Map<String, dynamic> json) {
    return OrderNotification(
      realtime: json['realtime'] as bool?,
      time: json['time'] as int?,
      perOrdersNbr: json['perOrdersNbr'] as int?,
      sendMode: SendMode.fromJson(json['sendMode']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['realtime'] = this.realtime;
    data['time'] = this.time;
    data['perOrdersNbr'] = this.perOrdersNbr;
    if (this.sendMode != null) {
      data['sendMode'] = this.sendMode!.toJson();
    }
    return data;
  }
}

class SendMode {
  bool? mail;
  bool? sms;
  bool? popup;
  bool? vibration;
  bool? ringing;

  SendMode({this.mail, this.sms, this.popup, this.vibration, this.ringing});

  factory SendMode.fromJson(Map<String, dynamic> json) {
    return SendMode(
      mail: json['mail'] as bool?,
      sms: json['sms'] as bool?,
      popup: json['popup'] as bool?,
      vibration: json['vibration'] as bool?,
      ringing: json['ringing'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['mail'] = this.mail;
    data['sms'] = this.sms;
    data['popup'] = this.popup;
    data['vibration'] = this.vibration;
    data['ringing'] = this.ringing;
    return data;
  }
}
