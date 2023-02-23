import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/user_repository/user_repository.dart';

import '../view/notifications_screen.dart';

class HomeTabBar extends StatelessWidget {
  const HomeTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserService>(builder: (_, userService, __) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
              padding: const EdgeInsets.all(normal_100),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    (userService.valid)
                        ? Text(
                            '${userService.user!.address!.city}, ${userService.user!.address!.countryName}',
                            style: Theme.of(context).textTheme.bodyText2)
                        : ShimmerFx(
                            child: Container(
                                color: Theme.of(context).cardColor,
                                child: Text('Montpellier, France',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2))),
                    const SizedBox(width: small_50),
                    Icon(Icons.pin_drop_rounded,
                        color: Theme.of(context).primaryColor, size: normal_100)
                  ])),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const SizedBox(width: normal_100),
            Expanded(
                child: (userService.valid)
                    ? RichText(
                        text: TextSpan(children: [
                        TextSpan(
                            text: 'Welcome\n',
                            style: Theme.of(context).textTheme.subtitle2),
                        TextSpan(
                            text: '${userService.user!.userName}.',
                            style: Theme.of(context).textTheme.subtitle1)
                      ]))
                    : ShimmerFx(
                        child: Container(
                            color: Theme.of(context).cardColor,
                            child: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: 'Welcome\n',
                                  style: Theme.of(context).textTheme.subtitle2),
                              TextSpan(
                                  text: 'Frédéric.',
                                  style: Theme.of(context).textTheme.subtitle1)
                            ]))))),
            SmallIconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationsScreen()));
                },
                icon: const Icon(ProximityIcons.notifications)),
            const SizedBox(width: normal_100)
          ]),
        ],
      );
    });
  }
}
