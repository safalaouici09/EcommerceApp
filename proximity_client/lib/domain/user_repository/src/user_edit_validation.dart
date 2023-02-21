import 'package:flutter/material.dart';
import 'package:proximity/config/config.dart';
import 'package:proximity/domain_repository/domain_repository.dart';
import 'package:proximity_client/domain/user_repository/models/models.dart';

class UserEditValidation with ChangeNotifier {
  late ValidationItem _firstName;
  late ValidationItem _lastName;
  late ValidationItem _emailAddress;
  late ValidationItem _password;
  late ValidationItem _phone;
  late DateTime _birthdate;
  late List<dynamic> _profileImage;
  late Address _address;

  UserEditValidation.setUser(User user) {
    _firstName = ValidationItem(user.firstName, null);
    _lastName = ValidationItem(user.lastName, null);
    _emailAddress = ValidationItem(user.email, null);
    _password = ValidationItem(null, null);
    _phone = ValidationItem(user.phone, null);
    _birthdate = user.birthdate!;
    _profileImage = user.profileImage != null ? [user.profileImage] : [];
    _address = user.address ?? Address();
    notifyListeners();
  }

  // Getters
  ValidationItem get firstName => _firstName;

  ValidationItem get lastName => _lastName;

  ValidationItem get emailAddress => _emailAddress;

  ValidationItem get password => _password;

  ValidationItem get phone => _phone;

  DateTime get birthdate => _birthdate;

  List<dynamic> get profileImage => _profileImage;

  Address get address => _address;

  // checks if forms is valid and verified
  bool get isValid {
    if (_firstName.value != null &&
        _lastName.value != null &&
        _emailAddress.value != null &&
        _phone.value != null &&
        // birthdate.value != null &&
        _address.isAddressValid) {
      return true;
    } else {
      return false;
    }
  }

  // Setters
  void changeFirstName(String value) {
    _firstName = ValidationItem(value, null);
    notifyListeners();
  }

  void changeLastName(String value) {
    _lastName = ValidationItem(value, null);
    notifyListeners();
  }

  void changeEmailAddress(String value) {
    _emailAddress = ValidationItem(value, null);
    notifyListeners();
  }

  void changePhoneNumber(String value) {
    _phone = ValidationItem(value, null);
    notifyListeners();
  }

  void changeBirthdate(DateTime value) {
    _birthdate = value;
    notifyListeners();
  }

  /// Address Form Validators
  void changeAddress(Address newAddress) {
    _address = newAddress;
    notifyListeners();
  }

  void changeFullAddress(String value) {
    _address.fullAddress = value;
    notifyListeners();
  }

  void changeStreetName(String value) {
    _address.streetName = value;
    notifyListeners();
  }

  void changeCountry(String code, int index) {
    _address.countryCode = code;
    _address.countryName = countryList[code];
    notifyListeners();
  }

  void changeRegion(String value) {
    _address.region = value;
    notifyListeners();
  }

  void changeCity(String value) {
    _address.city = value;
    notifyListeners();
  }

  void changePostalCode(String value) {
    _address.postalCode = value; //"\d{2}[ ]?\d{3}"
    notifyListeners();
  }

  /// image Picker
  void editProfileImage(List<dynamic> imageList) {
    _profileImage.addAll(imageList);
    notifyListeners();
  }

  void removeProfileImage(int index) {
    _profileImage.removeAt(index);
    notifyListeners();
  }

  /// A method to convert the form into a User Object
  Map<String, dynamic> toDataForm() {
    return {
      "email": emailAddress.value,
      // "password": password.value,
      "firstName": firstName.value,
      "lastName": lastName.value,
      "phone": phone.value,
      "adresse": {
        "latitude": address.lat,
        "longitude": address.lng,
        "fullAdress": address.fullAddress ?? "",
        "streetName": address.fullAddress ?? "",
        "apartmentNumber": address.streetName ?? "",
        "city": address.city ?? "",
        "country": address.countryName ?? "",
        "countryCode": address.countryCode ?? "",
        "region": address.region ?? "",
        "postalCode": address.postalCode ?? ""
      },
      "shippingAdress": {
        "fullAdress": address.fullAddress ?? "",
        "streetName": address.streetName ?? "",
        "apartmentNumber": address.streetName ?? "",
        "city": address.city ?? "",
        "countryCode": address.countryCode ?? "",
        "country": address.countryName ?? "",
        "region": address.region ?? "",
        "postalCode": address.postalCode
      }
    };
  }
}
