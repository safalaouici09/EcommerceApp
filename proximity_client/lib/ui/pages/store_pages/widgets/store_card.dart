import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/store_repository/models/workingTime_model.dart';
import 'package:proximity_client/domain/store_repository/store_repository.dart';
import 'package:proximity_client/ui/pages/store_pages/store_pages.dart';
import 'package:intl/intl.dart';

class StoreCard extends StatefulWidget {
  const StoreCard({Key? key, required this.store}) : super(key: key);

  final Store store;

  @override
  State<StoreCard> createState() => _StoreCardState();
}

class _StoreCardState extends State<StoreCard> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    void handleRaiting(rating, parentContext) {
      showDialogPopup(
          barrierDismissible: false,
          context: context,
          pageBuilder: (ctx, anim1, anim2) => StatefulBuilder(
              builder: (context, setState) => DialogPopup(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width - normal_200 * 2,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const SizedBox(height: normal_100),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: normal_100,
                                left: normal_100,
                                right: normal_100),
                            child: StarRatingStore()),
                        Padding(
                            padding: const EdgeInsets.all(normal_100),
                            child:
                                Row(mainAxisSize: MainAxisSize.max, children: [
                              Expanded(
                                  child: SecondaryButton(
                                      title: 'Cancel.',
                                      onPressed: () =>
                                          Navigator.of(context).pop())),
                              const SizedBox(
                                width: small_100,
                              ),
                              Expanded(
                                  child: SecondaryButton(
                                      title: 'Valider.',
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                      })),
                            ]))
                      ])))));
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (widget.store == null)
        const StoreSectionSkeleton()
      else ...[
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: small_100),
            child: Row(children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Row(children: [
                      if (widget.store.image != null)
                        SizedBox(
                            height: large_150,
                            width: large_150,
                            child:
                                Stack(alignment: Alignment.topRight, children: [
                              Positioned.fill(
                                  child: ClipRRect(
                                      borderRadius:
                                          const BorderRadius.all(normalRadius),
                                      child: FittedBox(
                                          fit: BoxFit.cover,
                                          child: (widget.store!.image != null)
                                              ? Image.network(
                                                  widget.store!.image ?? "")
                                              : Image.network(
                                                  "https://cdn-icons-png.flaticon.com/512/5853/5853761.png")))),
                            ])),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(widget.store!.name!,
                          style: Theme.of(context).textTheme.headlineSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start),
                    ]),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            handleRaiting(widget.store!.rating, context);
                          },
                          child: StarRating(rating: widget.store!.rating!),
                        ),
                        widget.store!.isNew()
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: small_50, vertical: tiny_50),
                                decoration: BoxDecoration(
                                    color: greenSwatch.shade300,
                                    borderRadius:
                                        const BorderRadius.all(normalRadius),
                                    border: Border.all(
                                        color: greenSwatch.shade200)),
                                child: Text("New",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: greenSwatch.shade900)),
                              )
                            : Container()
                      ],
                    )
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
                      latLng: LatLng(widget.store!.address!.lat!,
                          widget.store!.address!.lng!)),
                  Container(
                      width: double.infinity,
                      color: Theme.of(context)
                          .colorScheme
                          .background
                          .withOpacity(2 / 3),
                      padding: const EdgeInsets.all(small_100)
                          .copyWith(right: huge_100),
                      child: Text(widget.store!.address!.streetName ?? '',
                          style: Theme.of(context).textTheme.bodyLarge))
                ]))),
      ]
    ]);
  }
}
