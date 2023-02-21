import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/ui/pages/pages.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key, this.page}) : super(key: key);

  final int? page;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _index = widget.page?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      const TopBar(title: 'My Orders.'),
      Material(
          color: Colors.transparent,
          child: Container(
              height: large_200,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: tiny_50))),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () => setState(() {
                        _index = 0;
                      }),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_index == 0) ...[
                              DuotoneIcon(
                                primaryLayer:
                                    ProximityIcons.self_pickup_duotone_1,
                                secondaryLayer:
                                    ProximityIcons.self_pickup_duotone_2,
                                color: redSwatch.shade500,
                              ),
                              Text('Self Pickup',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(height: 0.9)),
                              const SizedBox(height: tiny_50),
                              Container(
                                  height: tiny_50,
                                  width: normal_150,
                                  decoration: BoxDecoration(
                                      color: redSwatch.shade500,
                                      borderRadius:
                                          const BorderRadius.all(tinyRadius)))
                            ] else
                              const Icon(ProximityIcons.self_pickup),
                          ]),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () => setState(() {
                        _index = 1;
                      }),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_index == 1) ...[
                              DuotoneIcon(
                                primaryLayer: ProximityIcons.delivery_duotone_1,
                                secondaryLayer:
                                    ProximityIcons.delivery_duotone_2,
                                color: redSwatch.shade500,
                              ),
                              Text('Delivery',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(height: 0.9)),
                              const SizedBox(height: tiny_50),
                              Container(
                                  height: tiny_50,
                                  width: normal_150,
                                  decoration: BoxDecoration(
                                      color: redSwatch.shade500,
                                      borderRadius:
                                          const BorderRadius.all(tinyRadius)))
                            ] else
                              const Icon(ProximityIcons.delivery),
                          ]),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () => setState(() {
                        _index = 2;
                      }),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_index == 2) ...[
                              DuotoneIcon(
                                primaryLayer: ProximityIcons.rejected_duotone_1,
                                secondaryLayer:
                                    ProximityIcons.rejected_duotone_2,
                                color: redSwatch.shade500,
                              ),
                              Text('Rejected',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(height: 0.9)),
                              const SizedBox(height: tiny_50),
                              Container(
                                  height: tiny_50,
                                  width: normal_150,
                                  decoration: BoxDecoration(
                                      color: redSwatch.shade500,
                                      borderRadius:
                                          const BorderRadius.all(tinyRadius)))
                            ] else
                              const Icon(ProximityIcons.rejected),
                          ]),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () => setState(() {
                        _index = 3;
                      }),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_index == 3) ...[
                              DuotoneIcon(
                                primaryLayer: ProximityIcons.history_duotone_1,
                                secondaryLayer:
                                    ProximityIcons.history_duotone_2,
                                color: redSwatch.shade500,
                              ),
                              Text('History',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(height: 0.9)),
                              const SizedBox(height: tiny_50),
                              Container(
                                  height: tiny_50,
                                  width: normal_150,
                                  decoration: BoxDecoration(
                                      color: redSwatch.shade500,
                                      borderRadius:
                                          const BorderRadius.all(tinyRadius)))
                            ] else
                              const Icon(ProximityIcons.history),
                          ]),
                    )),
                  ]))),
      Expanded(child: () {
        switch (_index) {
          case 0:
            return const SelfPickupTabView();
          case 1:
            return const DeliveryTabView();
          case 2:
            return const RejectedTabView();
          case 3:
            return const HistoryTabView();
          default:
            return const SelfPickupTabView();
        }
      }())
    ])));
  }
}
