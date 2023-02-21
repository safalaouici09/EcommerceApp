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

  Policy(
      {this.shippingMethods,
        this.tax,
        this.selfPickUpPrice,
        this.expiration,
        this.openWeekend,
        this.openNight,
        this.openDay,
        this.openTime,
        this.closeTime});

  static Policy policy = Policy(
      shippingMethods: [ShippingMethod.selfPickupTotal, ShippingMethod.delivery],
      expiration: const Duration(days: 15),
      tax: 1.8,
      selfPickUpPrice: 1.5
  );
}
