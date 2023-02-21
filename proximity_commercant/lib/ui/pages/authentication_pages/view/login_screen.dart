import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:flutter/gestures.dart';
import 'package:proximity_commercant/domain/authentication/authentication.dart';
import 'package:proximity_commercant/ui/pages/authentication_pages/authentication_pages.dart';
import 'package:proximity_commercant/ui/pages/home_pages/home_pages.dart';

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
                Padding(
                    padding: const EdgeInsets.all(normal_100)
                        .copyWith(top: normal_200),
                    child: Text('Log In.',
                        style: Theme.of(context).textTheme.subtitle1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis)),
                const SizedBox(height: large_100),

                /// Login Forms
<<<<<<< HEAD
                EditText(
                    hintText: "Email, Phone Number or User Name.",
                    prefixIcon: ProximityIcons.user,
                    errorText: loginValidation.email.error,
                    onChanged: (value) => loginValidation.changeEmail(value),
                    enabled: !loginValidation.loading,
                    borderType: BorderType.top),
                const SizedBox(
                  height: normal_100,
                ),
                EditText(
                    hintText: "Password.",
                    prefixIcon: ProximityIcons.password,
                    suffixIcon: loginValidation.visibility
                        ? ProximityIcons.eye_off
                        : ProximityIcons.eye_on,
                    suffixOnPressed: () => loginValidation.changeVisibility(),
                    obscureText: !loginValidation.visibility,
                    errorText: loginValidation.password.error,
                    onChanged: (value) => loginValidation.changePassword(value),
                    enabled: !loginValidation.loading,
                    borderType: BorderType.bottom),
=======
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
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705

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
<<<<<<< HEAD
                        child: Text('Password Recovery',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(fontSize: normal_100),
=======
                        child: const Text('Password Recovery',
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
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
<<<<<<< HEAD
                          Text("Or Connect With",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(fontSize: normal_100),
=======
                          const Text("Or Connect With",
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
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
                                          const HomeScreen())),
                              icon: Image.asset('assets/img/google.png',
                                  width: normal_200, height: normal_200))),
                      const SizedBox(width: normal_200),
                      Expanded(
                          child: NormalIconButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HomeScreen())),
                              icon: Image.asset('assets/img/facebook.png',
                                  width: normal_200, height: normal_200))),
                      const SizedBox(width: normal_200),
                      Expanded(
                          child: NormalIconButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HomeScreen())),
                              icon: Image.asset('assets/img/twitter.png',
                                  width: normal_200, height: normal_200)))
                    ])),
                const Spacer(),

                InkWell(
                    onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen())),
                    child: Padding(
                        padding: const EdgeInsets.all(normal_100),
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "Don't have an account?  ",
<<<<<<< HEAD
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(fontSize: normal_100)),
                              TextSpan(
                                  text: 'Sign Up.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontSize: normal_100)),
=======
                                  style: Theme.of(context).textTheme.bodyText2),
                              TextSpan(
                                  text: 'Sign Up.',
                                  style: Theme.of(context).textTheme.bodyText1)
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
                            ]))))
              ]),
        ));
  }
}
