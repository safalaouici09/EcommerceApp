import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_commercant/domain/order_repository/order_repository.dart';
import 'package:proximity_commercant/ui/pages/pages.dart';
import 'package:intl/intl.dart';

class OrderTile extends StatelessWidget {
  const OrderTile(
      {Key? key, required this.order, this.action, this.secondaryAction})
      : super(key: key);

  final Order order;
  final VoidCallback? action;
  final VoidCallback? secondaryAction;

  @override
  Widget build(BuildContext context) {
    /// get Locale
    final Locale _locale = Localizations.localeOf(context);

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: normal_100)
            .copyWith(bottom: normal_100),
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
                                icon: Icon(ProximityIcons.user,
                                    color: Theme.of(context).primaryColor)),
                            const SizedBox(width: small_100),
                            Expanded(
                                child: Text('${order.userName}',
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
            'Delivery Date': (order.deliveryDate != null)
                ? DateFormat.yMMMEd(
                        _locale.languageCode + '_' + _locale.countryCode!)
                    .format(order.deliveryDate!)
                : '--:--:----',
            'Shipping Address': order.shippingAddress!.getAddressLine,
          }),

          /// Order Items (Ordered Products)
          ...List.generate(order.items!.length,
              (index) => OrderItemTile(orderItem: order.items![index])),
          const Divider(height: tiny_50, thickness: tiny_50),
          Padding(
              padding: const EdgeInsets.all(small_100),
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const SizedBox(width: huge_100 + small_100),
                Text('Total:', style: Theme.of(context).textTheme.bodyText2),
                const Spacer(),
                Text(' € ${order.totalPrice}',
                    style: Theme.of(context).textTheme.headline3)
              ])),
          if (order.orderStatus != OrderStatus.cancelled)
            Padding(
                padding: const EdgeInsets.all(normal_100),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (order.orderStatus == OrderStatus.pending) ...[
                        Expanded(
                            child: TertiaryButton(
                                onPressed: secondaryAction, title: "Cancel.")),
                        Expanded(
                            child: TertiaryButton(
                                onPressed: action, title: "Approve.")),
                      ],
                      if (order.orderStatus == OrderStatus.succeeded)
                        Expanded(
                            child: TertiaryButton(
                                onPressed: action, title: "Confirm Delivery.")),
                      if (order.orderStatus == OrderStatus.delivered)
                        Expanded(
                            child: TertiaryButton(
                                onPressed: action, title: "Get Bill."))
                    ]))
        ]));
  }
}
