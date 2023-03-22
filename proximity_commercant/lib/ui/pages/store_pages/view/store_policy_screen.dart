import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity/widgets/forms/edit_text_spacer.dart';
import 'package:proximity_commercant/domain/store_repository/store_repository.dart';

import 'package:proximity_commercant/ui/widgets/address_picker/area_selection_screen.dart';

class StorePolicyScreen extends StatefulWidget {
  StorePolicyScreen({Key? key, this.global}) : super(key: key);
  bool? global;
  @override
  State<StorePolicyScreen> createState() => _StorePolicyScreenState();
}

class _StorePolicyScreenState extends State<StorePolicyScreen> {
  @override
  int _currentStep = 0;
  bool isLastStep = false;

  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StoreCreationValidation>(
        // create: (context) => StoreCreationValidation.setStore(store),
        create: (context) => StoreCreationValidation(),
        child: Consumer2<StoreCreationValidation, StoreService>(
            builder: (context, storeCreationValidation, storeService, child) {
          return Scaffold(
              appBar: AppBar(
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: TopBar(
                      title:
                          widget.global! ? 'Golbal Policy.' : 'Store Policy.'),
                ),
                backgroundColor: Colors.white,
                elevation: 0.0,
              ),
              body: SafeArea(
                child: Expanded(
                  child: Stepper(
                    physics: ClampingScrollPhysics(),
                    elevation: 0.0,
                    currentStep: _currentStep,
                    type: StepperType.horizontal,
                    onStepContinue: () {
                      _currentStep == 3
                          ? widget.global!
                              ? storeCreationValidation.updatePolicy(context,
                                  storeCreationValidation.policytoFormData())
                              : Navigator.pop(context)
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
                        padding: const EdgeInsets.all(normal_100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  buttonState: (_currentStep == 0 &&
                                              storeCreationValidation
                                                  .shippingIsValid) ||
                                          (_currentStep == 1 &&
                                              storeCreationValidation
                                                  .reservationIsValid) ||
                                          (_currentStep == 2 &&
                                              storeCreationValidation
                                                  .returnIsValid) ||
                                          (_currentStep == 3 &&
                                              storeCreationValidation
                                                  .ordersIsValid)
                                      ? ButtonState.enabled
                                      : ButtonState.disabled,
                                  onPressed: details.onStepContinue,
                                  title:
                                      _currentStep == 3 ? "confirm" : "Next.",
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    steps: [
                      getShippingStep(storeCreationValidation, context),
                      getReservationStep(storeCreationValidation, context),
                      getReturnStep(storeCreationValidation, context),
                      getOrdersStep(storeCreationValidation, context),
                    ],
                  ),
                ),
              ));
        }));
  }

  Step getShippingStep(
      StoreCreationValidation storeCreationValidation, BuildContext context) {
    return Step(
        isActive: _currentStep >= 0,
        title: Text("Shipping"),
        content: Column(
          children: [
            SectionDivider(
                leadIcon: Icons.local_shipping_outlined,
                title: 'Shipping Policy.',
                color: redSwatch.shade500),
            const InfoMessage(
                message:
                    'Select the type of Deliveries your store support, and set a delivery tax value in case you deliver your orders.'),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: normal_100),
                child: Row(children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: small_100),
                    child: LargeIconButton(
                        onPressed: storeCreationValidation.toggleSelfPickup,
                        selected: (storeCreationValidation.selfPickup ?? false),
                        icon: DuotoneIcon(
                            primaryLayer: ProximityIcons.self_pickup_duotone_1,
                            secondaryLayer:
                                ProximityIcons.self_pickup_duotone_2,
                            color: redSwatch.shade500),
                        title: 'Self Pickup'),
                  )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: small_100),
                    child: LargeIconButton(
                        onPressed: storeCreationValidation.toggleDelivery,
                        selected: (storeCreationValidation.delivery ?? false),
                        icon: DuotoneIcon(
                            primaryLayer: ProximityIcons.delivery_duotone_1,
                            secondaryLayer: ProximityIcons.delivery_duotone_2,
                            color: redSwatch.shade500),
                        title: 'Delivery'),
                  ))
                ])),
            if (storeCreationValidation.selfPickup ?? true)
              Padding(
                padding: const EdgeInsets.all(normal_100).copyWith(right: 0),
                child: DropDownSelector<String>(
                  // labelText: 'Product Category.',
                  hintText: 'Max Days to Pick Up.',
                  onChanged: storeCreationValidation.changeSelfPickUpMaxDays,
                  borderType: BorderType.middle,
                  savedValue:
                      storeCreationValidation.selfPickUplMaxDays.toString(),
                  items: daysMap.entries
                      .map((item) => DropdownItem<String>(
                          value: item.key,
                          child: Text(item.value,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(fontWeight: FontWeight.w600))))
                      .toList(),
                ),
              ),

            /*  if (storeCreationValidation.selfPickup ??
                                    false) ...[
                                  ListToggle(
                                      title: 'Free SelfPickup',
                                      value: storeCreationValidation
                                          .selfPickupFree!,
                                      onToggle: storeCreationValidation
                                          .toggleSelfPickupFree),
                                  ListToggle(
                                      title: 'Partial SelfPickup',
                                      value: storeCreationValidation
                                          .selfPickupPartial!,
                                      onToggle: storeCreationValidation
                                          .toggleSelfPickupPartial),
                                  ListToggle(
                                      title: 'Total SelfPickup',
                                      value: storeCreationValidation
                                          .selfPickupTotal!,
                                      onToggle: storeCreationValidation
                                          .toggleSelfPickupTotal),
                                  if (!(storeCreationValidation
                                          .selfPickupFree ??
                                      false)) ...[
                                    const SizedBox(height: normal_100),
                                    EditText(
                                      hintText: 'SelfPickup Price.',
                                      keyboardType: TextInputType.number,
                                      saved: (storeCreationValidation
                                                  .selfPickupPrice ==
                                              null)
                                          ? ""
                                          : storeCreationValidation
                                              .selfPickupPrice
                                              .toString(),
                                      //    enabled: (store.policy == null) ||
                                      //    editScreen,
                                      onChanged: storeCreationValidation
                                          .changeSelfPickupPrice,
                                    )
                                  ],
                                ],*/
            if (storeCreationValidation.delivery ?? false) ...[
              const SizedBox(height: normal_100),
              Padding(
                padding: const EdgeInsets.all(normal_100).copyWith(top: 0),
                child: TertiaryButton(
                    onPressed: () async {
                      final Address _result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AreaSelectionScreen(
                                  currentAddress:
                                      storeCreationValidation.storeAddress)));
                      //  storeCreationValidation
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
                              storeCreationValidation.toggleShippingFixedPrice,
                          selected:
                              (storeCreationValidation.shippingFixedPrice ??
                                  false),
                          icon: DuotoneIcon(
                              primaryLayer: Icons.euro,
                              secondaryLayer: ProximityIcons.delivery_duotone_2,
                              color: redSwatch.shade500),
                          title: 'Fixed Price'),
                    )),
                    Expanded(
                        child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: small_100),
                      child: LargeIconButton(
                          onPressed:
                              storeCreationValidation.toggleShippingPerKm,
                          selected:
                              (storeCreationValidation.shippingPerKm ?? true),
                          icon: DuotoneIcon(
                              primaryLayer: Icons.place_outlined,
                              secondaryLayer: ProximityIcons.delivery_duotone_2,
                              color: redSwatch.shade500),
                          title: ' By KM'),
                    ))
                  ])),
              storeCreationValidation.shippingFixedPrice!
                  ? Padding(
                      padding: const EdgeInsets.all(small_100),
                      child: EditText(
                        hintText: 'Delivery Tax. ',
                        keyboardType: TextInputType.number,
                        saved: (storeCreationValidation.shippingFixedPriceTax ==
                                null)
                            ? ""
                            : storeCreationValidation.shippingFixedPriceTax
                                .toString(),
                        //   enabled:
                        // (store.policy == null) || editScreen,
                        onChanged:
                            storeCreationValidation.changeShippingFixedPriceTax,
                      ),
                    )
                  : Container(),
              storeCreationValidation.shippingPerKm!
                  ? Padding(
                      padding: const EdgeInsets.all(small_100),
                      child: EditText(
                        hintText: 'Delivery Tax per km. ',
                        keyboardType: TextInputType.number,
                        saved:
                            (storeCreationValidation.shippingPerKmTax == null)
                                ? ""
                                : storeCreationValidation.shippingPerKmTax
                                    .toString(),
                        //   enabled:
                        // (store.policy == null) || editScreen,
                        onChanged:
                            storeCreationValidation.changeShippingPerKmTax,
                      ),
                    )
                  : Container(),
            ],
          ],
        ));
  }

  Step getOrdersStep(
      StoreCreationValidation storeCreationValidation, BuildContext context) {
    return Step(
        isActive: _currentStep >= 3,
        title: Text("Orders"),
        content: Column(
          children: [
            SectionDivider(
                leadIcon: Icons.check_circle_outline,
                title: 'Orders Validation.',
                color: redSwatch.shade500),
            const InfoMessage(message: '.'),
            Padding(
              padding: const EdgeInsets.all(normal_100).copyWith(right: 0),
              child: Column(
                children: [
                  ListToggle(
                      title: 'Automatic validation',
                      value: storeCreationValidation.oredersAutoValidation!,
                      onToggle:
                          storeCreationValidation.toggleOrdersAutoValidation),
                  ListToggle(
                      title: 'Manuel validation',
                      value: storeCreationValidation.oredersManValidation!,
                      onToggle:
                          storeCreationValidation.toggleOredersManValidation),
                  ListToggle(
                      title: 'Both',
                      value: storeCreationValidation.oredersMixValidation!,
                      onToggle:
                          storeCreationValidation.toggleOrdersMixValidation),
                ],
              ),
            ),
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
                      value: storeCreationValidation.notifRealTime!,
                      onToggle: storeCreationValidation.toggleNotifRealTime),
                  ListToggle(
                      title: 'Hourly notificationss',
                      value: storeCreationValidation.notifHourly!,
                      onToggle: storeCreationValidation.toggleNotifHourly),
                  ListToggle(
                      title: 'Batch notifications ',
                      value: storeCreationValidation.notifBatch!,
                      onToggle: storeCreationValidation.toggleNotifBatch),
                  storeCreationValidation.notifHourly!
                      ? Padding(
                          padding: const EdgeInsets.all(small_100),
                          child: DropDownSelector<String>(
                            // labelText: 'Product Category.',
                            hintText: 'I want to be notifed every.',
                            onChanged:
                                storeCreationValidation.changeNotifDuration,
                            borderType: BorderType.middle,
                            savedValue: storeCreationValidation.notifDuration
                                .toString(),
                            items: hoursMap.entries
                                .map((item) => DropdownItem<String>(
                                    value: item.key,
                                    child: Text(item.value,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .copyWith(
                                                fontWeight: FontWeight.w600))))
                                .toList(),
                          ),
                        )
                      : Container(),
                  storeCreationValidation.notifBatch!
                      ? Padding(
                          padding: const EdgeInsets.all(small_100),
                          child: DropDownSelector<String>(
                            // labelText: 'Product Category.',
                            hintText: 'Batch Notification Frequency.',
                            onChanged:
                                storeCreationValidation.changeNotifDuration,
                            borderType: BorderType.middle,
                            savedValue: storeCreationValidation.notifDuration
                                .toString(),
                            items: hoursMap.entries
                                .map((item) => DropdownItem<String>(
                                    value: item.key,
                                    child: Text(item.key,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
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
                      value: storeCreationValidation.notifInPlateforme!,
                      onToggle:
                          storeCreationValidation.toggleNotifInPlateforme),
                  ListToggle(
                      title: 'Pop pup notifications ',
                      value: storeCreationValidation.notifPopUp!,
                      onToggle: storeCreationValidation.toggleNotifPopup),
                  ListToggle(
                      title: 'Email notifications',
                      value: storeCreationValidation.notifEmail!,
                      onToggle: storeCreationValidation.toggleNotifEmail),
                  ListToggle(
                      title: 'SMS notifications',
                      value: storeCreationValidation.notifSms!,
                      onToggle: storeCreationValidation.toggleNotifSms),
                ],
              ),
            ),
          ],
        ));
  }

  Step getReservationStep(
      StoreCreationValidation storeCreationValidation, BuildContext context) {
    return Step(
        isActive: _currentStep >= 1,
        title: Text("Reservation "),
        content: Column(
          children: [
            ListToggle(
                title: 'Allow Reservations',
                value: storeCreationValidation.reservationAccept!,
                onToggle: storeCreationValidation.toggleReservationAceept),
            storeCreationValidation.reservationAccept!
                ? Column(
                    children: [
                      SectionDivider(
                          leadIcon: Icons.book_outlined,
                          title: 'Reservation fee.',
                          color: redSwatch.shade500),
                      const InfoMessage(
                          message:
                              'indicate the reservation policy for your product. Include whether the reservation is free, partial or total, the maximum days for reservation, and any applicable cancellation fees.'),
                      Padding(
                        padding:
                            const EdgeInsets.all(normal_100).copyWith(right: 0),
                        child: Column(
                          children: [
                            ListToggle(
                                title: 'Free Reservation',
                                value: storeCreationValidation.reservationFree!,
                                onToggle: storeCreationValidation
                                    .toggleReservationFree),
                            ListToggle(
                                title: 'Partial Reservation',
                                value:
                                    storeCreationValidation.reservationPartial!,
                                onToggle: storeCreationValidation
                                    .toggleReservationPartial),
                            ListToggle(
                                title: 'Total Reservation',
                                value:
                                    storeCreationValidation.reservationTotal!,
                                onToggle: storeCreationValidation
                                    .toggleReservationTotal),
                            if ((storeCreationValidation.reservationPartial ??
                                true)) ...[
                              const SizedBox(height: normal_100),
                              EditText(
                                hintText: 'Reservation Price.',
                                keyboardType: TextInputType.number,
                                saved: (storeCreationValidation
                                            .reservationtax ==
                                        null)
                                    ? ""
                                    : storeCreationValidation.reservationtax!
                                        .toString(),
                                //enabled: (store.policy == null) || editScreen,
                                onChanged: storeCreationValidation
                                    .changeReservationTax,
                              )
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: normal_100),
                      SectionDivider(
                          leadIcon: Icons.timelapse_outlined,
                          title: 'Reservation duration.',
                          color: redSwatch.shade500),
                      DropDownSelector<String>(
                        // labelText: 'Product Category.',
                        hintText: 'Reservation duration.',
                        onChanged:
                            storeCreationValidation.changeResevationDuration,
                        borderType: BorderType.middle,
                        savedValue: storeCreationValidation.reservationDuration
                            .toString(),
                        items: daysMap.entries
                            .map((item) => DropdownItem<String>(
                                value: item.key,
                                child: Text(item.value,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(
                                            fontWeight: FontWeight.w600))))
                            .toList(),
                      ),
                      SectionDivider(
                          leadIcon: Icons.cancel_outlined,
                          title: 'Reservation cancelation.',
                          color: redSwatch.shade500),
                      Padding(
                        padding:
                            const EdgeInsets.all(normal_100).copyWith(right: 0),
                        child: Column(
                          children: [
                            ListToggle(
                                title: 'Free Cancelation',
                                value: storeCreationValidation
                                    .reservationConcelationFree!,
                                onToggle: storeCreationValidation
                                    .toggleReservationConcelationFree),
                            ListToggle(
                                title: 'Chargeable Cancelation',
                                value: storeCreationValidation
                                    .reservationConcelationPartial!,
                                onToggle: storeCreationValidation
                                    .toggleReservationConcelationPartial),
                            if ((storeCreationValidation
                                    .reservationConcelationPartial ??
                                true)) ...[
                              const SizedBox(height: normal_100),
                              EditText(
                                hintText: 'Cancelation Fee.',
                                keyboardType: TextInputType.number,
                                saved: (storeCreationValidation
                                            .reservationcancelationtax ==
                                        null)
                                    ? ""
                                    : storeCreationValidation
                                        .reservationcancelationtax
                                        .toString(),
                                //enabled: (store.policy == null) || editScreen,
                                onChanged: storeCreationValidation
                                    .changeReservationCancelationTax,
                              )
                            ],
                          ],
                        ),
                      ),
                    ],
                  )
                : Container()
          ],
        ));
  }

  Step getReturnStep(
      StoreCreationValidation storeCreationValidation, BuildContext context) {
    return Step(
        isActive: _currentStep >= 2,
        title: Text("Return "),
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
                      value: storeCreationValidation.returnAccept!,
                      onToggle: storeCreationValidation.toggleReturnAccept),
                ],
              ),
            ),
            const SizedBox(height: normal_100),
            storeCreationValidation.returnAccept!
                ? Column(
                    children: [
                      SectionDivider(
                          leadIcon: Icons.timelapse_outlined,
                          title: 'Return conditions.',
                          color: redSwatch.shade500),
                      DropDownSelector<String>(
                        // labelText: 'Product Category.',
                        hintText: 'Max Days to Return.',
                        onChanged: storeCreationValidation.changeReturnMaxDays,
                        borderType: BorderType.middle,
                        savedValue:
                            storeCreationValidation.returnMaxDays.toString(),
                        items: daysMap.entries
                            .map((item) => DropdownItem<String>(
                                value: item.key,
                                child: Text(item.value,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(
                                            fontWeight: FontWeight.w600))))
                            .toList(),
                      ),
                      const EditTextSpacer(),
                      EditText(
                        hintText: "Return status",
                        onChanged:
                            storeCreationValidation.changeReturnCondition,
                        saved: storeCreationValidation.returnCondition,
                      ),
                      const EditTextSpacer(),
                      EditText(
                        hintText: "Return method",
                        onChanged: storeCreationValidation.changeReturnMethode,
                        saved: storeCreationValidation.returnMethode,
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
                                    storeCreationValidation.returnShippingFee!,
                                onToggle: storeCreationValidation
                                    .toggleReturnShippingFee),
                            ListToggle(
                                title: 'Full Refund',
                                value: storeCreationValidation.returnTotalFee!,
                                onToggle: storeCreationValidation
                                    .toggleReturnTotalFee),
                            ListToggle(
                                title: 'Partial Refund',
                                value:
                                    storeCreationValidation.returnPartialFee!,
                                onToggle: storeCreationValidation
                                    .toggleReturnPartialFee),
                            if ((storeCreationValidation.returnPartialFee ??
                                true)) ...[
                              const SizedBox(height: normal_100),
                              DropDownSelector<String>(
                                // labelText: 'Product Category.',
                                hintText: 'Partial Refund Amount .',
                                onChanged:
                                    storeCreationValidation.changeReturnPerFee,
                                borderType: BorderType.middle,
                                savedValue: storeCreationValidation.returnPerFee
                                    .toString(),
                                items: percentageValues.entries
                                    .map((item) => DropdownItem<String>(
                                        value: item.key,
                                        child: Text(item.value,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
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
