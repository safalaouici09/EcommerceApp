import 'bill_card_model.dart';

class Bill {
  double? totalAmount;
  double? deliveryAmount;
  double? reservationAmount;
  int? paymentMethodeId;
  BillCard? card;

  Bill.fromJson(Map<String, dynamic> parsedJson)
      : totalAmount = parsedJson['totalAmount'] != null
            ? parsedJson['totalAmount'].toDouble()
            : 0.0,
        deliveryAmount = parsedJson['deliveryAmount'].toDouble(),
        reservationAmount = parsedJson['reservationAmount'] != null
            ? parsedJson['reservationAmount']!.toDouble()
            : 0.0,
        paymentMethodeId = parsedJson['paymentMethodeId'],
        card = BillCard.fromJson(parsedJson['card']);
}
