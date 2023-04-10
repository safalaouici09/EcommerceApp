import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity/widgets/forms/edit_text_spacer.dart';
import 'package:proximity_client/domain/order_repository/order_repository.dart';
import 'package:proximity_client/domain/product_repository/models/models.dart';
import 'package:proximity_client/ui/pages/product_pages/widgets/widgets.dart';
import 'package:proximity_client/ui/pages/order_pages/order_pages.dart';
import 'package:proximity_client/ui/widgets/address_picker/area_selection_screen.dart';

class CartSliderScreen extends StatefulWidget {
  CartSliderScreen(
      {Key? key,
      required this.products,
      this.cartId,
      this.storeId,
      this.storeAddress,
      this.maxDeliveryFixe,
      this.maxDeliveryKm})
      : super(key: key);
  List<ProductCart> products;
  String? cartId;
  String? storeId;
  Address? storeAddress;
  double? maxDeliveryFixe;
  double? maxDeliveryKm;

  @override
  State<CartSliderScreen> createState() => _CartSliderScreenState();
}

class _CartSliderScreenState extends State<CartSliderScreen> {
  @override
  int _currentStep = 0;
  bool isLastStep = false;

  void onPay(int value) {
    setState(() {
      _currentStep = value;
    });
  }

  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrderSliderValidation>(
        // create: (context) => orderSliderValidation.setStore(store),
        create: (context) => OrderSliderValidation.initProducts(
            widget.products,
            widget.cartId,
            widget.storeId,
            widget.storeAddress,
            widget.maxDeliveryFixe,
            widget.maxDeliveryKm),
        child: Consumer2<OrderSliderValidation, OrderService>(
            builder: (context, orderSliderValidation, orderService, child) {
          return Scaffold(
              appBar: AppBar(
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: TopBar(title: "Order Validation"),
                ),
                backgroundColor: Colors.white,
                elevation: 0.0,
              ),
              body: SafeArea(
                child: Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Stepper(
                        physics: ClampingScrollPhysics(),
                        elevation: 0.0,
                        currentStep: _currentStep,
                        type: StepperType.horizontal,
                        onStepContinue: () {
                          if (_currentStep == 0) {
                            bool pickup =
                                orderSliderValidation.getPickupItemsTotal() !=
                                    0.0;
                            bool delivery = orderSliderValidation
                                .getDeliveryItems()
                                .isNotEmpty;

                            bool pickupValidation =
                                orderSliderValidation.pickupName != null &&
                                    orderSliderValidation.pickupName != "" &&
                                    orderSliderValidation.pickupNif != null &&
                                    orderSliderValidation.pickupNif != "";
                            bool deliveryValidation =
                                orderSliderValidation.deliveryAdresse != null;

                            if (!((pickup && !pickupValidation) ||
                                (delivery && !deliveryValidation))) {
                              setState(() {
                                _currentStep = _currentStep + 1;
                              });
                            }
                          } else {
                            _currentStep == 2
                                ? null
                                : _currentStep == 3
                                    ? Navigator.pop(context)
                                    : setState(() {
                                        _currentStep = _currentStep + 1;
                                      });
                          }
                        },
                        onStepCancel: () {
                          _currentStep == 0
                              ? null
                              : setState(() {
                                  _currentStep -= 1;
                                  print(_currentStep);
                                });
                        },
                        controlsBuilder: (context, details) {
                          return Padding(
                            padding: const EdgeInsets.all(small_100),
                            child: Row(
                              mainAxisAlignment:
                                  _currentStep != 0 && _currentStep != 3
                                      ? MainAxisAlignment.spaceBetween
                                      : _currentStep == 3
                                          ? MainAxisAlignment.center
                                          : MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (_currentStep != 0 && _currentStep < 3)
                                  SecondaryButton(
                                      onPressed: details.onStepCancel,
                                      title: "Back"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (_currentStep != 2)
                                      PrimaryButton(
                                        buttonState: ButtonState.enabled,
                                        onPressed: details.onStepContinue,
                                        title: _currentStep == 3
                                            ? "Done"
                                            : "Next.",
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        steps: [
                          getOrderItemsStep(orderSliderValidation, context),
                          getBillsStep(orderSliderValidation, context),
                          getPaymentStep(
                              orderSliderValidation, orderService, context),
                          getDoneStep(orderSliderValidation, context),
                        ],
                      )),
                ),
              ));
        }));
  }

  Step getOrderItemsStep(
      OrderSliderValidation orderSliderValidation, BuildContext context) {
    print(orderSliderValidation.products);
    double productPickupTotal = orderSliderValidation.getPickupItemsTotal();
    int deliveryProducts = orderSliderValidation.getDeliveryItems().length;
    return Step(
        isActive: _currentStep >= 0,
        title: Text("Items"),
        content: Column(
          children: [
            Column(children: [
              for (var item in orderSliderValidation.products)
                CardItem(
                    product: item,
                    orderSliderValidation: orderSliderValidation),
              if (deliveryProducts > 0)
                ShippingAddressOrderScreen(
                    orderSliderValidation: orderSliderValidation),
              if (productPickupTotal != 0.0)
                PickupPersonScreen(
                    orderSliderValidation: orderSliderValidation),
            ]),
          ],
        ));
  }

  Step getBillsStep(
      OrderSliderValidation orderSliderValidation, BuildContext context) {
    double productReservationTotal =
        orderSliderValidation.getReservationItemsTotal();
    bool productDeliveryTotal =
        orderSliderValidation.getDeliveryItems().isNotEmpty;
    double productPickupTotal = orderSliderValidation.getPickupItemsTotal();
    return Step(
        isActive: _currentStep >= 1,
        title: Text("Bills"),
        content: Column(
          children: [
            Column(children: [
              if (productReservationTotal != 0.0)
                BillItem(
                    orderSliderValidation: orderSliderValidation,
                    reservationBill: true,
                    deliveryBill: false,
                    pickupBill: false,
                    payment: false),
              if (productDeliveryTotal)
                BillItem(
                    orderSliderValidation: orderSliderValidation,
                    reservationBill: false,
                    deliveryBill: true,
                    pickupBill: false,
                    payment: false),
              if (productPickupTotal != 0.0)
                BillItem(
                    orderSliderValidation: orderSliderValidation,
                    reservationBill: false,
                    deliveryBill: false,
                    pickupBill: true,
                    payment: false),
              BillItem(
                  orderSliderValidation: orderSliderValidation,
                  reservationBill: false,
                  deliveryBill: false,
                  pickupBill: false,
                  payment: false),
            ]),
          ],
        ));
  }

  Step getPaymentStep(OrderSliderValidation orderSliderValidation,
      OrderService orderService, BuildContext context) {
    return Step(
        isActive: _currentStep >= 2,
        title: Text("Payment"),
        content: Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: small_100),
                child: PaymentMethodScreen(
                    orderSliderValidation: orderSliderValidation,
                    orderService: orderService,
                    onPay: onPay)),
          ],
        ));
  }

  Step getDoneStep(
      OrderSliderValidation orderSliderValidation, BuildContext context) {
    return Step(
        isActive: _currentStep >= 3,
        title: Text("Done"),
        content: Column(
          children: [
            Column(children: [
              BillItem(
                  orderSliderValidation: orderSliderValidation,
                  reservationBill: false,
                  deliveryBill: false,
                  pickupBill: false,
                  payment: true),
              Icon(ProximityIcons.check_filled,
                  size: huge_200, color: Colors.green),

              // FittedBox(
              //   child: Image.asset("assets/img/welcome.png"),
              //   fit: BoxFit.fill,
              // ),
            ]),
            const InfoMessage(
                message:
                    'Your order has been made successfully, we will inform you once it will be validated'),
            SizedBox(height: 40),
          ],
        ));
  }
}
