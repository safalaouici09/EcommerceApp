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
                            SizedBox(
                                height: large_150,
                                width: large_150,
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
                                                  child: (order
                                                              .userProfilePic! !=
                                                          null)
                                                      ? Image.network(
                                                          order.userProfilePic!)
                                                      : Image.network(
                                                          "https://cdn-icons-png.flaticon.com/512/5853/5853761.png")))),
                                    ])),
                            // SmallIconButton(
                            //     onPressed: () {},
                            //     icon: Icon(ProximityIcons.user,
                            //         color: Theme.of(context).primaryColor)),
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
              'NIN': (order.pickupPerson != null &&
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
          ///
          ...List.generate(order.items!.length,
              (index) => OrderItemTile(orderItem: order.items![index])),
          const Divider(height: tiny_50, thickness: tiny_50),
          if (order.delivery == true)
            Padding(
                padding: const EdgeInsets.all(small_100),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delivery:',
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.bodyText2),
                      const Spacer(),
                      Text(
                          ' € ${(order.paymentInfo!.deliveryAmount ?? 0.0).toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(fontSize: 16))
                    ])),

          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, top: 10),
                padding: const EdgeInsets.all(10),
                decoration:
                    BoxDecoration(color: Theme.of(context).dividerColor),
                child: Padding(
                    padding: const EdgeInsets.all(small_100),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(tinyRadius),
                                color: Color(0xFF104D72)),
                            child: InkWell(
                                onTap: () => {
                                      PaymentDialogs.showInfos(
                                          context, order.paymentInfo!.card!)
                                    },
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.network(
                                          'https://i.ibb.co/zmn2F5b/Vector-Visa-Credit-Card.png',
                                          width: 20.0,
                                          height: 20.0),
                                      SizedBox(width: 12.0),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '***${order.paymentInfo!.card!.cardNumber!.substring(order.paymentInfo!.card!.cardNumber!.length - 4, order.paymentInfo!.card!.cardNumber!.length)}',
                                              style: TextStyle(
                                                  fontSize: 7.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFEFEFEF)),
                                            ),
                                            Text(
                                              '${order.paymentInfo!.card!.expdate}',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 5.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFEFEFEF)),
                                            ),
                                          ])
                                    ])),
                          ),
                          const Spacer(),
                          Text(
                              ' € ${(order.totalPrice ?? 0.0).toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(color: Colors.black, fontSize: 17))
                        ])),
              ),
            ),
          ]),
          if (order.orderStatus != OrderStatus.cancelled)
            Padding(
                padding: const EdgeInsets.all(normal_100).copyWith(top: 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (order.orderStatus == OrderStatus.pending) ...[
                        Expanded(
                            child: TertiaryButton(
                                onPressed: () => {
                                      PaymentDialogs.cancelOrder(
                                          context, order.id)
                                    },
                                title: "Cancel.")),
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
