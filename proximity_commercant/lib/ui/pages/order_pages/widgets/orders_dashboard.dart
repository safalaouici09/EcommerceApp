import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_commercant/ui/pages/order_pages/order_pages.dart';

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
                child: SizedBox(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        DuotoneIcon(
                                            primaryLayer:
                                                ProximityIcons.unpaid_duotone_1,
                                            secondaryLayer:
                                                ProximityIcons.unpaid_duotone_1,
                                            color: redSwatch.shade500),
                                        Text('Pending',
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        DuotoneIcon(
                                            primaryLayer: ProximityIcons
                                                .not_shipped_duotone_1,
                                            secondaryLayer: ProximityIcons
                                                .not_shipped_duotone_2,
                                            color: redSwatch.shade500),
                                        Text('Confirmed',
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        DuotoneIcon(
                                            primaryLayer: ProximityIcons
                                                .delivery_duotone_1,
                                            secondaryLayer: ProximityIcons
                                                .delivery_duotone_2,
                                            color: redSwatch.shade500),
                                        Text('Delivered',
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        DuotoneIcon(
                                            primaryLayer: ProximityIcons
                                                .rejected_duotone_1,
                                            secondaryLayer: ProximityIcons
                                                .rejected_duotone_2,
                                            color: redSwatch.shade500),
                                        Text('Rejected',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(height: 0.9))
                                      ])))
                        ])))));
  }
}
