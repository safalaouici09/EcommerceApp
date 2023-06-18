import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/store_repository/models/workingTime_model.dart';
import 'package:proximity_client/domain/store_repository/store_repository.dart';
import 'package:proximity_client/ui/pages/store_pages/store_pages.dart';
import 'package:intl/intl.dart';

class StoreSection extends StatefulWidget {
  const StoreSection({Key? key, required this.idStore}) : super(key: key);

  final String idStore;

  @override
  State<StoreSection> createState() => _StoreSectionState();
}

class _StoreSectionState extends State<StoreSection> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    Widget getWorkingTime(WorkingTime workingTime) {
      if (workingTime.option == '1' &&
          workingTime.fixedHours != null &&
          workingTime.fixedHours!.isNotEmpty) {
        // Fixed working hours for all days
        final timeRanges = workingTime.fixedHours!.map((range) {
          final startTime = range.openTime!.format(context);
          final endTime = range.closeTime!.format(context);
          return '$startTime - $endTime';
        }).toList();

        final days = [
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
          'Sunday',
        ];

        final workingTimeRows = days.map((day) {
          final isOpen = true; // All days are open for option '1'

          final dayWidget = Text(
            day,
            style:
                Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 15),
          );

          final switchWidget = Switch(
            value: isOpen,
            activeColor: Colors.blue,
            onChanged: (newValue) {
              // Handle toggle switch state change
              // You can update the 'isOpen' state here
            },
          );

          final workingHoursWidgets = timeRanges.map((timeRange) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                timeRange,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            );
          }).toList();

          return Row(
            children: [
              SizedBox(width: 100, child: dayWidget),
              switchWidget,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: workingHoursWidgets,
                ),
              ),
            ],
          );
        }).toList();

        return Column(
          children: workingTimeRows,
        );
      } else if (workingTime.option == '2' &&
          workingTime.customizedHours != null &&
          workingTime.customizedHours!.isNotEmpty) {
        // Customized working hours for specific days
        final days = [
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
          'Sunday'
        ];

        final workingTimeRows = days.map((day) {
          final isOpen = workingTime.customizedHours!.containsKey(day);
          final timeRanges = isOpen
              ? workingTime.customizedHours![day]!.map((range) {
                  final startTime = range.openTime!.format(context);
                  final endTime = range.closeTime!.format(context);
                  return '$startTime - $endTime';
                }).toList()
              : ['Closed'];

          final dayWidget = Text(
            day,
            style:
                Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 15),
          );

          final switchWidget = Switch(
            value: isOpen,
            activeColor: Colors.blue,
            onChanged: (newValue) {
              // Handle toggle switch state change
              // You can update the 'isOpen' state here
            },
          );

          final workingHoursWidgets = timeRanges.map((timeRange) {
            return Padding(
              padding: const EdgeInsets.all(small_50),
              child: Text(
                timeRange,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          }).toList();

          return Row(
            children: [
              SizedBox(width: huge_100, child: dayWidget),
              switchWidget,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: workingHoursWidgets,
                ),
              ),
            ],
          );
        }).toList();

        return Column(
          children: workingTimeRows,
        );
      }

      return Text('No working hours available');
    }

    bool isStoreOpenNow(WorkingTime workingTime) {
      final currentDateTime = DateTime.now();

      if (workingTime.option == '1' &&
          workingTime.fixedHours != null &&
          workingTime.fixedHours!.isNotEmpty) {
        // Fixed working hours for all days
        for (final range in workingTime.fixedHours!) {
          final openTime = DateTime(
            currentDateTime.year,
            currentDateTime.month,
            currentDateTime.day,
            range.openTime!.hour,
            range.openTime!.minute,
          );

          final closeTime = DateTime(
            currentDateTime.year,
            currentDateTime.month,
            currentDateTime.day,
            range.closeTime!.hour,
            range.closeTime!.minute,
          );

          if (currentDateTime.isAfter(openTime) &&
              currentDateTime.isBefore(closeTime)) {
            return true;
          }
        }
      } else if (workingTime.option == '2' &&
          workingTime.customizedHours != null &&
          workingTime.customizedHours!.isNotEmpty) {
        // Customized working hours for specific days
        final currentDay = currentDateTime.weekday;
        final dayName = DateFormat('EEEE').format(currentDateTime);

        if (workingTime.customizedHours!.containsKey(dayName)) {
          final dayRanges = workingTime.customizedHours![dayName]!;
          for (final range in dayRanges) {
            final openTime = DateTime(
              currentDateTime.year,
              currentDateTime.month,
              currentDateTime.day,
              range.openTime!.hour,
              range.openTime!.minute,
            );

            final closeTime = DateTime(
              currentDateTime.year,
              currentDateTime.month,
              currentDateTime.day,
              range.closeTime!.hour,
              range.closeTime!.minute,
            );

            if (currentDateTime.isAfter(openTime) &&
                currentDateTime.isBefore(closeTime)) {
              return true;
            }
          }
        }
      }

      return false;
    }

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
                      Row(children: [
                        if (storeService.store!.image != null)
                          SizedBox(
                              height: large_150,
                              width: large_150,
                              child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Positioned.fill(
                                        child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    normalRadius),
                                            child: FittedBox(
                                                fit: BoxFit.cover,
                                                child: (storeService
                                                            .store!.image !=
                                                        null)
                                                    ? Image.network(storeService
                                                            .store!.image ??
                                                        "")
                                                    : Image.network(
                                                        "https://cdn-icons-png.flaticon.com/512/5853/5853761.png")))),
                                  ])),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(storeService.store!.name!,
                            style: Theme.of(context).textTheme.headlineSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start),
                      ]),
                      Row(
                        children: [
                          StarRating(rating: storeService.store!.rating!),
                          storeService.store!.isNew()
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
                                          .copyWith(
                                              color: greenSwatch.shade900)),
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
                        latLng: LatLng(storeService.store!.address!.lat!,
                            storeService.store!.address!.lng!)),
                    Container(
                        width: double.infinity,
                        color: Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(2 / 3),
                        padding: const EdgeInsets.all(small_100)
                            .copyWith(right: huge_100),
                        child: Text(
                            storeService.store!.address!.streetName ?? '',
                            style: Theme.of(context).textTheme.bodyLarge))
                  ]))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: small_100),
            child: ExpansionPanelList(
              elevation: 0,
              expandedHeaderPadding: EdgeInsets.zero,
              expansionCallback: (panelIndex, isExpanded) {
                setState(() {
                  _isExpanded = !isExpanded;
                });
              },
              children: [
                ExpansionPanel(
                  backgroundColor: Colors.white,
                  headerBuilder: (context, isExpanded) {
                    return ListTile(
                      title: Text(
                          isStoreOpenNow(storeService.store!.workingTime!)
                              ? 'Open'
                              : 'Closed',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: isStoreOpenNow(
                                        storeService.store!.workingTime!)
                                    ? greenSwatch.shade900
                                    : redSwatch.shade900,
                              )),
                    );
                  },
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (storeService.store!.workingTime != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: normal_100),
                          child:
                              getWorkingTime(storeService.store!.workingTime!),
                        ),
                    ],
                  ),
                  isExpanded: _isExpanded,
                ),
              ],
            ),
          )
        ]
      ]);
    });
  }
}
