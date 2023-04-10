import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/order_repository/order_repository.dart';
import 'package:proximity_client/ui/pages/order_pages/order_pages.dart';

class PendingView extends StatefulWidget {
  const PendingView({Key? key, this.page}) : super(key: key);

  final int? page;

  @override
  State<PendingView> createState() => _PendingViewState();
}

class _PendingViewState extends State<PendingView> {
  @override
  Widget build(BuildContext context) {
    final ordersService = Provider.of<OrderService>(context);
    if (ordersService.pendingOrders == null) {
      ordersService.getPendingOrders();
    }
    return Column(children: [
      Expanded(
          child: (ordersService.pendingOrders == null)
              ? const Center(child: CircularProgressIndicator())
              : (ordersService.pendingOrders!.isEmpty)
                  ? const NoResults(
                      icon: ProximityIcons.self_pickup_duotone_1,
                      message: 'There are no Pending Orders.')
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: normal_100),
                      itemCount: ordersService.pendingOrders!.length,
                      itemBuilder: (_, i) => OrderTile(
                        order: ordersService.pendingOrders![i],
                      ),
                    ))
    ]);
  }
}
