import 'dart:ui';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
import 'home_tab_screen.dart';
import 'map_tab_screen.dart';
import 'cart_tab_screen.dart';
import 'profile_tab_screen.dart';
import 'package:proximity_client/domain/data_persistence/data_persistence.dart';
import 'package:proximity_client/domain/user_repository/user_repository.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  @override
  void initState() {

    super.initState();
    _index = 0;
  }

  @override
  Widget build(BuildContext context) {


    final userService = Provider.of<UserService>(context);

    var credentialsBox = Boxes.getCredentials();
    String? _token = credentialsBox.get('token');

    if(_token != null && userService.user == null) {
      userService.getUserData() ;
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Stack(alignment: Alignment.bottomCenter, children: [
              (() {
                switch (_index) {
                  case 0:
                    return const HomeTabScreen();
                  case 1:
                    return const MapTabScreen();
                  case 2:
                    return const CartTabScreen();
                  case 3:
                    return const ProfileTabScreen();
                  default:
                    return const HomeTabScreen();
                }
              }()),
          Material(
              color: Colors.transparent,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: normal_100,
                    sigmaY: normal_100,
                  ),
                  child: Container(
                      height: large_200,
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor.withOpacity(0.9),
                          border: Border(
                              top: BorderSide(
                                  color: Theme.of(context).dividerColor,
                                  width: tiny_50))),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                                child: InkWell(
                              onTap: () => setState(() {
                                _index = 0;
                              }),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_index == 0) ...[
                                      DuotoneIcon(
                                        primaryLayer:
                                            ProximityIcons.home_duotone_1,
                                        secondaryLayer:
                                            ProximityIcons.home_duotone_2,
                                        color: blueSwatch.shade500,
                                      ),
                                      Text('Home',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(height: 0.9)),
                                      const SizedBox(height: tiny_50),
                                      Container(
                                          height: tiny_50,
                                          width: normal_150,
                                          decoration: BoxDecoration(
                                              color: blueSwatch.shade500,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      tinyRadius)))
                                    ] else
                                      const Icon(ProximityIcons.home),
                                  ]),
                            )),
                            Expanded(
                                child: InkWell(
                              onTap: () => setState(() {
                                _index = 1;
                              }),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_index == 1) ...[
                                      DuotoneIcon(
                                        primaryLayer:
                                            ProximityIcons.map_duotone_1,
                                        secondaryLayer:
                                            ProximityIcons.map_duotone_2,
                                        color: greenSwatch.shade300,
                                      ),
                                      Text('Map',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(height: 0.9)),
                                      const SizedBox(height: tiny_50),
                                      Container(
                                          height: tiny_50,
                                          width: normal_150,
                                          decoration: BoxDecoration(
                                              color: greenSwatch.shade300,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      tinyRadius)))
                                    ] else
                                      const Icon(ProximityIcons.map),
                                  ]),
                            )),
                            Expanded(
                                child: InkWell(
                              onTap: () => setState(() {
                                _index = 2;
                              }),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_index == 2) ...[
                                      DuotoneIcon(
                                        primaryLayer:
                                            ProximityIcons.cart_duotone_1,
                                        secondaryLayer:
                                            ProximityIcons.cart_duotone_2,
                                        color: yellowSwatch.shade600,
                                      ),
                                      Text('Cart',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(height: 0.9)),
                                      const SizedBox(height: tiny_50),
                                      Container(
                                          height: tiny_50,
                                          width: normal_150,
                                          decoration: BoxDecoration(
                                              color: yellowSwatch.shade600,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      tinyRadius)))
                                    ] else
                                      const Icon(ProximityIcons.cart),
                                  ]),
                            )),
                            Expanded(
                                child: InkWell(
                              onTap: () => setState(() {
                                _index = 3;
                              }),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_index == 3) ...[
                                      DuotoneIcon(
                                        primaryLayer:
                                            ProximityIcons.user_duotone_1,
                                        secondaryLayer:
                                            ProximityIcons.user_duotone_2,
                                        color: redSwatch.shade500,
                                      ),
                                      Text('Profile',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(height: 0.9)),
                                      const SizedBox(height: tiny_50),
                                      Container(
                                          height: tiny_50,
                                          width: normal_150,
                                          decoration: BoxDecoration(
                                              color: redSwatch.shade500,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      tinyRadius)))
                                    ] else
                                      const Icon(ProximityIcons.user),
                                  ]),
                            )),
                          ])),
                ),
              ))
        ])));
  }
}
