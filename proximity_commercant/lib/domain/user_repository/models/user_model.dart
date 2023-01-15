import 'package:proximity/domain_repository/models/address_model.dart';

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  DateTime? birthdate;
  Address? address;
  Address? shippingAddress;
  bool? isVerified;
  List<dynamic>? profileImage;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.birthdate,
    this.address,
    this.shippingAddress,
    this.isVerified,
    this.profileImage,
  });

  User.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['_id'],
        firstName = parsedJson['firstName'],
        lastName = parsedJson['lastName'],
        email = parsedJson['email'],
        phone = parsedJson['phone'],
        birthdate = DateTime(1999, 7, 8),
        address = Address(
          lat: (parsedJson['adresse']['latitude']?? 0).toDouble(),
          lng: (parsedJson['adresse']['longitude']?? 0).toDouble(),
          city: parsedJson['adresse']['city'],
          fullAddress: parsedJson['adresse']['streetName'],
          streetName: parsedJson['adresse']['apartmentNumber'],
          postalCode: parsedJson['adresse']['postalCode'],
          countryCode: parsedJson['adresse']['countryCode'],
          countryName: parsedJson['adresse']['country'],
          locality: parsedJson['adresse']['region'],
          region: parsedJson['adresse']['region'],
        ),
        shippingAddress = Address(
          lat: (parsedJson['adresse']['latitude']?? 0).toDouble(),
          lng: (parsedJson['adresse']['longitude']?? 0).toDouble(),
          city: parsedJson['shippingAdress']['city'],
          fullAddress: parsedJson['shippingAdress']['streetName'],
          streetName: parsedJson['shippingAdress']['apartmentNumber'],
          postalCode: parsedJson['shippingAdress']['postalCode'],
          countryCode: parsedJson['shippingAdress']['countryCode'],
          countryName: parsedJson['shippingAdress']['country'],
          locality: parsedJson['shippingAdress']['region'],
          region: parsedJson['shippingAdress']['region'],
        ),
        isVerified = parsedJson['isVerified']?? false,
        profileImage = ['https://lh3.googleusercontent.com/a-/AOh14Gh2sBd7b5PYf6ToYEZxcc5rKSu98qkM65IB9VJPrQ=s200-p'];

  String get fullName => '$firstName $lastName';

  static User user = User(
      id: '0',
      firstName: 'Abdelmadjid',
      lastName: 'Bouikken',
      email: 'bouikkenmajid@gmail.com',
      phone: '+33526736466',
      birthdate: DateTime(1999, 7, 8),
      address: Address(
        lat: 0.0,
        lng: 0.0,
        city: 'Montpellier',
        streetName: '12 Rue du Professeur Lombard',
        postalCode: '34070',
        countryCode: 'FR',
        countryName: 'France',
        fullAddress: '12 Rue du Professeur Lombard, 6-2-2, Languedoc-Roussillon,',
        locality: 'Occitanie',
        region: 'Occitanie',
      ),
      isVerified: false,
      profileImage: ['https://lh3.googleusercontent.com/a-/AOh14Gh2sBd7b5PYf6ToYEZxcc5rKSu98qkM65IB9VJPrQ=s200-p']);
}
