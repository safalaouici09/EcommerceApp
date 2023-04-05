import 'dart:io';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/product_repository/product_repository.dart';
import 'package:proximity_client/domain/store_repository/store_repository.dart';
import 'package:proximity_client/ui/pages/order_pages/order_pages.dart';
import 'package:proximity_client/ui/pages/product_pages/product_pages.dart';
import 'package:proximity_client/domain/cart_repository/cart_repository.dart';
import "package:proximity/widgets/widgets.dart";
import 'package:proximity_client/domain/order_repository/order_repository.dart';
import 'package:proximity/icons/proximity_icons.dart';

class BillItem extends StatelessWidget {
  const BillItem(
      {Key? key,
      required this.orderSliderValidation,
      this.reservationBill = false,
      this.deliveryBill = false,
      this.pickupBill = false,
      this.payment = false})
      : super(key: key);

  final OrderSliderValidation orderSliderValidation;
  final bool reservationBill;
  final bool deliveryBill;
  final bool pickupBill;
  final bool payment;

  @override
  Widget build(BuildContext context) {
    /// A [productProxy] is declared to update its value [idShop] whenever
    /// a new shop is selected
    final storeProxy = Provider.of<StoreProxy>(context);

    List<ProductCart> productReservation =
        orderSliderValidation.getReservationItems();
    List<ProductCart> productDelivery =
        orderSliderValidation.getDeliveryItems();
    List<ProductCart> productPickup = orderSliderValidation.getPickupItems();
    double productReservationTotal =
        orderSliderValidation.getReservationItemsTotal();
    double productDeliveryTotal = orderSliderValidation.getDeliveryItemsTotal();
    double productPickupTotal = orderSliderValidation.getPickupItemsTotal();
    String cardNumber = orderSliderValidation.cardNumber ?? "";
    if (cardNumber.length >= 4)
      cardNumber =
          cardNumber.substring(cardNumber.length - 4, cardNumber.length);
    String expdate = orderSliderValidation.expdate ?? "";

    final f = new DateFormat('yyyy-MM-dd hh:mm');

    return Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(smallRadius),
            color: !(reservationBill || deliveryBill || pickupBill)
                ? Color(0xFF136DA5)
                : Color(0xFFEFEFEF)),
        margin: const EdgeInsets.symmetric(vertical: small_100),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                reservationBill
                    ? 'Reservation Bill'
                    : deliveryBill
                        ? 'Delivery Bill'
                        : pickupBill
                            ? 'Pickup Bill'
                            : payment
                                ? 'Payment'
                                : 'Total Bill',
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: !(reservationBill || deliveryBill || pickupBill)
                        ? Color(0xFFEFEFEF)
                        : Color(0xFF136DA5)),
              ),
              Text(
                'Date : ${f.format(new DateTime.now())}',
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontSize: 11.0,
                    color: !(reservationBill || deliveryBill || pickupBill)
                        ? Color(0xFFEFEFEF)
                        : Color(0xFF000000)),
              ),
              if (deliveryBill || pickupBill) SizedBox(height: 16.0),
              if (deliveryBill || pickupBill)
                Text(
                  deliveryBill ? 'Shipping Address' : 'Pickup By',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 13.0,
                      color: !(reservationBill || deliveryBill || pickupBill)
                          ? Color(0xFFEFEFEF)
                          : Color(0xFF000000)),
                ),
              if (deliveryBill && orderSliderValidation.deliveryAdresse != null)
                Padding(
                  padding: const EdgeInsets.all(normal_100).copyWith(top: 0),
                  child: OrderDetails(details: {
                    'City': orderSliderValidation.deliveryAdresse!.city ?? "",
                    'Region':
                        orderSliderValidation.deliveryAdresse!.region ?? "",
                    'Full Address':
                        orderSliderValidation.deliveryAdresse!.fullAddress ??
                            "",
                  }),
                ),
              if (pickupBill && orderSliderValidation.pickupName != null)
                Padding(
                  padding: const EdgeInsets.all(normal_100).copyWith(top: 0),
                  child: OrderDetails(details: {
                    'Name': orderSliderValidation.pickupName ?? "",
                    'NIF': orderSliderValidation.pickupNif ?? "",
                  }),
                ),
              SizedBox(height: 16.0),
              if (payment)
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(tinyRadius),
                      color: Color(0xFF104D72)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.network(
                            'https://i.ibb.co/zmn2F5b/Vector-Visa-Credit-Card.png',
                            width: 50.0,
                            height: 50.0),
                        Column(children: [
                          Text(
                            '**********$cardNumber',
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEFEFEF)),
                          ),
                          Text(
                            'Expiration date : ${expdate}',
                            style: TextStyle(
                                fontSize: 11.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEFEFEF)),
                          ),
                        ])
                      ]),
                ),
              if (!payment)
                Column(children: [
                  Divider(),
                  Text(
                    'Bill Details',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: !(reservationBill || deliveryBill || pickupBill)
                            ? Color(0xFFEFEFEF)
                            : Color(0xFF000000)),
                  ),
                  SizedBox(height: 16.0),
                  if (reservationBill || deliveryBill || pickupBill)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text('Product',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 10.0, color: Color(0xFF136DA5))),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text('Price',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 10.0, color: Color(0xFF136DA5))),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text('Qtt',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 10.0, color: Color(0xFF136DA5))),
                        ),
                        if (reservationBill)
                          Expanded(
                            flex: 2,
                            child: Text('Reservation',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 10.0, color: Color(0xFF136DA5))),
                          ),
                        Expanded(
                          flex: 1,
                          child: Text('discount',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 10.0, color: Color(0xFF136DA5))),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text('Total',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 10.0, color: Color(0xFF136DA5))),
                        ),
                      ],
                    ),
                  SizedBox(height: 8.0),
                  if (reservationBill || deliveryBill || pickupBill)
                    for (var item in (reservationBill
                        ? (productReservation ?? [])
                        : deliveryBill
                            ? (productDelivery ?? [])
                            : (productPickup ?? [])))
                      Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(item.name!,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 10.0,
                                          color: !(reservationBill ||
                                                  deliveryBill ||
                                                  pickupBill)
                                              ? Color(0xFFEFEFEF)
                                              : Color(0xFF000000))),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                      '€ ${double.parse((item.price!).toStringAsFixed(2))}',
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 10.0,
                                          color: !(reservationBill ||
                                                  deliveryBill ||
                                                  pickupBill)
                                              ? Color(0xFFEFEFEF)
                                              : Color(0xFF000000))),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text('${item.quantity}',
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 10.0,
                                          color: !(reservationBill ||
                                                  deliveryBill ||
                                                  pickupBill)
                                              ? Color(0xFFEFEFEF)
                                              : Color(0xFF000000))),
                                ),
                                if (reservationBill)
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                        '${(item.reservationP * 100).toInt()}%',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 10.0,
                                            color: !(reservationBill ||
                                                    deliveryBill ||
                                                    pickupBill)
                                                ? Color(0xFFEFEFEF)
                                                : Color(0xFF000000))),
                                  ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                      '${(item.discount * 100).toInt()}%',
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 10.0,
                                          color: !(reservationBill ||
                                                  deliveryBill ||
                                                  pickupBill)
                                              ? Color(0xFFEFEFEF)
                                              : Color(0xFF000000))),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                      '€ ${double.parse((item.price! * (item.quantity) * ((item.reservation ? (item.reservationP) : 1)) * (1 - item.discount)).toStringAsFixed(2))}',
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 10.0,
                                          color: !(reservationBill ||
                                                  deliveryBill ||
                                                  pickupBill)
                                              ? Color(0xFFEFEFEF)
                                              : Color(0xFF000000))),
                                ),
                              ])),
                  if (deliveryBill &&
                      orderSliderValidation.maxDeliveryFixe != null &&
                      orderSliderValidation.maxDeliveryFixe != 0.0)
                    Padding(
                      padding:
                          const EdgeInsets.all(normal_100).copyWith(top: 0),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Delivery Price Fixed at ",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(
                                        color: Color(0xFF136DA5),
                                        fontWeight: FontWeight.bold)),
                            const SizedBox(width: small_100),
                            Expanded(
                                child: Text(
                              ' € ${orderSliderValidation.totalDelivery.toString()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(
                                      color: Color(0xFF136DA5),
                                      fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )),
                          ]),
                    )
                  else if (deliveryBill &&
                      orderSliderValidation.distance != null &&
                      orderSliderValidation.distance != 0.0)
                    Padding(
                      padding: const EdgeInsets.all(normal_100)
                          .copyWith(top: 0, bottom: 0),
                      child: Column(children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Distance ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(
                                          color: Color(0xFF136DA5),
                                          fontWeight: FontWeight.bold)),
                              const SizedBox(width: small_100),
                              Expanded(
                                  child: Text(
                                '${(orderSliderValidation.distance ?? 1.0).toStringAsFixed(2)} Km ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(
                                        color: Color(0xFF136DA5),
                                        fontWeight: FontWeight.bold),
                                textAlign: TextAlign.end,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )),
                            ]),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Km Price ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(
                                          color: Color(0xFF136DA5),
                                          fontWeight: FontWeight.bold)),
                              const SizedBox(width: small_100),
                              Expanded(
                                  child: Text(
                                '${(orderSliderValidation.maxDeliveryKm ?? 1.0).toStringAsFixed(2)} Km ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(
                                        color: Color(0xFF136DA5),
                                        fontWeight: FontWeight.bold),
                                textAlign: TextAlign.end,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )),
                            ]),
                        SizedBox(height: 20),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Delivery Price ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(
                                          color: Color(0xFF136DA5),
                                          fontWeight: FontWeight.bold)),
                              const SizedBox(width: small_100),
                              Expanded(
                                  child: Text(
                                ' € ${(orderSliderValidation.totalDelivery ?? 0.0).toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(
                                        color: Color(0xFF136DA5),
                                        fontWeight: FontWeight.bold),
                                textAlign: TextAlign.end,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )),
                            ])
                      ]),
                    ),
                  if (!(reservationBill || deliveryBill || pickupBill) &&
                      productReservationTotal != 0.0)
                    Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text("Reservation",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        color: !(reservationBill ||
                                                deliveryBill ||
                                                pickupBill)
                                            ? Color(0xFFEFEFEF)
                                            : Color(0xFF000000))),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                    '€ ${productReservationTotal.toStringAsFixed(2)}',
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        color: !(reservationBill ||
                                                deliveryBill ||
                                                pickupBill)
                                            ? Color(0xFFEFEFEF)
                                            : Color(0xFF000000))),
                              ),
                            ])),
                  if (!(reservationBill || deliveryBill || pickupBill) &&
                      productDeliveryTotal != 0.0)
                    Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text("Delivery",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        color: !(reservationBill ||
                                                deliveryBill ||
                                                pickupBill)
                                            ? Color(0xFFEFEFEF)
                                            : Color(0xFF000000))),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                    '€ ${productDeliveryTotal.toStringAsFixed(2)}',
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        color: !(reservationBill ||
                                                deliveryBill ||
                                                pickupBill)
                                            ? Color(0xFFEFEFEF)
                                            : Color(0xFF000000))),
                              ),
                            ])),
                  if (!(reservationBill || deliveryBill || pickupBill) &&
                      productPickupTotal != 0.0)
                    Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text("Pickup",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        color: !(reservationBill ||
                                                deliveryBill ||
                                                pickupBill)
                                            ? Color(0xFFEFEFEF)
                                            : Color(0xFF000000))),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                    '€ ${productPickupTotal.toStringAsFixed(2)}',
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        color: !(reservationBill ||
                                                deliveryBill ||
                                                pickupBill)
                                            ? Color(0xFFEFEFEF)
                                            : Color(0xFF000000))),
                              ),
                            ])),
                  SizedBox(height: 16.0),
                  Divider(),
                ]),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total',
                      style: TextStyle(
                          fontSize: 20.0,
                          color:
                              !(reservationBill || deliveryBill || pickupBill)
                                  ? Color(0xFFEFEFEF)
                                  : Color(0xFF000000))),
                  Text(
                      reservationBill
                          ? '€ ${productReservationTotal.toStringAsFixed(2)}'
                          : deliveryBill
                              ? '€ ${productDeliveryTotal.toStringAsFixed(2)}'
                              : pickupBill
                                  ? '€ ${productPickupTotal.toStringAsFixed(2)}'
                                  : '€ ${(productReservationTotal + productDeliveryTotal + productPickupTotal).toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 20.0,
                          color:
                              !(reservationBill || deliveryBill || pickupBill)
                                  ? Color(0xFFEFEFEF)
                                  : Color(0xFF136DA5))),
                ],
              ),
            ],
          ),
        ));
  }
}
