import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
<<<<<<< HEAD
import 'package:proximity_commercant/ui/pages/authentication_pages/view/terms_conditions_screen.dart';
=======
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key? key, required this.value, this.onChanged})
      : super(key: key);

  final bool value;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Padding(
      padding: const EdgeInsets.all(normal_100),
      child: InkWell(
          onTap: onChanged,
          child: Row(children: [
            Icon(value ? ProximityIcons.check_filled : ProximityIcons.check,
                size: normal_125,
                color: value ? Theme.of(context).primaryColor : null),
            const SizedBox(width: small_100),
            Text('I Agree to the ',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: normal_100)),
            GestureDetector(
              onTap: (() => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => TermsAndAgreementsScreen()),
                  (Route<dynamic> route) => true)),
              child: Text('Terms & Conditions.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: normal_100)),
            )
          ])),
    );
=======
    return InkWell(
        onTap: onChanged,
        child: Padding(
            padding: const EdgeInsets.all(normal_100),
            child: Row(children: [
              Icon(value ? ProximityIcons.check_filled : ProximityIcons.check,
                  size: normal_125,
                  color: value ? Theme.of(context).primaryColor : null),
              const SizedBox(width: small_100),
              const Text('I Agree to the '),
              Text('Terms & Conditions.',
                  style: Theme.of(context).textTheme.bodyText1)
            ])));
>>>>>>> 013281680d734e7e73222774a5e78c0a7d5ce705
  }
}
