<<<<<<< HEAD
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:proximity/domain_repository/models/address_model.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;
import 'package:path_provider/path_provider.dart';

class User {
  String? id;
  String? userName;

=======
import 'package:proximity/domain_repository/models/address_model.dart';

class User {
  String? id;
  String? firstName;
  String? lastName;
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
  String? email;
  String? phone;
  DateTime? birthdate;
  Address? address;
  Address? shippingAddress;
  bool? isVerified;
<<<<<<< HEAD
  bool? welcome;
=======
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
  List<dynamic>? profileImage;

  User({
    this.id,
<<<<<<< HEAD
    this.userName,
=======
    this.firstName,
    this.lastName,
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
    this.email,
    this.phone,
    this.birthdate,
    this.address,
    this.shippingAddress,
    this.isVerified,
<<<<<<< HEAD
    this.welcome,
=======
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
    this.profileImage,
  });

  User.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['_id'],
<<<<<<< HEAD
        userName = parsedJson['username'],
=======
        firstName = parsedJson['firstName'],
        lastName = parsedJson['lastName'],
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
        email = parsedJson['email'],
        phone = parsedJson['phone'],
        birthdate = DateTime(1999, 7, 8),
        address = Address(
<<<<<<< HEAD
          lat: (parsedJson['adresse']['latitude'] ?? 0).toDouble(),
          lng: (parsedJson['adresse']['longitude'] ?? 0).toDouble(),
=======
          lat: (parsedJson['adresse']['latitude']?? 0).toDouble(),
          lng: (parsedJson['adresse']['longitude']?? 0).toDouble(),
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
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
<<<<<<< HEAD
          lat: (parsedJson['adresse']['latitude'] ?? 0).toDouble(),
          lng: (parsedJson['adresse']['longitude'] ?? 0).toDouble(),
=======
          lat: (parsedJson['adresse']['latitude']?? 0).toDouble(),
          lng: (parsedJson['adresse']['longitude']?? 0).toDouble(),
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
          city: parsedJson['shippingAdress']['city'],
          fullAddress: parsedJson['shippingAdress']['streetName'],
          streetName: parsedJson['shippingAdress']['apartmentNumber'],
          postalCode: parsedJson['shippingAdress']['postalCode'],
          countryCode: parsedJson['shippingAdress']['countryCode'],
          countryName: parsedJson['shippingAdress']['country'],
          locality: parsedJson['shippingAdress']['region'],
          region: parsedJson['shippingAdress']['region'],
        ),
<<<<<<< HEAD
        isVerified = parsedJson['isVerified'] ?? false,
        welcome = parsedJson['welcome'] ?? false,
        profileImage = parsedJson['image'];
=======
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
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
}
