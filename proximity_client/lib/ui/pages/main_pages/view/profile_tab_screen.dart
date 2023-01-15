import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/user_repository/user_repository.dart';
import 'package:proximity_client/ui/pages/pages.dart';

class ProfileTabScreen extends StatelessWidget {
  const ProfileTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: large_100),
      children: [
        const AccountSwitcher(),
        const OrdersDashboard(),
        SectionDivider(
            title: 'Settings.',
            leadIcon: ProximityIcons.settings,
            color: redSwatch.shade500),
        Consumer<UserService>(builder: (context, userService, __) {
          return ListButton(
              title: 'Edit Profile.',
              leadIcon: ProximityIcons.edit,
              onPressed: (userService.user == null)
                  ? null
                  : () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditProfileScreen(user: userService.user!)));
                    });
        }),
        Consumer<UserService>(builder: (context, userService, __) {
          return ListButton(
              title: 'Preferences.',
              leadIcon: ProximityIcons.preferences,
              onPressed: (userService.user == null)
                  ? null
                  : () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PreferencesScreen(user: userService.user!)));
                    });
        }),
        const ListButton(
            title: 'Payment Methods.',
            leadIcon: ProximityIcons.credit_card,
            onPressed: null
        ),
            // onPressed: () {
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => const EditPaymentMethodsScreen()));
            // }),
        ListButton(
            title: 'Appearance.',
            leadIcon: ProximityIcons.appearance,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AppearanceScreen()));
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
            title: 'About.',
            leadIcon: ProximityIcons.info,
            color: redSwatch.shade500),
        const ListButton(
            title: 'Rate Proximity.',
            leadIcon: ProximityIcons.star,
            onPressed: null),
        const ListButton(
            title: 'Contact Support.',
            leadIcon: ProximityIcons.support,
            onPressed: null),
        ListButton(
            title: 'Logout.',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          const OnboardingScreen()),
                  (route) => false);
            }),
        const SizedBox(height: large_200 + small_100),
      ],
    );
  }
}
