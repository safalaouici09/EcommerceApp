import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/order_repository/order_repository.dart';
import 'package:proximity_client/ui/pages/order_pages/order_pages.dart';

class SelfPickupTabView extends StatefulWidget {
  const SelfPickupTabView({Key? key, this.page}) : super(key: key);

  final int? page;

  @override
  State<SelfPickupTabView> createState() => _SelfPickupTabViewState();
}

class _SelfPickupTabViewState extends State<SelfPickupTabView> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _index = widget.page ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final ordersService = Provider.of<OrderService>(context);
    if (ordersService.orders == null && _index == 0) {
      ordersService.getOrders("pickup", "all");
    }
    return Column(children: [
      Material(
          color: Colors.transparent,
          child: Container(
              height: large_100,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey.shade300, width: tiny_50))),
              child: ListView(scrollDirection: Axis.horizontal, children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    ordersService.getOrders("pickup", "all");
                    setState(() {
                      _index = 0;
                    });
                  },
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: normal_100),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_index == 0) ...[
                              Text('All',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          height: 0.9,
                                          color: redSwatch.shade500)),
                            ] else
                              Text('All',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          height: 0.9,
                                          color: Color.fromARGB(
                                              255, 150, 150, 150))),
                          ])),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    ordersService.getOrders("pickup", "Pending");
                    setState(() {
                      _index = 1;
                    });
                  },
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: normal_100),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_index == 1) ...[
                              Text('Pending',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          height: 0.9,
                                          color: redSwatch.shade500)),
                            ] else
                              Text('Pending',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          height: 0.9,
                                          color: Color.fromARGB(
                                              255, 150, 150, 150))),
                          ])),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    ordersService.getOrders("pickup", "InPreparation");
                    setState(() {
                      _index = 2;
                    });
                  },
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: normal_100),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_index == 2) ...[
                              Text('In preparation',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          height: 0.9,
                                          color: redSwatch.shade500)),
                            ] else
                              Text('In preparation',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          height: 0.9,
                                          color: Color.fromARGB(
                                              255, 150, 150, 150))),
                          ])),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    ordersService.getOrders("pickup", "AwaitingRecovery");
                    setState(() {
                      _index = 3;
                    });
                  },
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: normal_100),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_index == 3) ...[
                              Text('Awaiting Recovery',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          height: 0.9,
                                          color: redSwatch.shade500)),
                            ] else
                              Text('Awaiting Recovery',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          height: 0.9,
                                          color: Color.fromARGB(
                                              255, 150, 150, 150))),
                          ])),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    ordersService.getOrders("pickup", "Recovered");
                    setState(() {
                      _index = 4;
                    });
                  },
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: normal_100),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_index == 4) ...[
                              Text('Recovered',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          height: 0.9,
                                          color: redSwatch.shade500)),
                            ] else
                              Text('Recovered',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          height: 0.9,
                                          color: Color.fromARGB(
                                              255, 150, 150, 150))),
                          ])),
                )),
              ]))),
      Expanded(
        child: (ordersService.loadingOrders)
            ? const Center(child: CircularProgressIndicator())
            : (ordersService.orders!.isEmpty)
                ? NoResults(
                    icon: ProximityIcons.self_pickup_duotone_1,
                    message: _index == 2
                        ? 'There are no In Preparation Orders.'
                        : _index == 3
                            ? 'There are no Awaiting Recovery Orders.'
                            : _index == 4
                                ? 'There are no Recovered Orders.'
                                : "There are no Self Pickup Orders.")
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: normal_100),
                    itemCount: ordersService.orders!.length,
                    itemBuilder: (_, i) => OrderTile(
                      order: ordersService.orders![i],
                      actionCancel:
                          (String motif, BuildContext contextCancel) async {
                        // final bool _result = await PaymentDialogs.cancelOrder(
                        //     context,
                        //     ordersService.orders![i].id,
                        //     ordersService);
                        // if (_result == true) {
                        ordersService.cancelOrder(
                            contextCancel,
                            ordersService.orders![i].id ?? "",
                            motif,
                            null,
                            null,
                            false);
                        // }
                      },
                      action: () {} // index 4
                      ,
                    ),
                  ),
      )
    ]);
  }
}
