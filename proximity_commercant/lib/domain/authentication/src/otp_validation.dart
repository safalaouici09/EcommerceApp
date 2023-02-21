import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_commercant/domain/data_persistence/data_persistence.dart';
import 'package:proximity_commercant/ui/pages/home_pages/home_pages.dart';

class OTPValidation with ChangeNotifier {
  // form fields
  ValidationItem _verificationCode = ValidationItem(null, null);

  // essential values for the UI
  // loading to render circular progress bar when waiting for server response
  bool _loading = false;

  // Getters
  ValidationItem get verificationCode => _verificationCode;
<<<<<<< HEAD
  var credentialsBox = Boxes.getCredentials();
=======
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705

  bool get loading => _loading;

  bool get isValid {
    return (_verificationCode.value != null);
  }

  // Setters
  void changeVerificationCode(String value) {
    if (value.length == 4) {
      _verificationCode = ValidationItem(value, null);
      notifyListeners();
    } else {
      _verificationCode = ValidationItem(null, null);
      notifyListeners();
    }
  }
<<<<<<< HEAD

=======
  
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
  /// POST method
  void verify(BuildContext context) async {
    /// set loading to true
    _loading = true;
    notifyListeners();

    /// open hive box
<<<<<<< HEAD
=======
    var credentialsBox = Boxes.getCredentials();
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705

    /// prepare the dataForm
    final Map<String, dynamic> data = {
      "email": credentialsBox.get('email'),
      "verificationCode": _verificationCode.value
    };

    /// post the dataForm via dio call
    try {
      var res = await Dio().post(AUTH_API_URL + '/verify', data: data);

      if (res.statusCode == 200) {
        _loading = false;
        notifyListeners();
<<<<<<< HEAD
        print("dataaaaaaaaaaaaaaaaaaa") ;
        print(res.data) ;
        
        credentialsBox.put('token', res.data["data"]['token']);
        credentialsBox.put('id', res.data["data"]['user']['id']);
        credentialsBox.put('email', res.data["data"]['user']['email']);
        credentialsBox.put('username', res.data["data"]['user']['username']);
        credentialsBox.put('welcome', res.data["data"]['user']['welcome']);

        /// Save Credentials
        // credentialsBox.put('firstTime', false);
=======

        /// Save Credentials
        credentialsBox.put('firstTime', false);
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
        // credentialsBox.put('token', res.data['token']);

        /// Display Results Message
        ToastSnackbar().init(context).showToast(
            message: "${res.statusMessage}", type: ToastSnackbarType.success);

        /// Go to [HomeScreen]
<<<<<<< HEAD
        final welcome = credentialsBox.get('welcome');
        
        if(welcome == null ) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (Route<dynamic> route) => false);
        }else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false);
        }
=======
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
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
}
