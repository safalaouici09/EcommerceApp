import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:proximity/proximity.dart';

class StoreMap extends StatelessWidget {
  const StoreMap({Key? key, required this.address}) : super(key: key);

  final Address address;

  @override
  Widget build(BuildContext context) {
    /// calculate card height to avoid PageView overflow
    double _screenWidth = MediaQuery.of(context).size.width;
    double _cardImageWidth = _screenWidth - (small_100 + tiny_50) * 2;
    double _cardImageHeight = _cardImageWidth * 8 / 11;

    return Card(
        margin: const EdgeInsets.all(small_100).copyWith(bottom: 0),
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Theme.of(context).dividerColor, width: tiny_50),
            borderRadius: const BorderRadius.all(normalRadius)),
        child: SizedBox(
            width: _cardImageWidth,
            height: _cardImageHeight,
            child: Stack(children: [
              GoogleMapsAddress(
                  borderRadius: const BorderRadius.all(normalRadius),
                  latLng: LatLng(address.lat!, address.lng!)),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                      width: double.infinity,
                      color:
                          Theme.of(context).backgroundColor.withOpacity(2 / 3),
                      padding: const EdgeInsets.all(small_100)
                          .copyWith(right: huge_100),
                      child: Text(
                          address.getAddressLine,
                          style: Theme.of(context).textTheme.bodyText1))),

              /// Top Buttons
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: small_100, vertical: normal_100),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SmallIconButton(
                            onPressed: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            },
                            icon: const Icon(ProximityIcons.chevron_left)),
                        SmallIconButton(
                            onPressed: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            },
                            icon: const Icon(ProximityIcons.more))
                      ])),
            ])));
  }
}
