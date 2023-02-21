import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';

class StoreDetails extends StatelessWidget {
  const StoreDetails(
      {Key? key,
      required this.name,
      required this.rating})
      : super(key: key);

  final String name;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(normal_100),
        child: Row(children: [
          SmallIconButton(
              onPressed: () {},
              icon: Icon(ProximityIcons.store,
                  color: Theme.of(context).primaryColor)),
          const SizedBox(width: normal_100),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(name,
                    style: Theme.of(context).textTheme.headline5,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start),
                StarRating(rating: rating)
              ])),
          // Text(followers.toString()),
          const Icon(ProximityIcons.heart)
        ]));
  }
}
