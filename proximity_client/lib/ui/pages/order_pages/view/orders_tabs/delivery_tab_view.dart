import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/order_repository/order_repository.dart';
import 'package:proximity_client/ui/pages/order_pages/order_pages.dart';

class DeliveryTabView extends StatelessWidget {
  const DeliveryTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ordersService = Provider.of<OrderService>(context);
    ordersService.getDeliveryOrders();

    return (ordersService.deliveryOrders == null)
        ? const Center(child: CircularProgressIndicator())
        : (ordersService.deliveryOrders!.isEmpty)
            ? const NoResults(
                icon: ProximityIcons.empty_illustration,
                message: 'There are no Delivery Orders.')
            : ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: normal_100),
                itemCount: ordersService.deliveryOrders!.length,
                itemBuilder: (_, i) => OrderTile(
                  order: ordersService.deliveryOrders![i],
                ),
              );
  }
}
