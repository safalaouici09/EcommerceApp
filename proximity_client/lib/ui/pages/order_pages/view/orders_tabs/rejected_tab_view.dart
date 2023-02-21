import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/order_repository/order_repository.dart';
import 'package:proximity_client/ui/pages/order_pages/order_pages.dart';

class RejectedTabView extends StatelessWidget {
  const RejectedTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ordersService = Provider.of<OrderService>(context);
    ordersService.getCanceledOrders();

    return (ordersService.canceledOrders == null)
        ? const Center(child: CircularProgressIndicator())
        : (ordersService.canceledOrders!.isEmpty)
            ? const NoResults(
                icon: ProximityIcons.empty_illustration,
                message: 'There are no Rejected Orders.')
            : ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: normal_100),
                itemCount: ordersService.canceledOrders!.length,
                itemBuilder: (_, i) => OrderTile(
                  order: ordersService.canceledOrders![i],
                ),
              );
  }
}
