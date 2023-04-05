class BillCard {
  String? cardNumber;
  String? cvc;
  String? expdate;
  String? name;
  String? city;
  String? street;
  String? street2;
  String? postalCode;

  BillCard.fromJson(Map<String, dynamic> parsedJson)
      : cardNumber = parsedJson['cardNumber'],
        cvc = parsedJson['cvc'],
        expdate = parsedJson['expdate'],
        name = parsedJson['name'],
        city = parsedJson['city'],
        street = parsedJson['street'],
        street2 = parsedJson['street2'],
        postalCode = parsedJson['postalCode'];
}
