import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
import 'package:pay/pay.dart';
import 'package:proximity_client/domain/cart_repository/cart_repository.dart';
import 'package:proximity_client/domain/order_repository/order_repository.dart';
import 'package:provider/provider.dart';

class PaymentMethodScreenCard extends StatelessWidget {
  const PaymentMethodScreenCard(
      {Key? key,
      required this.orderSliderValidation,
      required this.orderService,
      this.onPay})
      : super(key: key);

  final OrderSliderValidation orderSliderValidation;
  final OrderService orderService;
  final ValueChanged<int>? onPay;
  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);

    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: Color(0xFF1E1E1E),
      primary: Color(0xFF000000),
      minimumSize: Size(double.infinity, 50),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
    );

    double productReservationTotal =
        orderSliderValidation.getReservationItemsTotal();
    double productDeliveryTotal = orderSliderValidation.getDeliveryItemsTotal();
    double productPickupTotal = orderSliderValidation.getPickupItemsTotal();

    double total =
        productReservationTotal + productDeliveryTotal + productPickupTotal;
    final _paymentItems = [
      PaymentItem(
        label: 'Total',
        amount: '$total',
        status: PaymentItemStatus.final_price,
      )
    ];
    const String defaultGooglePay = '''{
      "provider": "google_pay",
      "data": {
        "environment": "TEST",
        "apiVersion": 2,
        "apiVersionMinor": 0,
        "allowedPaymentMethods": [
          {
            "type": "CARD",
            "tokenizationSpecification": {
              "type": "PAYMENT_GATEWAY",
              "parameters": {
                "gateway": "example",
                "gatewayMerchantId": "gatewayMerchantId"
              }
            },
            "parameters": {
              "allowedCardNetworks": ["VISA", "MASTERCARD"],
              "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
              "billingAddressRequired": true,
              "billingAddressParameters": {
                "format": "FULL",
                "phoneNumberRequired": true
              }
            }
          }
        ],
        "merchantInfo": {
          "merchantId": "01234567890123456789",
          "merchantName": "Store Name"
        },
        "transactionInfo": {
          "countryCode": "FR",
          "currencyCode": "EUR"
        }
      }
    }''';

    void onGooglePayResult(paymentResult) {
      // Send the resulting Google Pay token to your server / PSP
      print(paymentResult);
    }

    var _controller =
        new TextEditingController(text: orderSliderValidation.expdate);
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Material(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.circular(4.0),
        //   child: InkWell(
        //     onTap: () => {
        //                 onPay!.call(
        //                   3
        //                 )},
        //     child: Container(
        //       height: 48.0,
        //       padding: EdgeInsets.symmetric(horizontal: 16.0),
        //       child: Row(
        //         children: [
        //           Image.asset(
        //           'assets/google-pay.png' ,
        //           width: 24.0,
        //           height: 24.0),
        //           SizedBox(width: 16.0),
        //           Expanded(
        //             child: Text(
        //               'Pay with Google',
        //               style: TextStyle(
        //                 color: Colors.black87,
        //                 fontSize: 16.0,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        // SizedBox(height: 20),
        // Material(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.circular(4.0),
        //   child: InkWell(
        //     onTap: () => {
        //                 onPay!.call(
        //                   3
        //                 )},
        //     child: Container(
        //       height: 48.0,
        //       padding: EdgeInsets.symmetric(horizontal: 16.0),
        //       child: Row(
        //         children: [
        //           Image.asset(
        //           'assets/apple-pay.png' ,
        //           width: 24.0,
        //           height: 24.0),
        //           SizedBox(width: 16.0),
        //           Expanded(
        //             child: Text(
        //               'Pay with Apple',
        //               style: TextStyle(
        //                 color: Colors.black87,
        //                 fontSize: 16.0,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        // SizedBox(height: 20),
        SizedBox(height: 20),
        GooglePayButton(
            paymentConfiguration:
                PaymentConfiguration.fromJsonString(defaultGooglePay),
            paymentItems: _paymentItems,
            type: GooglePayButtonType.pay,
            margin: const EdgeInsets.only(top: 15.0),
            onPaymentResult: onGooglePayResult,
            loadingIndicator: const Center(
              child: CircularProgressIndicator(),
            ),
            width: double.infinity),

        SectionDivider(
            leadIcon: ProximityIcons.credit_card,
            title: 'Or Pay with Card.',
            color: blueSwatch.shade500),
        SizedBox(height: 16),
        EditText(
          hintText: "Card Number",
          keyboardType: TextInputType.number,
          onChanged: orderSliderValidation.changecardNumber,
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: normal_100),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _controller, //<-- Add controller here
                          onChanged: (value) {
                            orderSliderValidation.changeexpdate(value);
                          },
                          keyboardType: TextInputType.number,
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).dividerColor),
                                borderRadius:
                                    const BorderRadius.all(smallRadius),
                              ),
                              focusedBorder:
                                  OutlineInputBorder(borderSide: BorderSide(
                                color: (() {
                                  return Theme.of(context).primaryColor;
                                })(),
                              )),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      const BorderRadius.all(normalRadius)),
                              label: Text(
                                "Expiry MM/YY",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: (() {
                                          return Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .color;
                                        })()),
                              ),
                              contentPadding: null),
                        ),
                      ]),
                  // EditText(
                  //   hintText : "Expiry MM/YY",
                  //   keyboardType: TextInputType.number,
                  //   onChanged:
                  //       orderSliderValidation.changeexpdate,
                  // ),
                )),
            Expanded(
              flex: 1,
              child: EditText(
                hintText: "CVC",
                keyboardType: TextInputType.number,
                onChanged: orderSliderValidation.changecvc,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),

        SectionDivider(
            leadIcon: ProximityIcons.address,
            title: 'Billing Address.',
            color: blueSwatch.shade500),

        EditText(
          hintText: "Name",
          onChanged: orderSliderValidation.changename,
        ),
        SizedBox(height: 16),

        EditText(
          hintText: "Phone",
          onChanged: orderSliderValidation.changephone,
        ),
        SizedBox(height: 16),

        EditText(
          hintText: "city",
          onChanged: orderSliderValidation.changecity,
        ),
        SizedBox(height: 16),

        EditText(
          hintText: "street",
          onChanged: orderSliderValidation.changestreet,
        ),
        SizedBox(height: 16),

        EditText(
          hintText: "street2",
          onChanged: orderSliderValidation.changestreet2,
        ),
        SizedBox(height: 16),

        EditText(
          hintText: "Postal code",
          onChanged: orderSliderValidation.changepostalCode,
        ),
        SizedBox(height: 16),

        ElevatedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                  'https://i.ibb.co/zmn2F5b/Vector-Visa-Credit-Card.png',
                  width: 24.0,
                  height: 24.0),
              SizedBox(width: 16.0),
              Text(
                'Pay with Card',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          style: raisedButtonStyle,
          onPressed: () async {
            if (orderSliderValidation.cardNumber!.isNotEmpty &&
                orderSliderValidation.expdate!.isNotEmpty &&
                orderSliderValidation.expdate!.length == 5 &&
                orderSliderValidation.cvc!.isNotEmpty &&
                orderSliderValidation.cvc!.length == 3 &&
                orderSliderValidation.name!.isNotEmpty &&
                orderSliderValidation.phone!.isNotEmpty &&
                orderSliderValidation.city!.isNotEmpty &&
                orderSliderValidation.street!.isNotEmpty &&
                orderSliderValidation.postalCode!.isNotEmpty) {
              //pay order
              var payed = await orderService.payOrder(
                  context, orderSliderValidation.toFormDataCard());
              if (payed == true) {
                // delete cart
                print({"StoreId": orderSliderValidation.storeId});
                cartService
                    .deleteOrderFromCart(orderSliderValidation.storeId ?? "");
                //passage to done slide
                onPay!.call(3);
              }
            }
            ;
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
