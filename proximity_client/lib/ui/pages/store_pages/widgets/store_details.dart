import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';

class StoreDetails extends StatelessWidget {
  StoreDetails({Key? key, required this.name, required this.rating, this.image})
      : super(key: key);

  final String name;
  String? image;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(normal_100),
        child: Row(children: [
          if (image != null)
            SizedBox(
                height: large_150,
                width: large_150,
                child: Stack(alignment: Alignment.topRight, children: [
                  Positioned.fill(
                      child: ClipRRect(
                          borderRadius: const BorderRadius.all(normalRadius),
                          child: FittedBox(
                              fit: BoxFit.cover,
                              child: (image != null)
                                  ? Image.network(image ?? "")
                                  : Image.network(
                                      "https://cdn-icons-png.flaticon.com/512/5853/5853761.png")))),
                ])),
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
