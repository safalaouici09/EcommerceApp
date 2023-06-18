import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/notification_repository/notification_repository.dart';
import 'package:proximity_client/domain/order_repository/order_repository.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({Key? key, required this.notification})
      : super(key: key);

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    /// get Locale
    final Locale _locale = Localizations.localeOf(context);
    final notificationService = Provider.of<NotificationService>(context);
    return InkWell(
      onTap: () async {
        if (notification!.type == 'order') {
          await notificationService.getOrder(notification.id ?? "", context,
              refundOrder: notification!.sub_type == "Refund",
              returnOrder: notification!.sub_type == "Return");
        }
      },
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: normal_100)
              .copyWith(bottom: 50),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(normalRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // shadow color
                  spreadRadius: 2, // spread radius
                  blurRadius: 7, // blur radius
                  offset: Offset(0, 3), // changes position of shadow
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(1), // shadow color
                  spreadRadius: 0, // spread radius
                  blurRadius: 0, // blur radius
                  offset: Offset(0, 0), // changes position of shadow
                )
              ],
              color: Colors.white24),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Material(
                color: Colors.transparent,
                child: InkWell(
                    // onTap: () =>
                    //     cartService.checkAllOrderedProducts(cart.storeId!),
                    child: Container(
                  decoration: BoxDecoration(
                    color: Colors.cyan[200],
                    borderRadius: const BorderRadius.only(
                        topLeft: normalRadius, topRight: normalRadius),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(small_100),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // SmallIconButton(
                            //     onPressed: () {},
                            //     icon: Icon(ProximityIcons.user,
                            //         color: Theme.of(context).primaryColor)),
                            Expanded(
                                child: Text('${notification.title}',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .copyWith(fontSize: 12))),
                          ])),
                ))),
            Padding(
                padding: EdgeInsets.all(10),
                child: Text('${notification.content}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(fontSize: 12))),
          ])),
    );
  }
}
