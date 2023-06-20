class BillCard {
  String? name;
  String? phone;
  String? city;
  String? street;
  String? street2;
  String? postalCode;

  BillCard.fromJson(Map<String, dynamic> parsedJson)
      : name = parsedJson['name'],
        phone = parsedJson['phone'],
        city = parsedJson['address_city'],
        street = parsedJson['address_line1'],
        street2 = parsedJson['address_line2'],
        postalCode = parsedJson['postalCode'];
}
