import 'package:flutter/material.dart';
import 'package:proximity/l10n/app_localizations.dart';
import 'package:proximity/proximity.dart';
import 'package:pay/pay.dart';
import 'package:proximity_client/domain/cart_repository/cart_repository.dart';
import 'package:proximity_client/domain/order_repository/order_repository.dart';
import 'package:provider/provider.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen(
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
        label: AppLocalizations.of(context)!.total,
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
        SectionDivider(
            leadIcon: ProximityIcons.user,
            title: AppLocalizations.of(context)!.contactInformation,
            color: blueSwatch.shade500),
        EditText(
          hintText: AppLocalizations.of(context)!.namePerson,
          onChanged: orderSliderValidation.changename,
        ),
        SizedBox(height: 16),
        EditText(
          hintText: AppLocalizations.of(context)!.phoneNumber,
          onChanged: orderSliderValidation.changephone,
        ),
        SizedBox(height: 16),
        EditText(
          hintText: AppLocalizations.of(context)!.cityHint,
          onChanged: orderSliderValidation.changecity,
        ),
        SizedBox(height: 16),
        EditText(
          hintText: AppLocalizations.of(context)!.streetAddressLine1Hint,
          onChanged: orderSliderValidation.changestreet,
        ),
        SizedBox(height: 16),
        EditText(
          hintText: AppLocalizations.of(context)!.streetAddressLine2Hint,
          onChanged: orderSliderValidation.changestreet2,
        ),
        SizedBox(height: 16),
        EditText(
          hintText: AppLocalizations.of(context)!.postalCodeHint,
          onChanged: orderSliderValidation.changepostalCode,
        ),
        SizedBox(height: 16),
        ElevatedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.finishYourOrder,
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
            if (orderSliderValidation.name!.isNotEmpty &&
                orderSliderValidation.phone!.isNotEmpty &&
                orderSliderValidation.city!.isNotEmpty &&
                orderSliderValidation.street!.isNotEmpty &&
                orderSliderValidation.postalCode!.isNotEmpty) {
              //pay order
              var payed = await orderService.payOrder(
                  context, orderSliderValidation.toFormData());
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
