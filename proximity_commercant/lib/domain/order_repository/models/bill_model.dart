import 'bill_card_model.dart';

class Bill {
  double? totalAmount;
  double? deliveryAmount;
  double? reservationAmount;
  int? paymentMethodeId;
  BillCard? card;

  Bill.fromJson(Map<String, dynamic> parsedJson)
      : totalAmount = parsedJson['totalAmount'].toDouble(),
        deliveryAmount = parsedJson['deliveryAmount'].toDouble(),
        reservationAmount = parsedJson['reservationAmount'].toDouble(),
        paymentMethodeId = parsedJson['paymentMethodeId'],
        card = BillCard.fromJson(parsedJson['card']);
}
