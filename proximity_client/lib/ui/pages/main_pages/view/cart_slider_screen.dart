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
import 'package:proximity_client/ui/pages/product_pages/widgets/widgets.dart';
import 'package:proximity_client/ui/pages/order_pages/widgets/widgets.dart';

class CartSliderScreen extends StatefulWidget {
  CartSliderScreen({Key? key}) : super(key: key);
  @override
  State<CartSliderScreen> createState() => _CartSliderScreenState();
}

class _CartSliderScreenState extends State<CartSliderScreen> {
  @override
  int _currentStep = 0;
  bool isLastStep = false;

  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrderSliderValidation>(
        // create: (context) => orderSliderValidation.setStore(store),
        create: (context) => OrderSliderValidation(),
        child: Consumer2<OrderSliderValidation, OrderService>(
            builder: (context, orderSliderValidation, orderService, child) {
          return Scaffold(
              appBar: AppBar(
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: TopBar( title: "Order Validation"),
                ),
                backgroundColor: Colors.white,
                elevation: 0.0,
              ),
              body: SafeArea(
                child: Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: large_200),
                      child:
                          Stepper(
                            physics: ClampingScrollPhysics(),
                            elevation: 0.0,
                            currentStep: _currentStep,
                            type: StepperType.horizontal,
                            onStepContinue: () {
                              _currentStep == 2
                                  ? null
                                  : setState(() {
                                      _currentStep = _currentStep + 1;
                                    });
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
                                  mainAxisAlignment: _currentStep != 0 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end ,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (_currentStep != 0)
                                      SecondaryButton(
                                          onPressed: details.onStepCancel,
                                          title: "Back"),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        PrimaryButton(
                                          buttonState:   ButtonState.enabled,
                                          onPressed: details.onStepContinue,
                                          title:
                                              _currentStep == 2 ? "confirm" : "Next.",
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
                              getPaymentStep(orderSliderValidation, context),
                              getDoneStep(orderSliderValidation, context),
                            ],
                          )),
                ),
              ));
        }));
  }

  Step getOrderItemsStep(
      OrderSliderValidation orderSliderValidation, BuildContext context) {
    return Step(
        isActive: _currentStep >= 0,
        title: Text("Items"),
        content: 
        Column(
          children: [
            SectionDivider(
                leadIcon: Icons.local_shipping_outlined,
                title: 'Order Items.',
                color: redSwatch.shade500),
                
            Column(children:[
                  for(var item in orderSliderValidation.products ) CardItem(product : item , orderSliderValidation : orderSliderValidation )  , 
                  
            ]),
                
          ],
        ));
  }

  Step getBillsStep(
      OrderSliderValidation orderSliderValidation, BuildContext context) {
        
    double  productReservationTotal = orderSliderValidation.getReservationItemsTotal() ;
    double  productDeliveryTotal = orderSliderValidation.getDeliveryItemsTotal() ;
    double  productPickupTotal = orderSliderValidation.getPickupItemsTotal() ;
    return Step(
        isActive: _currentStep >= 0,
        title: Text("Bills"),
        content: Column(
          children: [
                Column(children:[
                  if(productReservationTotal != 0.0 ) 
                    BillItem(orderSliderValidation : orderSliderValidation , reservationBill : true , deliveryBill: false , pickupBill : false) ,
                  if(productDeliveryTotal != 0.0) 
                    BillItem(orderSliderValidation : orderSliderValidation , reservationBill : false , deliveryBill: true , pickupBill : false) ,
                  if(productPickupTotal != 0.0) 
                    BillItem(orderSliderValidation : orderSliderValidation , reservationBill : false , deliveryBill: false , pickupBill : true) ,
                  BillItem(orderSliderValidation : orderSliderValidation , reservationBill : false , deliveryBill: false , pickupBill : false) ,
                ]),
                
          ],
        ));
  }

  Step getPaymentStep(
      OrderSliderValidation orderSliderValidation, BuildContext context) {
    return Step(
        isActive: _currentStep >= 0,
        title: Text("Payment"),
        content: Column(
          children: [
            SectionDivider(
                leadIcon: Icons.local_shipping_outlined,
                title: 'Payment',
                color: redSwatch.shade500),
            const InfoMessage(
                message:
                    ''),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: small_100),
                child: Row(children:[

                ])),
                
          ],
        ));
  }

   Step getDoneStep(
      OrderSliderValidation orderSliderValidation, BuildContext context) {
    return Step(
        isActive: _currentStep >= 0,
        title: Text("Done"),
        content: Column(
          children: [
            SectionDivider(
                leadIcon: Icons.local_shipping_outlined,
                title: 'Done',
                color: redSwatch.shade500),
            const InfoMessage(
                message:
                    ''),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: small_100),
                child: Row(children:[

                ])),
                
          ],
        ));
  }

}
