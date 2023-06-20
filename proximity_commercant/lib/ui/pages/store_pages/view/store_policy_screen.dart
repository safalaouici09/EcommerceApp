import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity/widgets/forms/edit_text_spacer.dart';
import 'package:proximity_commercant/domain/store_repository/src/policy_creation_validation.dart';
import 'package:proximity_commercant/domain/store_repository/store_repository.dart';

class StorePolicyScreen extends StatefulWidget {
  StorePolicyScreen(
      {Key? key, this.global, this.store, this.product, this.policy})
      : super(key: key);
  bool? global;
  bool? store;
  bool? product;
  Policy? policy;
  @override
  State<StorePolicyScreen> createState() => _StorePolicyScreenState();
}

class _StorePolicyScreenState extends State<StorePolicyScreen> {
  @override
  int _currentStep = 0;
  bool isLastStep = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PolicyValidation>(
        create: (context) => PolicyValidation.setPolicy(widget.policy),
        // create: (context) => PolicyValidation(),
        child:
            Consumer3<PolicyValidation, StoreService, StoreCreationValidation>(
                builder: (context, policyCreationValidation, storeService,
                    storecreationValidation, child) {
          return Scaffold(
              appBar: AppBar(
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: TopBar(
                      title: widget.global!
                          ? 'Golbal Policy.'
                          : widget.store!
                              ? 'Store Policy.'
                              : 'Product Policy'),
                ),
                backgroundColor: Colors.white,
                elevation: 0.0,
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: Stepper(
                        physics: const ClampingScrollPhysics(),
                        elevation: 0.0,
                        currentStep: _currentStep,
                        type: StepperType.horizontal,
                        onStepContinue: () {
                          if (_currentStep == 2) {
                            if (widget.global!) {
                              policyCreationValidation.updatePolicy(context,
                                  policyCreationValidation.policytoFormData());
                              Navigator.pop(context);
                            } else {
                              setState(() {
                                Navigator.pop(context,
                                    policyCreationValidation.getPolicy());
                              });

                              /* StoreCreationValidation.setPolicy(
                                  policyCreationValidation.getPolicy());*/
                            }
                          } else {
                            setState(() {
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
                          return Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(normal_100),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (_currentStep != 0)
                                    SecondaryButton(
                                        onPressed: details.onStepCancel,
                                        title: "Back"),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      PrimaryButton(
                                        buttonState: (_currentStep == 0 &&
                                                    policyCreationValidation
                                                        .shippingIsValid) ||
                                                (_currentStep == 1 &&
                                                    policyCreationValidation
                                                        .returnIsValid) ||
                                                (_currentStep == 2 &&
                                                    policyCreationValidation
                                                        .ordersIsValid)
                                            ? ButtonState.enabled
                                            : ButtonState.disabled,
                                        onPressed: details.onStepContinue,
                                        title: _currentStep == 2
                                            ? "confirm"
                                            : "Next.",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        steps: [
                          getShippingStep(policyCreationValidation, context),
                          getReturnStep(policyCreationValidation, context),
                          getOrdersStep(policyCreationValidation, context),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        }));
  }

  Step getShippingStep(
      PolicyValidation policyCreationValidation, BuildContext context) {
    return Step(
        isActive: _currentStep >= 0,
        title: const Text("Shipping"),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SectionDivider(
                leadIcon: Icons.local_shipping_outlined,
                title: 'Shipping Policy.',
                color: redSwatch.shade500),
            const InfoMessage(
                message:
                    'Select the type of Deliveries your store support, and set a delivery tax value in case you deliver your orders.'),
            ListToggle(
                leadIcon: Icons.local_shipping_rounded,
                title: 'Delivery',
                value: policyCreationValidation.delivery!,
                onToggle: policyCreationValidation.toggleDelivery),
            SizedBox(height: small_100),
            ListToggle(
                leadIcon: ProximityIcons.self_pickup_duotone_1,
                title: 'Self Pickup',
                value: policyCreationValidation.selfPickup!,
                onToggle: policyCreationValidation.toggleSelfPickup),
            Row(children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: small_100),
                /* child: LargeIconButton(
                    onPressed: policyCreationValidation.toggleSelfPickup,
                    selected: (policyCreationValidation.selfPickup ?? false),
                    icon: DuotoneIcon(
                        primaryLayer: ProximityIcons.self_pickup_duotone_1,
                        secondaryLayer: ProximityIcons.self_pickup_duotone_2,
                        color: redSwatch.shade500),
                    title: 'Self Pickup)*/
              )),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: small_100),
                /* child: LargeIconButton(
                  onPressed: policyCreationValidation.toggleDelivery,
                    selected: (policyCreationValidation.delivery ?? false),
                    icon: DuotoneIcon(
                        primaryLayer: ProximityIcons.delivery_duotone_1,
                        secondaryLayer: ProximityIcons.delivery_duotone_2,
                        color: redSwatch.shade500),
                    title: 'Delivery'),*/
              ))
            ]),
            if (policyCreationValidation.selfPickup ??
                true && policyCreationValidation.delivery! ??
                false)
              Padding(
                padding: const EdgeInsets.all(normal_100).copyWith(right: 0),
                child: DropDownSelector<String>(
                  // labelText: 'Product Category.',
                  hintText: 'Max Days to Pick Up.',
                  onChanged: policyCreationValidation.changeSelfPickUpMaxDays,
                  borderType: BorderType.middle,
                  savedValue:
                      policyCreationValidation.selfPickUplMaxDays.toString(),
                  items: daysMap.entries
                      .map((item) => DropdownItem<String>(
                          value: item.key,
                          child: Text(item.value,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontWeight: FontWeight.w600))))
                      .toList(),
                ),
              ),

            /*
            if (policyCreationValidation.delivery ?? false) ...[
              const SizedBox(height: normal_100),
              Padding(
                padding: const EdgeInsets.all(normal_100).copyWith(top: 0),
                child: TertiaryButton(
                    onPressed: () async {
                      final Address _result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AreaSelectionScreen(
                                  currentAddress: policyCreationValidation
                                      .deliveryCenter)));
                      policyCreationValidation
                          .changeDeliveryCenterdress(_result);

                      //  policyCreationValidation
                      //  .changeAddress(_result);
                    },
                    title: 'Set Delivery Area.'),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: normal_100),
                  child: Row(children: [
                    Expanded(
                        child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: small_100),
                      child: LargeIconButton(
                          onPressed:
                              policyCreationValidation.toggleShippingFixedPrice,
                          selected:
                              (policyCreationValidation.shippingFixedPrice ??
                                  false),
                          icon: DuotoneIcon(
                              primaryLayer: Icons.euro,
                              color: redSwatch.shade500),
                          title: 'Fixed Price'),
                    )),
                    Expanded(
                        child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: small_100),
                      child: LargeIconButton(
                          onPressed:
                              policyCreationValidation.toggleShippingPerKm,
                          selected:
                              (policyCreationValidation.shippingPerKm ?? true),
                          icon: DuotoneIcon(
                              primaryLayer: Icons.place_outlined,
                              color: redSwatch.shade500),
                          title: ' By KM'),
                    ))
                  ])),*/
            policyCreationValidation.shippingFixedPrice!
                ? Padding(
                    padding: const EdgeInsets.all(small_100),
                    child: EditText(
                      hintText: 'Delivery Tax. ',
                      keyboardType: TextInputType.number,
                      saved: (policyCreationValidation.shippingFixedPriceTax ==
                              null)
                          ? ""
                          : policyCreationValidation.shippingFixedPriceTax
                              .toString(),
                      //   enabled:
                      // (store.policy == null) || editScreen,
                      onChanged:
                          policyCreationValidation.changeShippingFixedPriceTax,
                    ),
                  )
                : Container(),
            policyCreationValidation.shippingPerKm!
                ? Padding(
                    padding: const EdgeInsets.all(small_100),
                    child: EditText(
                      hintText: 'Delivery Tax per km. ',
                      keyboardType: TextInputType.number,
                      saved: (policyCreationValidation.shippingPerKmTax == null)
                          ? ""
                          : policyCreationValidation.shippingPerKmTax
                              .toString(),
                      //   enabled:
                      // (store.policy == null) || editScreen,
                      onChanged:
                          policyCreationValidation.changeShippingPerKmTax,
                    ),
                  )
                : Container(),
          ],
        ));
  }

  Step getOrdersStep(
      PolicyValidation policyCreationValidation, BuildContext context) {
    return Step(
        isActive: _currentStep >= 3,
        title: const Text("Orders"),
        content: Column(
          children: [
            const SizedBox(height: normal_100),
            SectionDivider(
                leadIcon: Icons.notifications_none_outlined,
                title: 'Notifications .',
                color: redSwatch.shade500),
            Padding(
              padding: const EdgeInsets.all(normal_100).copyWith(right: 0),
              child: Column(
                children: [
                  ListToggle(
                      title: 'Real-time notifications',
                      value: policyCreationValidation.notifRealTime!,
                      onToggle: policyCreationValidation.toggleNotifRealTime),
                  ListToggle(
                      title: 'Hourly notificationss',
                      value: policyCreationValidation.notifHourly!,
                      onToggle: policyCreationValidation.toggleNotifHourly),
                  ListToggle(
                      title: 'Batch notifications ',
                      value: policyCreationValidation.notifBatch!,
                      onToggle: policyCreationValidation.toggleNotifBatch),
                  policyCreationValidation.notifHourly!
                      ? Padding(
                          padding: const EdgeInsets.all(small_100),
                          child: DropDownSelector<String>(
                            // labelText: 'Product Category.',
                            hintText: 'I want to be notifed every.',
                            onChanged:
                                policyCreationValidation.changeNotifDuration,
                            borderType: BorderType.middle,
                            savedValue: policyCreationValidation.notifDuration
                                .toString(),
                            items: hoursMap.entries
                                .map((item) => DropdownItem<String>(
                                    value: item.key,
                                    child: Text(item.value,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                                fontWeight: FontWeight.w600))))
                                .toList(),
                          ),
                        )
                      : Container(),
                  policyCreationValidation.notifBatch!
                      ? Padding(
                          padding: const EdgeInsets.all(small_100),
                          child: DropDownSelector<String>(
                            // labelText: 'Product Category.',
                            hintText: 'Batch Notification Frequency.',
                            onChanged:
                                policyCreationValidation.changeNotifDuration,
                            borderType: BorderType.middle,
                            savedValue: policyCreationValidation.notifDuration
                                .toString(),
                            items: hoursMap.entries
                                .map((item) => DropdownItem<String>(
                                    value: item.key,
                                    child: Text(item.key,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                                fontWeight: FontWeight.w600))))
                                .toList(),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            SectionDivider(
                leadIcon: Icons.notifications_active_outlined,
                title: 'Order notification preferences.',
                color: redSwatch.shade500),
            const InfoMessage(
                message:
                    'Choose how you want to be notified of new orders. Select from email, SMS, phone call, or in-platform notifications. Pick your preferred method(s) for convenience.'),
            Padding(
              padding: const EdgeInsets.all(normal_100).copyWith(right: 0),
              child: Column(
                children: [
                  ListToggle(
                      title: 'In-platform notifications',
                      value: policyCreationValidation.notifInPlateforme!,
                      onToggle:
                          policyCreationValidation.toggleNotifInPlateforme),
                  ListToggle(
                      title: 'Pop pup notifications ',
                      value: policyCreationValidation.notifPopUp!,
                      onToggle: policyCreationValidation.toggleNotifPopup),
                  ListToggle(
                      title: 'Email notifications',
                      value: policyCreationValidation.notifEmail!,
                      onToggle: policyCreationValidation.toggleNotifEmail),
                  ListToggle(
                      title: 'SMS notifications',
                      value: policyCreationValidation.notifSms!,
                      onToggle: policyCreationValidation.toggleNotifSms),
                ],
              ),
            ),
          ],
        ));
  }

  Step getReturnStep(
      PolicyValidation policyCreationValidation, BuildContext context) {
    return Step(
        isActive: _currentStep >= 2,
        title: const Text("Return "),
        content: Column(
          children: [
            SectionDivider(
                leadIcon: Icons.book_outlined,
                title: 'Return policy  .',
                color: redSwatch.shade500),
            const InfoMessage(
                message:
                    'here, you can choose to accept returns and set conditions like timeframe, product condition, and restocking fees. Your return policy will be visible to customers on your product pages, so be clear and specific. Contact our support team if you need help or have any questions.'),
            Padding(
              padding: const EdgeInsets.all(normal_100).copyWith(right: 0),
              child: Column(
                children: [
                  ListToggle(
                      title: 'Allow Returns',
                      value: policyCreationValidation.returnAccept!,
                      onToggle: policyCreationValidation.toggleReturnAccept),
                ],
              ),
            ),
            const SizedBox(height: normal_100),
            policyCreationValidation.returnAccept!
                ? Column(
                    children: [
                      SectionDivider(
                          leadIcon: Icons.timelapse_outlined,
                          title: 'Return conditions.',
                          color: redSwatch.shade500),
                      DropDownSelector<String>(
                        // labelText: 'Product Category.',
                        hintText: 'Max Days to Return.',
                        onChanged: policyCreationValidation.changeReturnMaxDays,
                        borderType: BorderType.middle,
                        savedValue:
                            policyCreationValidation.returnMaxDays.toString(),
                        items: daysMap.entries
                            .map((item) => DropdownItem<String>(
                                value: item.key,
                                child: Text(item.value,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            fontWeight: FontWeight.w600))))
                            .toList(),
                      ),
                      const EditTextSpacer(),
                      EditText(
                        hintText: "Return status",
                        onChanged:
                            policyCreationValidation.changeReturnCondition,
                        saved: policyCreationValidation.returnCondition,
                      ),
                      const EditTextSpacer(),
                      EditText(
                        hintText: "Return method",
                        onChanged: policyCreationValidation.changeReturnMethode,
                        saved: policyCreationValidation.returnMethode,
                      ),
                      SectionDivider(
                          leadIcon: Icons.cancel_outlined,
                          title: 'Refund Policy.',
                          color: redSwatch.shade500),
                      Padding(
                        padding:
                            const EdgeInsets.all(normal_100).copyWith(right: 0),
                        child: Column(
                          children: [
                            ListToggle(
                                title: 'Shipping Fees.',
                                value:
                                    policyCreationValidation.returnShippingFee!,
                                onToggle: policyCreationValidation
                                    .toggleReturnShippingFee),
                            ListToggle(
                                title: 'Full Refund',
                                value: policyCreationValidation.returnTotalFee!,
                                onToggle: policyCreationValidation
                                    .toggleReturnTotalFee),
                            ListToggle(
                                title: 'Partial Refund',
                                value:
                                    policyCreationValidation.returnPartialFee!,
                                onToggle: policyCreationValidation
                                    .toggleReturnPartialFee),
                            if ((policyCreationValidation.returnPartialFee ??
                                true)) ...[
                              const SizedBox(height: normal_100),
                              DropDownSelector<String>(
                                // labelText: 'Product Category.',
                                hintText: 'Partial Refund Amount .',
                                onChanged:
                                    policyCreationValidation.changeReturnPerFee,
                                borderType: BorderType.middle,
                                savedValue: policyCreationValidation
                                    .returnPerFee
                                    .toString(),
                                items: percentageValues.entries
                                    .map((item) => DropdownItem<String>(
                                        value: item.key,
                                        child: Text(item.value,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w600))))
                                    .toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        ));
  }
}
