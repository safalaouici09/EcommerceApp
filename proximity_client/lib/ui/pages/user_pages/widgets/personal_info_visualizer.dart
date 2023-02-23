import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/user_repository/user_repository.dart';
import 'package:proximity_client/ui/pages/user_pages/view/view.dart';

class PersonalInfoVisualizer extends StatelessWidget {
  const PersonalInfoVisualizer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserService>(builder: (_, userService, __) {
      return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        const SizedBox(width: normal_100),
        if (userService.valid)
          Expanded(
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: userService.user!.userName,
                  style: Theme.of(context).textTheme.bodyText1),
              TextSpan(text: '\n${userService.user!.address!.getAddressLine}'),
              TextSpan(text: '\n${userService.user!.address!.postalCode}'),
              TextSpan(text: '\n${userService.user!.phone}'),
            ], style: Theme.of(context).textTheme.bodyText2)),
          ),
        const SizedBox(width: normal_100),
        TertiaryButton(
            onPressed: userService.valid
                ? () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfileScreen()));
                  }
                : null,
            title: 'Change.'),
        const SizedBox(width: normal_100)
      ]);
    });
  }
}
