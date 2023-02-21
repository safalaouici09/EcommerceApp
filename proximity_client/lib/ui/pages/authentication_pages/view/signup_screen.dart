import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/authentication/authentication.dart';
import 'package:proximity_client/ui/pages/authentication_pages/authentication_pages.dart';
import 'package:proximity_client/ui/pages/main_pages/main_pages.dart';
import 'package:flutter/gestures.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signupValidation = Provider.of<SignupValidation>(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              const TopBar(title: 'Sign Up.'),
              const SizedBox(height: large_100),

              /// Signup Forms
              RichEditText(children: [
                EditText(
                    hintText: "Email or Phone Number.",
                    prefixIcon: ProximityIcons.user,
                    errorText: signupValidation.email.error,
                    onChanged: (value) => signupValidation.changeEmail(value),
                    enabled: !signupValidation.loading,
                    borderType: BorderType.top),
                EditText(
                    hintText: "Password.",
                    prefixIcon: ProximityIcons.password,
                    suffixIcon: signupValidation.visibility
                        ? ProximityIcons.eye_off
                        : ProximityIcons.eye_on,
                    suffixOnPressed: () => signupValidation.changeVisibility(),
                    obscureText: !signupValidation.visibility,
                    errorText: signupValidation.password.error,
                    onChanged: (value) =>
                        signupValidation.changePassword(value),
                    enabled: !signupValidation.loading,
                    borderType: BorderType.bottom)
              ]),

              /// Error Messages
              const SizedBox(height: small_100),
              ErrorMessage(errors: [
                signupValidation.email.error,
                signupValidation.password.error
              ]),
              TermsAndConditions(
                  value: signupValidation.termsAgreement,
                  onChanged: () => signupValidation.agreeToTerms()),

              /// Signup Button
              Padding(
                  padding: const EdgeInsets.all(normal_100),
                  child: PrimaryButton(
                      onPressed: () => signupValidation.signup(context),
                      buttonState: signupValidation.loading
                          ? ButtonState.loading
                          : signupValidation.isValid
                              ? ButtonState.enabled
                              : ButtonState.disabled,
                      title: 'Sign Up.')),
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
                        //TO DO : Ajouter les fonctionalités de Sign up
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
                                        end: Alignment.centerLeft))))
                      ])),
              Padding(
                  padding: const EdgeInsets.all(normal_100),
                  child: Row(mainAxisSize: MainAxisSize.max, children: [
                    Expanded(
                        child: NormalIconButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainScreen())),
                            icon: Image.asset('assets/img/google.png',
                                width: normal_200, height: normal_200))),
                    const SizedBox(width: normal_200),
                    Expanded(
                        child: NormalIconButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainScreen())),
                            icon: Image.asset('assets/img/facebook.png',
                                width: normal_200, height: normal_200))),
                    const SizedBox(width: normal_200),
                    Expanded(
                        child: NormalIconButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainScreen())),
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
                            text: 'Already have an account?  ',
                            style: Theme.of(context).textTheme.bodyText2),
                        TextSpan(
                            text: 'Log In.',
                            style: Theme.of(context).textTheme.bodyText1,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen())))
                      ])))
            ])));
  }
}
