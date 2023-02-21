import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/store_repository/store_repository.dart';
import 'package:proximity_client/ui/pages/store_pages/store_pages.dart';

class StoreSection extends StatelessWidget {
  const StoreSection({Key? key, required this.idStore}) : super(key: key);

  final String idStore;

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreService>(builder: (_, storeService, __) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        SectionDivider(
            leadIcon: ProximityIcons.store,
            title: 'Store.',
            color: Theme.of(context).primaryColor),
        if (storeService.store == null)
          const StoreSectionSkeleton()
        else ...[
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: small_100),
              child: Row(children: [
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(storeService.store!.name!,
                          style: Theme.of(context).textTheme.headline5,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start),
                      StarRating(rating: storeService.store!.rating!)
                    ])),
                TertiaryButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StoreScreen())),
                    title: 'Go to Store.')
              ])),
          const SizedBox(height: small_100),
          Card(
              margin: const EdgeInsets.symmetric(horizontal: normal_100),
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Theme.of(context).dividerColor, width: tiny_50),
                  borderRadius: const BorderRadius.all(smallRadius)),
              child: SizedBox(
                  height: huge_300,
                  child: Stack(alignment: Alignment.bottomCenter, children: [
                    GoogleMapsAddress(
                        borderRadius: const BorderRadius.all(normalRadius),
                        latLng: LatLng(storeService.store!.address!.lat!,
                            storeService.store!.address!.lng!)),
                    Container(
                        width: double.infinity,
                        color: Theme.of(context)
                            .backgroundColor
                            .withOpacity(2 / 3),
                        padding: const EdgeInsets.all(small_100)
                            .copyWith(right: huge_100),
                        child: Text(
                            storeService.store!.address!.streetName ?? '',
                            style: Theme.of(context).textTheme.bodyText1))
                  ])))
        ]
      ]);
    });
  }
}
