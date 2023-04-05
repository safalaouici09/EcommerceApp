import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/order_repository/order_repository.dart';
import 'package:proximity_client/ui/pages/pages.dart';
import 'package:intl/intl.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({Key? key, required this.order}) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    /// get Locale
    final Locale _locale = Localizations.localeOf(context);

    return Container(
        margin: const EdgeInsets.all(normal_100),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(normalRadius),
            border: Border.all(
                width: tiny_50, color: Theme.of(context).dividerColor)),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Material(
              color: Colors.transparent,
              child: InkWell(
                  // onTap: () =>
                  //     cartService.checkAllOrderedProducts(cart.storeId!),
                  child: Padding(
                      padding: const EdgeInsets.all(small_100),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SmallIconButton(
                                onPressed: () {},
                                icon: Icon(ProximityIcons.store,
                                    color: Theme.of(context).primaryColor)),
                            const SizedBox(width: small_100),
                            Expanded(
                                child: Text('${order.storeName}',
                                    style:
                                        Theme.of(context).textTheme.headline4)),
                          ])))),

          const Divider(thickness: tiny_50, height: tiny_50),

          /// Order Details
          OrderDetails(details: {
            'Your Order ID': '#${order.id}',
            'Order Date': (order.orderDate != null)
                ? DateFormat.yMMMEd(
                        _locale.languageCode + '_' + _locale.countryCode!)
                    .format(order.orderDate!)
                : '--:--:----',
          }),
          if (order.delivery == true)
            OrderDetails(details: {
              'Delivery Date': (order.deliveryDate != null)
                  ? DateFormat.yMMMEd(
                          _locale.languageCode + '_' + _locale.countryCode!)
                      .format(order.deliveryDate!)
                  : '--:--:----',
              'Shipping Address': order.shippingAddress!.getAddressLine,
            }),

          if (order.pickup == true)
            OrderDetails(details: {
              'Pickup By': (order.pickupPerson != null &&
                      order.pickupPerson?["name"] != null)
                  ? order.pickupPerson!["name"] ?? ""
                  : '',
              'NIF': (order.pickupPerson != null &&
                      order.pickupPerson?["nif"] != null)
                  ? order.pickupPerson!["nif"] ?? ""
                  : '',
            }),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Container(
              width: 150,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.only(
                      topLeft: normalRadius, bottomLeft: normalRadius)),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  'Pending',
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEFEFEF)),
                ),
              ]),
            ),
          ]),

          /// Order Items (Ordered Products)
          ...List.generate(order.items!.length,
              (index) => OrderItemTile(orderItem: order.items![index])),
          const Divider(height: tiny_50, thickness: tiny_50),
          Padding(
              padding: const EdgeInsets.all(small_100),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total:',
                        style: Theme.of(context).textTheme.headline3),
                    Text(' € ${order.totalPrice}',
                        style: Theme.of(context).textTheme.headline3)
                  ]))
        ]));
  }
}
