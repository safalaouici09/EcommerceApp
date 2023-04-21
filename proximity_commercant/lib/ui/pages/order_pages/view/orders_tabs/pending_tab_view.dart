import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_commercant/domain/order_repository/order_repository.dart';
import 'package:proximity_commercant/ui/pages/order_pages/order_pages.dart';

class PendingTabView extends StatelessWidget {
  const PendingTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ordersService = Provider.of<OrderService>(context);
    return Container();
    /* ordersService.getPendingOrders();

    return (ordersService.pendingOrders == null)
        ? const Center(child: CircularProgressIndicator())
        : (ordersService.pendingOrders!.isEmpty)
            ? const NoResults(
                icon: ProximityIcons.product,
                message: 'There are no Pending Orders.')
            : ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: normal_100),
                itemCount: ordersService.pendingOrders!.length,
                itemBuilder: (_, i) => OrderTile(
                  order: ordersService.pendingOrders![i],
                  action: () {
                    ordersService.confirmOrder(
                        context, ordersService.pendingOrders![i].id!);
                  },
                  secondaryAction: () {},
                ),
              );*/
  }
}
