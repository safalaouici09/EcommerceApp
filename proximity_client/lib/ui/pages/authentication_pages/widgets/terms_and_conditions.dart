import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key? key, required this.value, this.onChanged})
      : super(key: key);

  final bool value;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
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
  }
}
