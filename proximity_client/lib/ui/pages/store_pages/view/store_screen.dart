import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/store_repository/models/workingTime_model.dart';
import 'package:proximity_client/ui/pages/product_pages/product_pages.dart';
import 'package:proximity_client/ui/pages/store_pages/store_pages.dart';
import 'package:proximity_client/domain/store_repository/store_repository.dart';
import 'package:intl/intl.dart';
import 'package:proximity/l10n/app_localizations.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  bool didFetch = false;
  bool _isExpanded = false;
  @override
  void initState() {
    didFetch = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
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

      return Text(localizations!.noWorkingHours);
    }

    /// a boolean to help fetch data ONLY if necessary

    return Consumer<StoreService>(builder: (context, storeService, child) {
      /// Do a getShop if necessary
      if (!didFetch) {
        storeService.getStore();
        storeService.getStoreProducts();
        setState(() {
          didFetch = true;
        });
      } else {
        print(storeService.store);
      }

      return Scaffold(
          body: (storeService.loading == true)
              ? const SafeArea(
                  child: Expanded(
                      child: Center(child: CircularProgressIndicator())))
              : (storeService.loading == false &&
                      didFetch == true &&
                      storeService.store == null)
                  ? SafeArea(
                      child: Expanded(
                          child: Center(
                              child: InkWell(
                      onTap: () {
                        storeService.getStore();
                      },
                      child: const Icon(Icons.refresh),
                    ))))
                  : (storeService.store != null)
                      ? SafeArea(
                          child: Expanded(
                              child: ListView(children: [
                          StoreMap(address: storeService.store!.address!),
                          StoreDetails(
                              image: storeService.store!.image!,
                              storeId: storeService.store!.id!,
                              name: storeService.store!.name!,
                              rating: storeService.store!.rating!),
                          StoreDescription(
                              description: storeService.store!.description!),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: small_100),
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
                                          isStoreOpenNow(storeService
                                                  .store!.workingTime!)
                                              ? localizations!.open
                                              : localizations!.closed,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .copyWith(
                                                color: isStoreOpenNow(
                                                        storeService.store!
                                                            .workingTime!)
                                                    ? greenSwatch.shade900
                                                    : redSwatch.shade900,
                                              )),
                                    );
                                  },
                                  body: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (storeService.store!.workingTime !=
                                          null)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: normal_100),
                                          child: getWorkingTime(
                                              storeService.store!.workingTime!),
                                        ),
                                    ],
                                  ),
                                  isExpanded: _isExpanded,
                                ),
                              ],
                            ),
                          ),
                          //StoreProducts
                          SectionDivider(
                              leadIcon: ProximityIcons.product,
                              title: localizations!.storeProducts,
                              color: Theme.of(context).primaryColor),
                          (storeService.products == null)
                              ? const ProductCardsSkeleton()
                              : MasonryGrid(
                                  column: 2,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: small_100),
                                  children: List.generate(
                                      storeService.products!.length,
                                      (i) => ProductCard(
                                          product: storeService.products![i]))),
                          if (storeService.store?.policy != null)
                            Column(
                              children: [
                                SectionDivider(
                                    leadIcon: ProximityIcons.policy,
                                    title: localizations!.storePolicy,
                                    color: Theme.of(context).primaryColor),
                                // MasonryGrid(
                                //delivery policy
                                storeService.store!.policy!.deliveryPolicy !=
                                        null
                                    ? PolicyCard(
                                        leadIcon: ProximityIcons.shipping,
                                        title: localizations.shipping,
                                        subTitle: localizations!.shippingPolicyInfo
                                           // "Estimated delivery time is  days. Shipping fees are will negociate for this product",
                                      )
                                    : Container(),

                                // pickup policy
                                storeService.store!.policy!.pickupPolicy !=
                                            null &&
                                        storeService.store!.policy!
                                                .pickupPolicy!.timeLimit !=
                                            null
                                    ? PolicyCard(
                                        leadIcon: ProximityIcons.self_pickup,
                                        title: localizations!.selfPickup,
                                        subTitle: localizations.pickupInfos
                                            //"Remember to pick up your order from our store within ${storeService.store!.policy!.pickupPolicy!.timeLimit} days, or it will be returned to the shelves. Don't miss out on the chance to make it yours!.",
                                      )
                                    : Container(),
                                // reservation policy
                                storeService.store!.policy!.reservationPolicy !=
                                        null
                                    ? storeService.store!.policy!
                                            .reservationPolicy!.payment!.free!
                                        ? PolicyCard(
                                            leadIcon: Icons.book_online,
                                            title: localizations.reservation,
                                            subTitle: localizations.returnPolicyInfo
                                                //"Once your reservation is confirmed, you may pick up your item from our store within ${storeService.store!.policy!.reservationPolicy!.duration} days",
                                          )
                                        : storeService
                                                    .store!
                                                    .policy!
                                                    .reservationPolicy!
                                                    .payment!
                                                    .partial !=
                                                null
                                            ? PolicyCard(
                                                leadIcon: Icons.book_online,
                                                title:localizations.returnPolicyInfo,
                                                subTitle:
                                                    "${storeService.store!.policy!.reservationPolicy!.payment.partial!.fixe} may be required to secure your reservation.Once your reservation is confirmed, you may pick up your item from our store within ${storeService.store!.policy!.reservationPolicy!.duration} days.",
                                              )
                                            : storeService
                                                    .store!
                                                    .policy!
                                                    .reservationPolicy!
                                                    .payment!
                                                    .free!
                                                ? storeService
                                                        .store!
                                                        .policy!
                                                        .reservationPolicy!
                                                        .payment!
                                                        .total!
                                                    ? PolicyCard(
                                                        leadIcon:
                                                            Icons.book_online,
                                                        title: "Reservation",
                                                        subTitle:
                                                            "a full price payement is  required to secure your reservation.Once your reservation is confirmed, you may pick up your item from our store within ${storeService.store!.policy!.reservationPolicy!.duration} days.",
                                                      )
                                                    : Container()
                                                : Container()
                                    : Container(),
// Return  Policy
                                storeService.store!.policy!.returnPolicy != null
                                    ? storeService.store!.policy!.returnPolicy!
                                                    .refund!.shipping !=
                                                null &&
                                            storeService
                                                    .store!
                                                    .policy!
                                                    .returnPolicy!
                                                    .refund!
                                                    .order !=
                                                null
                                        ? PolicyCard(
                                            leadIcon:
                                                Icons.settings_backup_restore,
                                            title: localizations.returnRefund,
                                            subTitle:
                                                "You may return your item within${storeService.store!.policy!.returnPolicy!.duration} days of receipt for a refund, provided that the item is${storeService.store!.policy!.returnPolicy!.productStatus}. in case the return is accepted , the store will refund shipping fees and ${storeService.store!.policy!.returnPolicy!.refund!.order.fixe} % of the price  ",
                                          )
                                        : storeService
                                                        .store!
                                                        .policy!
                                                        .returnPolicy!
                                                        .refund!
                                                        .shipping ==
                                                    null &&
                                                storeService
                                                        .store!
                                                        .policy!
                                                        .returnPolicy!
                                                        .refund!
                                                        .order !=
                                                    null
                                            ? PolicyCard(
                                                leadIcon: Icons
                                                    .settings_backup_restore,
                                                title:localizations.returnRefund, 
                                                subTitle:
                                                    "You may return your item within${storeService.store!.policy!.returnPolicy!.duration} days of receipt for a refund, provided that the item is${storeService.store!.policy!.returnPolicy!.productStatus}. in case the return is accepted , the store will refund ${storeService.store!.policy!.returnPolicy!.refund!.order.fixe} % of the price , shipping fees are not refunded ",
                                              )
                                            : storeService
                                                            .store!
                                                            .policy!
                                                            .returnPolicy!
                                                            .refund!
                                                            .shipping !=
                                                        null &&
                                                    storeService
                                                            .store!
                                                            .policy!
                                                            .returnPolicy!
                                                            .refund!
                                                            .order ==
                                                        null
                                                ? PolicyCard(
                                                    leadIcon: Icons
                                                        .settings_backup_restore,
                                                    title:
                                                        "Return and Refund  ",
                                                    subTitle:
                                                        "You may return your item within${storeService.store!.policy!.returnPolicy!.duration} days of receipt for a refund, provided that the item is${storeService.store!.policy!.returnPolicy!.productStatus}. in case the return is accepted , the store will refund shipping fees ",
                                                  )
                                                : Container()
                                    : Container(),
                              ],
                            )
                          /*(storeService.products == null)
                      ? const ProductCardsSkeleton()
                      : MasonryGrid(
                          column: 2,
                          padding: const EdgeInsets.symmetric(horizontal: small_100),
                          children: List.generate(storeService.products!.length,
                              (i) => ProductCard(product: storeService.products![i]))),
                  const SizedBox(height: huge_200),*/
                        ])))
                      : Column(
                          children: [],
                        ));
    });
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
}