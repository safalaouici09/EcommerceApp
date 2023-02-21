import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_commercant/domain/data_persistence/data_persistence.dart';
import 'package:proximity_commercant/ui/pages/authentication_pages/view/otp_screen.dart';
<<<<<<< HEAD
import 'package:intl_phone_field/phone_number.dart';

=======
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705

class SignupValidation with ChangeNotifier {
  // form fields
  ValidationItem _email = ValidationItem(null, null);
  ValidationItem _password = ValidationItem(null, null);
<<<<<<< HEAD
  ValidationItem _phone = ValidationItem(null, null);

  ValidationItem _userName = ValidationItem(null, null);
  ValidationItem _passwordConfirm = ValidationItem(null, null);
  bool _termsAgreement = false;
  String _phoneNumberString = "";
=======
  bool _termsAgreement = false;

>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
  // essential values for the UI
  // loading to render circular progress bar when waiting for server response
  bool _loading = false;

  // password visibility
<<<<<<< HEAD
  bool _password_visibility = false;
  bool _passwordConfirm_visibility = false;

  // Getters
  // Getters
  ValidationItem get userName => _userName;
  ValidationItem get email => _email;
  ValidationItem get phone => _phone;

  ValidationItem get password => _password;
  ValidationItem get passwordConfirm => _passwordConfirm;

  bool get termsAgreement => _termsAgreement;

  bool get password_visibility => _password_visibility;
  bool get passwordConfirm_visibility => _passwordConfirm_visibility;
  bool get loading => _loading;

  bool get isValid {
    return ((_email.value != null || _phone.value != null) &&
        _password.value != null &&
        _passwordConfirm.value != null &&
        _termsAgreement);
  }


=======
  bool _visibility = false;

  // Getters
  ValidationItem get email => _email;

  ValidationItem get password => _password;

  bool get termsAgreement => _termsAgreement;

  bool get visibility => _visibility;

  bool get loading => _loading;

  bool get isValid {
    return (_email.value != null && _password.value != null && _termsAgreement);
  }

>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
  // Setters
  void changeEmail(String value) {
    if (value == '') {
      _email = ValidationItem(null, null);
      notifyListeners();
    } else if (value.length > 3) {
      bool _emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value);
      if (_emailValid) {
        _email = ValidationItem(value, null);
        notifyListeners();
      } else {
        _email = ValidationItem(null, "Enter a valid Email address.");
      }
    } else {
      _email = ValidationItem(null, "Email must be at least 3 characters.");
    }
    Future.delayed(largeAnimationDuration, () {
      notifyListeners();
    });
  }

<<<<<<< HEAD
  void changePhone(PhoneNumber value) {
    print(value.toString());
    if (value == null) {
      _phone = ValidationItem("", null);
      notifyListeners();
    } else if (value.toString().length > 3) {
      bool _phoneValid =
          RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value.number);
      if (_phoneValid) {
        _phone = ValidationItem(value.completeNumber, null);
        print(_phone.value);

        notifyListeners();
      } else {
        _phone = ValidationItem(null, "Enter a valid Phone number.");
      }
    } else {
      _phone = ValidationItem(null, "Email must be at least 3 characters.");
    }
    Future.delayed(largeAnimationDuration, () {
      notifyListeners();
    });
  }

  void changeUserName(String value) {
    if (value == '') {
      _userName = ValidationItem(null, null);
      notifyListeners();
    } else if (value.length > 6) {
      bool _userNameValid = RegExp(
              r'(^(?=.{6,18}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$)')
          .hasMatch(value);
      if (_userNameValid) {
        _userName = ValidationItem(value, null);
        notifyListeners();
      } else {
        _userName = ValidationItem(
            null, "User name can only contain alphanumeric characters .");
      }
    } else {
      _userName =
          ValidationItem(null, "User name should be at least 6 characters .");
    }
    Future.delayed(largeAnimationDuration, () {
      notifyListeners();
    });
  }

=======
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
  void changePassword(String value) {
    if (value == '') {
      _password = ValidationItem(null, null);
      notifyListeners();
    } else if (value.length > 6) {
      _password = ValidationItem(value, null);
      notifyListeners();
    } else {
      _password =
          ValidationItem(null, "Password must be at least 6 characters");
    }
    Future.delayed(largeAnimationDuration, () {
      notifyListeners();
    });
  }

<<<<<<< HEAD
  void verifyPassword(String value) {
    if (value == '') {
      _passwordConfirm = ValidationItem(null, null);
      notifyListeners();
    } else if (value == _password.value) {
      _passwordConfirm = ValidationItem(value, null);
      notifyListeners();
    } else {
      _passwordConfirm = ValidationItem(null, "Passwords do not match");
    }
    notifyListeners();
  }

  void changePasswordVisibility() {
    _password_visibility = !password_visibility;
    notifyListeners();
  }

  void changePasswordConfirmVisibility() {
    _passwordConfirm_visibility = !passwordConfirm_visibility;
=======
  void changeVisibility() {
    _visibility = !visibility;
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
    notifyListeners();
  }

  void agreeToTerms() {
    _termsAgreement = !_termsAgreement;
    notifyListeners();
  }

  /// signup methods
  void signup(BuildContext context) async {
    /// set loading to true
    _loading = true;
    notifyListeners();

    /// open hive box
    var credentialsBox = Boxes.getCredentials();

    /// prepare the dataForm
<<<<<<< HEAD
    final Map<String, dynamic> data = _phone.value != null
        ? _email.value != null
            ? {
                "username": _userName.value,
                "email": _email.value,
                "phone": _phone.value,
                "password": _password.value,
                "password_confirmation": _passwordConfirm.value,
                "role": "seller"
              }
            : {
                "username": _userName.value,
                "phone": _phone.value,
                "password": _password.value,
                "password_confirmation": _passwordConfirm.value,
                "role": "seller"
              }
        : {
            "username": _userName.value,
            "email": _email.value,
            "password": _password.value,
            "password_confirmation": _passwordConfirm.value,
            "role": "seller"
          };

    /// post the dataForm via dio call
    try {
      _loading = true;
=======
    final Map<String, dynamic> data = {
      "email": _email.value,
      "password": _password.value,
      "role": "seller"
    };

    /// post the dataForm via dio call
    try {
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
      var res = await Dio().post(AUTH_API_URL + '/register', data: data);

      if (res.statusCode == 200) {
        _loading = false;
        notifyListeners();
<<<<<<< HEAD
        print(res.data);
=======
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705

        /// Save Credentials
        credentialsBox.put('id', res.data['_id']);
        credentialsBox.put('email', res.data['email']);
<<<<<<< HEAD
        credentialsBox.put('phone', res.data['phone']);
        Future.delayed(largeAnimationDuration, () {
          notifyListeners();
        });
=======
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705

        /// Display Results Message
        ToastSnackbar().init(context).showToast(
            message: "${res.statusMessage}", type: ToastSnackbarType.success);

        /// Go to [OtpScreen]
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const OTPScreen()),
<<<<<<< HEAD
            (Route<dynamic> route) => true);
=======
            (Route<dynamic> route) => false);
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
      }
    } on DioError catch (e) {
      if (e.response != null) {
        /// Display Error Response
        ToastSnackbar()
            .init(context)
            .showToast(message: "${e.response}", type: ToastSnackbarType.error);
      } else {
        /// Display Error Message
        ToastSnackbar()
            .init(context)
            .showToast(message: e.message, type: ToastSnackbarType.error);
      }
    }

    _loading = false;
    notifyListeners();
  }

  void googleLogin(BuildContext context) async {}

  void facebookLogin(BuildContext context) async {}
}
