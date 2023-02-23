import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/user_repository/user_repository.dart';

import 'package:proximity_client/domain/data_persistence/data_persistence.dart';

class WelcomeScreenAfterLogin extends StatefulWidget {
  const WelcomeScreenAfterLogin({Key? key}) : super(key: key);

  @override
  State<WelcomeScreenAfterLogin> createState() => _WelcomeScreenAfterLoginState();
}

class _WelcomeScreenAfterLoginState extends State<WelcomeScreenAfterLogin> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: huge_200,
                    width: 100,
                    child: FittedBox(
                      child: Image.asset("assets/img/welcome.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 20, top: 20 + 20, right: 20, bottom: 20),
                    margin: EdgeInsets.only(top: 150),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          userService.user != null &&
                                  userService.user!.userName != null
                              ? "Welcome ${userService.user!.userName}."
                              : "Welcome Seller.",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "We just heard an awesome new user became a part of our team! Welcome to Proximity App!",
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 22,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                              onPressed: () async {
                                userService.welcomeValidate(context);
                              },
                              child: Text(
                                "let's start",
                                style: TextStyle(fontSize: 18),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ])));
  }
}
