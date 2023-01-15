import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/data_persistence/data_persistence.dart';
import 'package:proximity_client/ui/pages/authentication_pages/view/otp_screen.dart';

class SignupValidation with ChangeNotifier {
  // form fields
  ValidationItem _email = ValidationItem(null, null);
  ValidationItem _password = ValidationItem(null, null);
  bool _termsAgreement = false;

  // essential values for the UI
  // loading to render circular progress bar when waiting for server response
  bool _loading = false;

  // password visibility
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

  void changeVisibility() {
    _visibility = !visibility;
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
    final Map<String, dynamic> data = {
      "email": _email.value,
      "password": _password.value,
      "role": "user"
    };

    /// post the dataForm via dio call
    try {
      var res = await Dio().post(AUTH_API_URL + '/register', data: data);

      if (res.statusCode == 200) {
        _loading = false;
        notifyListeners();

        /// Save Credentials
        credentialsBox.put('id', res.data['_id']);
        credentialsBox.put('email', res.data['email']);

        /// Display Results Message
        ToastSnackbar().init(context).showToast(
            message: "${res.statusMessage}", type: ToastSnackbarType.success);

        /// Go to [OtpScreen]
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const OTPScreen()),
            (Route<dynamic> route) => false);
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
