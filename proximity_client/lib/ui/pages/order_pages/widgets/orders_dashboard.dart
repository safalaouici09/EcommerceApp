import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/ui/pages/order_pages/order_pages.dart';

class OrdersDashboard extends StatelessWidget {
  const OrdersDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: normal_150),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(smallRadius),
          border: Border.all(
              color: Theme.of(context).dividerColor, width: tiny_50)),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(innerBorderRadius),
        child: Material(
          color: Theme.of(context).cardColor,
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: small_100),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('My Orders',
                          style: Theme.of(context).textTheme.bodyText1),
                      Row(children: [
                        Text('See All',
                            style: Theme.of(context).textTheme.bodyText2),
                        Icon(ProximityIcons.arrow_more,
                            color: Theme.of(context).textTheme.bodyText2!.color)
                      ])
                    ])),
            SizedBox(
                height: large_200,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const OrdersScreen(page: 0))),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DuotoneIcon(
                                        primaryLayer: ProximityIcons
                                            .self_pickup_duotone_1,
                                        secondaryLayer: ProximityIcons
                                            .self_pickup_duotone_2,
                                        color: redSwatch.shade500),
                                    Text('Self Pickup',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(height: 0.9))
                                  ]))),
                      Expanded(
                          child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const OrdersScreen(page: 1))),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DuotoneIcon(
                                        primaryLayer:
                                            ProximityIcons.delivery_duotone_1,
                                        secondaryLayer:
                                            ProximityIcons.delivery_duotone_2,
                                        color: redSwatch.shade500),
                                    Text('Delivery',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(height: 0.9))
                                  ]))),
                      Expanded(
                          child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const OrdersScreen(page: 3))),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DuotoneIcon(
                                        primaryLayer:
                                            ProximityIcons.history_duotone_1,
                                        secondaryLayer:
                                            ProximityIcons.history_duotone_2,
                                        color: redSwatch.shade500),
                                    Text('Reservation',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(height: 0.9))
                                  ]))),
                      Expanded(
                          child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const OrdersScreen(page: 2))),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DuotoneIcon(
                                        primaryLayer:
                                            ProximityIcons.rejected_duotone_1,
                                        secondaryLayer:
                                            ProximityIcons.rejected_duotone_2,
                                        color: redSwatch.shade500),
                                    Text('Rejected',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(height: 0.9))
                                  ])))
                    ]))
          ]),
        ),
      ),
    );
  }
}
