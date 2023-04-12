import 'dart:io';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';

import "package:proximity/widgets/widgets.dart";

import 'package:proximity/icons/proximity_icons.dart';
import 'package:proximity_commercant/domain/product_repository/models/offer_model.dart';

class OfferItem extends StatelessWidget {
  const OfferItem({Key? key, this.offer}) : super(key: key);
  final Offer? offer;
  @override
  Widget build(BuildContext context) {
    final f = new DateFormat('yyyy-MM-dd');

    return !offer!.offerDeleted!
        ? Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(smallRadius),
                color: Color.fromARGB(255, 243, 243, 243)),
            margin: const EdgeInsets.symmetric(vertical: small_100),
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 16.0),
                      Text(
                        ' Offer : ${offer!.id}',
                        style: TextStyle(
                            fontSize: 13.0,
                            color: Color.fromARGB(255, 90, 89, 89)),
                      ),
                      SizedBox(height: 16.0),
                      Column(children: [
                        Divider(),
                        SizedBox(height: 16.0),
                        Padding(
                          padding: EdgeInsets.only(
                              left: large_100,
                              right: large_100,
                              bottom: small_100),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text("Discount",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          color: Color(0xFF136DA5))),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                      offer!.offerDiscount.toString() + '%',
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 10.0,
                                          color: Color(0xFF136DA5))),
                                ),
                              ]),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: large_100,
                              right: large_100,
                              bottom: small_100),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text("Expiration date ",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          color: Color(0xFF136DA5))),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                      '${f.format(offer!.offerExpiration!)}',
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          color: Color(0xFF136DA5))),
                                ),
                              ]),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: large_100,
                              right: large_100,
                              bottom: small_100),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text("Stock",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          color: Color(0xFF136DA5))),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(offer!.offerStock.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          color: Color(0xFF136DA5))),
                                ),
                              ]),
                        ),
                      ]),
                      Divider(),
                      Row(
                        children: [
                          Spacer(),
                          Container(
                            width: large_200,
                            padding: const EdgeInsets.symmetric(
                                horizontal: small_50, vertical: tiny_50),
                            decoration: BoxDecoration(
                                color: greenSwatch.shade300,
                                borderRadius:
                                    const BorderRadius.all(normalRadius),
                                border:
                                    Border.all(color: greenSwatch.shade200)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Active",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(color: greenSwatch.shade900)),
                              ],
                            ),
                          ),
                        ],
                      )
                    ])))
        : Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(smallRadius),
                color: Color.fromARGB(255, 193, 193, 193)),
            margin: const EdgeInsets.symmetric(vertical: small_100),
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 16.0),
                      Text(
                        ' Offer ID : ${offer!.id}',
                        style: TextStyle(
                            fontSize: 13.0,
                            color: Color.fromARGB(255, 90, 89, 89)),
                      ),
                      SizedBox(height: 16.0),
                      Column(children: [
                        Divider(),
                        SizedBox(height: 16.0),
                        Padding(
                          padding: EdgeInsets.only(
                              left: large_100,
                              right: large_100,
                              bottom: small_100),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text("Discount",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          color: Color(0xFF136DA5))),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                      offer!.offerDiscount.toString() + '%',
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 10.0,
                                          color: Color(0xFF136DA5))),
                                ),
                              ]),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: large_100,
                              right: large_100,
                              bottom: small_100),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text("Expiration date ",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          color: Color(0xFF136DA5))),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                      '${f.format(offer!.offerExpiration!)}',
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          color: Color(0xFF136DA5))),
                                ),
                              ]),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: large_100,
                              right: large_100,
                              bottom: small_100),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text("Stock",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          color: Color(0xFF136DA5))),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(offer!.offerStock.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          color: Color(0xFF136DA5))),
                                ),
                              ]),
                        ),
                      ]),
                      Divider(),
                      Row(
                        children: [
                          Spacer(),
                          Container(
                            width: large_200,
                            padding: const EdgeInsets.symmetric(
                                horizontal: small_50, vertical: tiny_50),
                            decoration: BoxDecoration(
                                color: redSwatch.shade300,
                                borderRadius:
                                    const BorderRadius.all(normalRadius),
                                border: Border.all(color: redSwatch.shade500)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('archived',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(color: greenSwatch.shade900)),
                              ],
                            ),
                          ),
                        ],
                      )
                    ])));
  }
}

class $ {}
