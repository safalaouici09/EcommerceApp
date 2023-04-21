import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_commercant/domain/order_repository/order_repository.dart';
import 'package:proximity_commercant/ui/pages/order_pages/order_pages.dart';

class RejectedView extends StatelessWidget {
  const RejectedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ordersService = Provider.of<OrderService>(context);
    return Container();
    /* ordersService.getRejectedOrders();

    return (ordersService.rejectedOrders == null)
        ? const Center(child: CircularProgressIndicator())
        : (ordersService.rejectedOrders!.isEmpty)
            ? const NoResults(
                icon: ProximityIcons.product,
                message: 'There are no Rejected Orders.')
            : ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: normal_100),
                itemCount: ordersService.rejectedOrders!.length,
                itemBuilder: (_, i) => OrderTile(
                  order: ordersService.rejectedOrders![i],
                ),
              );*/
  }
}
