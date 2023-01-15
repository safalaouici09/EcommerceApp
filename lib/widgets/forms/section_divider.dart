import 'package:flutter/material.dart';
import 'package:proximity/config/config.dart';
import 'package:proximity/icons/proximity_icons.dart';

class SectionDivider extends StatelessWidget {
  const SectionDivider(
      {Key? key,
      required this.leadIcon,
      required this.title,
      this.color,
      this.seeMore})
      : super(key: key);

  final IconData leadIcon;
  final String title;
  final Color? color;
  final VoidCallback? seeMore;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(normal_100).copyWith(right: 0),
        child: Row(children: [
          Icon(leadIcon, color: color, size: normal_175),
          const SizedBox(width: small_100),
          Text(title, style: Theme.of(context).textTheme.bodyText2),
          const SizedBox(width: small_100),
          const Expanded(child: Divider(height: tiny_50, thickness: tiny_50)),
          if (seeMore != null)
            GestureDetector(
                onTap: seeMore,
                child: Padding(
                    padding: const EdgeInsets.only(
                        left: small_100, right: normal_100),
                    child: Row(children: [
                      Text('See More',
                          style: Theme.of(context).textTheme.bodyText2),
                      Icon(ProximityIcons.arrow_more,
                          color: Theme.of(context).textTheme.bodyText2!.color)
                    ])))
        ]));
  }
}
