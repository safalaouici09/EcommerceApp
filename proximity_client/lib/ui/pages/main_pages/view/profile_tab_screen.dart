import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/authentication/authentication.dart';
import 'package:proximity_client/domain/authentication/src/googleSigninApi.dart';
import 'package:proximity_client/domain/data_persistence/src/boxes.dart';
import 'package:proximity_client/domain/notification_repository/notification_repository.dart';
import 'package:proximity_client/domain/user_repository/user_repository.dart';
import 'package:proximity_client/ui/pages/pages.dart';

class ProfileTabScreen extends StatelessWidget {
  const ProfileTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var credentialsBox = Boxes.getCredentials();

    String? _token = credentialsBox.get('token');

    final loginValidation = Provider.of<LoginValidation>(context);
    final userService = Provider.of<UserService>(context);
    final notificationsService = Provider.of<NotificationService>(context);

    if (_token != null && userService.user == null) {
      userService.getUserData();
    }

    return (_token == null)
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: normal_100),
            child: Column(children: [
              const SizedBox(height: large_100),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: normal_100),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(width: normal_100),
                        Expanded(
                            child: Text('Account Options.',
                                style: Theme.of(context).textTheme.subtitle1)),
                      ])),
              SizedBox(
                height: large_100,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: small_100),
                child: Container(
                  width: double.infinity,
                  child: PrimaryButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupScreen()));
                    },
                    title: 'Sign Up.',
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: SecondaryButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  title: 'Log In.',
                ),
              )
            ]),
          )
        : ListView(
            padding: const EdgeInsets.symmetric(vertical: large_100),
            children: [
              const AccountSwitcher(),
              const OrdersDashboard(),
              SectionDivider(
                  title: 'Settings.',
                  leadIcon: ProximityIcons.settings,
                  color: redSwatch.shade500),
              ListButton(
                  title: 'Edit Profile.',
                  leadIcon: ProximityIcons.edit,
                  onPressed: (userService.user == null)
                      ? null
                      : () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EditProfileScreen()));
                        }),
              ListButton(
                  title: 'Preferences.',
                  leadIcon: ProximityIcons.preferences,
                  onPressed: (userService.user == null)
                      ? null
                      : () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PreferencesSliderScreen()));
                        }),
              const ListButton(
                  title: 'Payment Methods.',
                  leadIcon: ProximityIcons.credit_card,
                  onPressed: null),
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
              Consumer<NotificationService>(
                  builder: (_, notificationService, __) {
                var nb_notifs = notificationService.notifications
                    .where((element) => element.seendInList != true)
                    .length;
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(children: [
                        if (nb_notifs > 0)
                          Container(
                              padding: const EdgeInsets.all(tiny_50),
                              margin: const EdgeInsets.only(top: 2, left: 30),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      const BorderRadius.all(tinyRadius),
                                  color: redSwatch.shade500),
                              child: Text(
                                '${nb_notifs}',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                        color: primaryTextDarkColor,
                                        fontWeight: FontWeight.w800),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                        ListButton(
                            title: 'Notifications.',
                            leadIcon: ProximityIcons.notifications,
                            onPressed: () {
                              // notificationService.makeItListSeend();
                              // notificationService.getNotifications(context);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NotificationSettingsScreen(
                                              user: userService.user)));
                            }),
                      ])
                    ]);
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
                  onPressed: () async {
                    try {
                      await GoogleSignInApi.logout();
                    } catch (e) {
                      print(e.toString());
                    }
                    loginValidation.logout();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const MainScreen()),
                        (route) => false);
                  }),
              const SizedBox(height: large_200 + small_100),
            ],
          );
  }
}
