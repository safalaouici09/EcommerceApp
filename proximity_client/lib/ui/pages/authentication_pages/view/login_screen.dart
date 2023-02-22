import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/authentication/authentication.dart';
import 'package:proximity_client/ui/pages/authentication_pages/authentication_pages.dart';
import 'package:proximity_client/ui/pages/main_pages/main_pages.dart';
import 'package:flutter/gestures.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginValidation = Provider.of<LoginValidation>(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TopBar(title: 'Log In.'),
                const SizedBox(height: large_100),

                /// Login Forms
                RichEditText(
                  errorText: loginValidation.email.error,
                  children: [
                    EditText(
                        hintText: "Email or Phone Number.",
                        prefixIcon: ProximityIcons.user,
                        errorText: loginValidation.email.error,
                        onChanged: (value) =>
                            loginValidation.changeEmail(value),
                        enabled: !loginValidation.loading,
                        borderType: BorderType.top),
                    EditText(
                        hintText: "Password.",
                        prefixIcon: ProximityIcons.password,
                        suffixIcon: loginValidation.visibility
                            ? ProximityIcons.eye_off
                            : ProximityIcons.eye_on,
                        suffixOnPressed: () =>
                            loginValidation.changeVisibility(),
                        obscureText: !loginValidation.visibility,
                        errorText: loginValidation.password.error,
                        onChanged: (value) =>
                            loginValidation.changePassword(value),
                        enabled: !loginValidation.loading,
                        borderType: BorderType.bottom),
                  ],
                ),

                /// Error Messages
                const SizedBox(height: small_100),
                ErrorMessage(errors: [
                  loginValidation.email.error,
                  loginValidation.password.error
                ]),
                Padding(
                    padding: const EdgeInsets.all(normal_100),
                    child: GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PasswordRecoveryScreen())),
                        child: const Text('Password Recovery',
                            textAlign: TextAlign.end))),

                /// Login Button
                Padding(
                    padding: const EdgeInsets.all(normal_100),
                    child: PrimaryButton(
                        onPressed: () => loginValidation.login(context),
                        buttonState: loginValidation.loading
                            ? ButtonState.loading
                            : loginValidation.isValid
                                ? ButtonState.enabled
                                : ButtonState.disabled,
                        title: "Log In.")),
                Padding(
                    padding: const EdgeInsets.all(normal_100),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Container(
                                  height: tiny_50,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                        Theme.of(context)
                                            .dividerColor
                                            .withOpacity(0.0),
                                        Theme.of(context).dividerColor,
                                      ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight)))),
                          const SizedBox(width: normal_100),
                          const Text("Or Connect With",
                              textAlign: TextAlign.center),
                          const SizedBox(width: normal_100),
                          Expanded(
                              child: Container(
                                  height: tiny_50,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                        Theme.of(context)
                                            .dividerColor
                                            .withOpacity(0.0),
                                        Theme.of(context).dividerColor,
                                      ],
                                          begin: Alignment.centerRight,
                                          end: Alignment.centerLeft)))),
                        ])),
                Padding(
                    padding: const EdgeInsets.all(normal_100),
                    child: Row(mainAxisSize: MainAxisSize.max, children: [
                      Expanded(
                          child: NormalIconButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MainScreen())),
                              icon: Image.asset('assets/img/google.png',
                                  width: normal_200, height: normal_200))),
                      const SizedBox(width: normal_200),
                      Expanded(
                          child: NormalIconButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MainScreen())),
                              icon: Image.asset('assets/img/facebook.png',
                                  width: normal_200, height: normal_200))),
                      const SizedBox(width: normal_200),
                      Expanded(
                          child: NormalIconButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MainScreen())),
                              icon: Image.asset('assets/img/twitter.png',
                                  width: normal_200, height: normal_200)))
                    ])),
                const Spacer(),
                Padding(
                    padding: const EdgeInsets.all(normal_100),
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Don't have an account?  ",
                              style: Theme.of(context).textTheme.bodyText2),
                          TextSpan(
                              text: 'Sign Up.',
                              style: Theme.of(context).textTheme.bodyText1,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignupScreen())))
                        ])))
              ]),
        ));
  }
}