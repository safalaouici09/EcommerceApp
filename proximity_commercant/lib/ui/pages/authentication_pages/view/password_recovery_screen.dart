import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_commercant/domain/authentication/src/reset_password_validation.dart';
=======
import 'package:proximity/proximity.dart';
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705

class PasswordRecoveryScreen extends StatelessWidget {
  const PasswordRecoveryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final passwordRecoveryValidation =
        Provider.of<ResetPasswordValidation>(context);
=======
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const TopBar(title: 'Password Recovery.'),
                const SizedBox(height: normal_100),
<<<<<<< HEAD
                EditText(
                    hintText: "Email, Phone Number or Username.",
                    prefixIcon: ProximityIcons.user,
                    // errorText: passwordRecoveryValidation.email.error,
                    onChanged: (value) =>
                        passwordRecoveryValidation.changeEmail(value),
                    enabled: !passwordRecoveryValidation.loading,
                    borderType: BorderType.top),
=======
                const EditText(hintText: "Email, Phone Number or Username."),
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
                const InfoMessage(
                    message:
                        'Enter the email, phone number or username associated with your Proximity account down below.'),
                Padding(
                    padding: const EdgeInsets.all(normal_100),
                    child: PrimaryButton(
<<<<<<< HEAD
                      buttonState: passwordRecoveryValidation.loading
                          ? ButtonState.loading
                          : null,
                      onPressed: () {
                        passwordRecoveryValidation
                            .createResetPasswordRequest(context);
                      },
=======
                      onPressed: () {},
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
                      title: "Search.",
                    )),
                const Spacer(),
              ]),
        ));
  }
}
