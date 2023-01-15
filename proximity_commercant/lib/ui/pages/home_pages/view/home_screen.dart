import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_commercant/domain/user_repository/user_repository.dart';
import 'package:proximity_commercant/ui/pages/home_pages/home_pages.dart';
import 'package:proximity_commercant/ui/pages/order_pages/order_pages.dart';
import 'package:proximity_commercant/ui/pages/store_pages/store_pages.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _drawerAnimation;
  late int _openedSideMenu;

  void _openSideMenu() {
    setState(() => _openedSideMenu = 1);
    _drawerAnimation.forward();
  }

  @override
  void initState() {
    _openedSideMenu = -1;
    _drawerAnimation =
        AnimationController(vsync: this, duration: normalAnimationDuration);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedBuilder(
            animation: _drawerAnimation,
            builder: (context, child) {
              int _sign =
                  (Directionality.of(context) == TextDirection.rtl) ? -1 : 1;
              double _maxSlideProfile =
                      MediaQuery.of(context).size.width - large_200 + small_50,
                  _slideProfile = _drawerAnimation.value * _maxSlideProfile;
              double _maxSlideNotifications = MediaQuery.of(context).size.width,
                  _slideNotifications = _drawerAnimation.value *
                      (MediaQuery.of(context).size.width - huge_200 + tiny_50);

              return Stack(children: [
                /// HomePage
                SafeArea(
                    child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              /// Top Bar
                              Consumer<UserService>(
                                  builder: (_, userService, __) {
                                return Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.all(normal_100),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                (userService.user == null)
                                                    ? ShimmerFx(
                                                        child: Container(
                                                            color: Theme.of(
                                                                    context)
                                                                .cardColor,
                                                            child: Text(
                                                                'Montpellier, France',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText2)))
                                                    : Text(
                                                        '${userService.user!.address!.city}, ${userService.user!.address!.countryName}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2),
                                                const SizedBox(width: small_50),
                                                Icon(Icons.pin_drop_rounded,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    size: normal_100)
                                              ])),
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const SizedBox(width: normal_100),
                                            SmallIconButton(
                                                onPressed: _openSideMenu,
                                                icon: const Icon(
                                                    Icons.menu_rounded,
                                                    size: normal_150)),
                                            const SizedBox(width: normal_100),
                                            Expanded(
                                                child: (userService.user ==
                                                        null)
                                                    ? ShimmerFx(
                                                        child: Expanded(
                                                            child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                            Container(
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                                child: Text(
                                                                    'Welcome',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .subtitle2)),
                                                            Container(
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                                child: Text(
                                                                    'Abdelmadjid',
                                                                    //default width name
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .subtitle1))
                                                          ])))
                                                    : RichText(
                                                        textAlign:
                                                            TextAlign.start,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        text:
                                                            TextSpan(children: [
                                                          TextSpan(
                                                              text: 'Welcome\n',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .subtitle2),
                                                          TextSpan(
                                                              text:
                                                                  '${userService.user!.firstName}.',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .subtitle1)
                                                        ]))),
                                            SmallIconButton(
                                                onPressed: () {},
                                                icon: const Icon(ProximityIcons
                                                    .notifications)),
                                            const SizedBox(width: normal_100)
                                          ])
                                    ]);
                              }),

                              /// Orders Section
                              SectionDivider(
                                  leadIcon: ProximityIcons.order,
                                  title: 'Orders.',
                                  color: redSwatch.shade400,
                                  seeMore: () {}),
                              const OrdersDashboard(),

                              /// Stores Section
                              const StoresSection()
                            ]))),

                /// blur background
                (_drawerAnimation.value != 0.0)
                    ? GestureDetector(
                        onTap: () => _drawerAnimation.reverse(),
                        child: BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: small_100 * _drawerAnimation.value,
                                sigmaY: small_100 * _drawerAnimation.value),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                color: Theme.of(context)
                                    .backgroundColor
                                    .withOpacity(_drawerAnimation.value / 3))))
                    : const SizedBox(),

                /// Side Menu (Drawer)
                Transform(
                    transform: Matrix4.identity()
                      ..translate(_sign *
                          (-_maxSlideProfile +
                              _slideProfile * _openedSideMenu)),
                    child:
                        (_drawerAnimation.value != 0.0 && _openedSideMenu > 0)
                            ? const SideMenu()
                            : const SizedBox())
              ]);
            }));
  }
}
