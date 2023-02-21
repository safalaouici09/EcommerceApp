import 'dart:io';

import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';

class StoreDetails extends StatelessWidget {
  const StoreDetails(
      {Key? key,
      required this.name,
      required this.rating,
      this.image,
      required this.followers})
      : super(key: key);

  final String name;
  final double rating;
  final dynamic image;
  final int followers;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(normal_100),
        child: Row(children: [
          Container(
              width: large_150,
              height: large_150,
              decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(image!)),
                  /*  image: (image is File)
                      ? DecorationImage(image: FileImage(image!))
                      : DecorationImage(image: NetworkImage(image!)),*/
                  borderRadius: const BorderRadius.all(smallRadius),
                  border: Border.all(
                      width: tiny_50, color: Theme.of(context).dividerColor)),
              child: (image == null)
                  ? Icon(ProximityIcons.store,
                      color: Theme.of(context).primaryColor)
                  : null),
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
          Text(followers.toString()),
          const Icon(ProximityIcons.heart)
        ]));
  }
}
