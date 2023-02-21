import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_commercant/domain/authentication/authentication.dart';
import 'package:proximity_commercant/domain/data_persistence/data_persistence.dart';
import 'package:proximity_commercant/domain/user_repository/user_repository.dart';
import 'package:proximity_commercant/ui/pages/authentication_pages/view/onBoard.dart';
=======
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_commercant/domain/user_repository/user_repository.dart';
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
import 'package:proximity_commercant/ui/pages/user_pages/user_pages.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width - normal_200;
<<<<<<< HEAD
    final loginValidation = Provider.of<LoginValidation>(context);
=======
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
    return SafeArea(
        child: Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Theme.of(context).dividerColor, width: tiny_50),
                borderRadius:
                    const BorderRadius.horizontal(right: normalRadius)),
            child: SizedBox(
                width: _width,
                child:
                    ListView(physics: const ClampingScrollPhysics(), children: [
                  const SizedBox(height: normal_200),
                  const AccountSwitcher(),
                  SectionDivider(
                      leadIcon: ProximityIcons.settings,
                      title: 'Settings',
                      color: redSwatch.shade400),
                  Selector<UserService, bool>(
                      selector: (_, userService) => userService.valid,
                      builder: (context, valid, child) {
                        return ListButton(
                            title: 'Edit Profile.',
                            leadIcon: ProximityIcons.edit,
                            enabled: valid,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const EditProfileScreen()));
                            });
                      }),
                  Selector<UserService, bool?>(
                      selector: (_, userService) => userService.isVerified,
                      builder: (context, valid, child) {
                        return ListButton(
                            title: 'Verify Identity.',
                            leadIcon: ProximityIcons.password,
                            enabled: valid,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
<<<<<<< HEAD
                                          const EditProfileScreen()));
=======
                                      const EditProfileScreen()));
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
                            });
                      }),
                  ListButton(
                      title: 'Settings.',
                      leadIcon: ProximityIcons.preferences,
                      enabled: false,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingsScreen()));
                      }),
                  ListButton(
                      title: 'Appearance.',
                      leadIcon: ProximityIcons.appearance,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AppearanceScreen()));
                      }),
                  ListButton(
                      title: 'Language.',
                      leadIcon: ProximityIcons.language,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LanguageScreen()));
                      }),
                  ListButton(
                      title: 'Notifications.',
                      leadIcon: ProximityIcons.notifications,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationsPreferencesScreen()));
                      }),
                  const SizedBox(height: normal_100),
                  SectionDivider(
                      leadIcon: ProximityIcons.info,
                      title: 'About.',
                      color: redSwatch.shade400),
                  ListButton(
                      title: 'Rate SmartCity.',
                      leadIcon: ProximityIcons.star,
                      onPressed: () {}),
                  ListButton(
                      title: 'Contact Support.',
                      leadIcon: ProximityIcons.support,
                      onPressed: () {}),
                  const Divider(height: normal_200),
<<<<<<< HEAD
                  ListButton(
                      title: 'Log out.',
                      leadIcon: Icons.logout_rounded,
                      onPressed: () {
                        loginValidation.logout();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const OnBoard()),
                            (Route<dynamic> route) => false);
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/", (r) => false);
=======
                  ListButton(title: 'Log out.',
                      leadIcon: Icons.logout_rounded,
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false);
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
                      }),
                  const SizedBox(height: huge_200)
                ]))));
  }
}
