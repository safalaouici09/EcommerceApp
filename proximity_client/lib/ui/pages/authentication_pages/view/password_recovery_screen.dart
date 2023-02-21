import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';

class PasswordRecoveryScreen extends StatelessWidget {
  const PasswordRecoveryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const TopBar(title: 'Password Recovery.'),
                const SizedBox(height: normal_100),
                const EditText(hintText: "Email, Phone Number or Username."),
                const InfoMessage(
                    message:
                        'Enter the email, phone number or username associated with your Proximity account down below.'),
                Padding(
                    padding: const EdgeInsets.all(normal_100),
                    child: PrimaryButton(
                      onPressed: () {},
                      title: "Search.",
                    )),
                const Spacer(),
              ]),
        ));
  }
}
