import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/order_repository/order_repository.dart';
import 'package:proximity_client/ui/pages/order_pages/order_pages.dart';

class ReturnTabView extends StatefulWidget {
  const ReturnTabView({Key? key, this.page}) : super(key: key);

  final int? page;

  @override
  State<ReturnTabView> createState() => _ReturnTabViewState();
}

class _ReturnTabViewState extends State<ReturnTabView> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _index = widget.page ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final ordersService = Provider.of<OrderService>(context);
    if (ordersService.returnOrders == null && _index == 0) {
      // ordersService.getReturnOrders();
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
                    // ordersService.getReturnOrders();
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
                    // ordersService.getReturnOrders();
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
                  onTap: () => setState(() {
                    _index = 2;
                  }),
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: normal_100),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_index == 2) ...[
                              Text('Returned',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          height: 0.9,
                                          color: redSwatch.shade500)),
                            ] else
                              Text('Returned',
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
      Expanded(child: () {
        switch (_index) {
          case 0:
            return (ordersService.returnOrders == null)
                ? const Center(child: CircularProgressIndicator())
                : (ordersService.returnOrders!.isEmpty)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: large_200, horizontal: large_100),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: huge_100,
                                width: huge_100,
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
                                                  child: Image.asset(
                                                    "assets/img/return_icon.png",
                                                    color: Theme.of(context)
                                                        .dividerColor,
                                                  )))),
                                    ])),
                            const SizedBox(height: normal_100),
                            Text("There are no Return Orders.",
                                style: Theme.of(context).textTheme.subtitle2,
                                textAlign: TextAlign.center),
                            const SizedBox(height: huge_100),
                          ],
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        padding:
                            const EdgeInsets.symmetric(vertical: normal_100),
                        itemCount: ordersService.returnOrders!.length,
                        itemBuilder: (_, i) => OrderTile(
                          order: ordersService.returnOrders![i],
                        ),
                      );
          case 1:
            return (ordersService.returnOrders == null)
                ? const Center(child: CircularProgressIndicator())
                : (ordersService.returnOrders!.isEmpty)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: large_200, horizontal: large_100),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: huge_100,
                                width: huge_100,
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
                                                  child: Image.asset(
                                                    "assets/img/return_icon.png",
                                                    color: Theme.of(context)
                                                        .dividerColor,
                                                  )))),
                                    ])),
                            const SizedBox(height: normal_100),
                            Text("There are no Return Orders.",
                                style: Theme.of(context).textTheme.subtitle2,
                                textAlign: TextAlign.center),
                            const SizedBox(height: huge_100),
                          ],
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        padding:
                            const EdgeInsets.symmetric(vertical: normal_100),
                        itemCount: ordersService.returnOrders!.length,
                        itemBuilder: (_, i) => OrderTile(
                          order: ordersService.returnOrders![i],
                        ),
                      );
          case 2:
            return Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: large_200, horizontal: large_100),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: huge_100,
                      width: huge_100,
                      child: Stack(alignment: Alignment.topRight, children: [
                        Positioned.fill(
                            child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(normalRadius),
                                child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: Image.asset(
                                      "assets/img/return_icon.png",
                                      color: Theme.of(context).dividerColor,
                                    )))),
                      ])),
                  const SizedBox(height: normal_100),
                  Text("There are no Returned Orders.",
                      style: Theme.of(context).textTheme.subtitle2,
                      textAlign: TextAlign.center),
                  const SizedBox(height: huge_100),
                ],
              ),
            );

          default:
            return (ordersService.returnOrders == null)
                ? const Center(child: CircularProgressIndicator())
                : (ordersService.returnOrders!.isEmpty)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: large_200, horizontal: large_100),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: huge_100,
                                width: huge_100,
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
                                                  child: Image.asset(
                                                    "assets/img/return_icon.png",
                                                    color: Theme.of(context)
                                                        .dividerColor,
                                                  )))),
                                    ])),
                            const SizedBox(height: normal_100),
                            Text("There are no Return Orders.",
                                style: Theme.of(context).textTheme.subtitle2,
                                textAlign: TextAlign.center),
                            const SizedBox(height: huge_100),
                          ],
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        padding:
                            const EdgeInsets.symmetric(vertical: normal_100),
                        itemCount: ordersService.returnOrders!.length,
                        itemBuilder: (_, i) => OrderTile(
                          order: ordersService.returnOrders![i],
                        ),
                      );
        }
      }())
    ]);
  }
}
