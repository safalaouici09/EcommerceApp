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
import 'package:proximity_commercant/domain/user_repository/user_repository.dart';
import 'package:proximity_commercant/ui/widgets/address_picker/address_picker.dart';

import 'package:proximity_commercant/ui/pages/store_pages/store_pages.dart';
import 'package:proximity_commercant/ui/widgets/address_picker/area_selection_screen.dart';

class StorePolicyScreen extends StatefulWidget {
  const StorePolicyScreen({Key? key}) : super(key: key);

  @override
  State<StorePolicyScreen> createState() => _StorePolicyScreenState();
}

class _StorePolicyScreenState extends State<StorePolicyScreen> {
  @override
  int _currentStep = 0;
  bool isLastStep = false;
  List<int> _days = List.generate(30, (index) => index + 1);
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StoreCreationValidation>(
        // create: (context) => StoreCreationValidation.setStore(store),
        create: (context) => StoreCreationValidation(),
        child: Consumer2<StoreCreationValidation, StoreService>(
            builder: (context, storeCreationValidation, storeService, child) {
          return Scaffold(
              appBar: AppBar(
                title: TopBar(title: 'Store Policy.'),
                backgroundColor: Colors.white,
                elevation: 0.0,
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: Stepper(
                        elevation: 0.0,
                        currentStep: _currentStep,
                        type: StepperType.horizontal,
                        onStepContinue: () {
                          _currentStep == 3
                              ? null
                              : setState(() {
                                  _currentStep = _currentStep + 1;
                                  print(_currentStep);
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
                                PrimaryButton(
                                  onPressed: details.onStepContinue,
                                  title:
                                      _currentStep == 3 ? "confirm" : "Next.",
                                ),
                              ],
                            ),
                          );
                        },
                        steps: [
                          Step(
                              isActive: _currentStep >= 0,
                              title: Text("Shipping"),
                              content: Column(
                                children: [
                                  SectionDivider(
                                      leadIcon: ProximityIcons.policy,
                                      title: 'Store Policy.',
                                      color: redSwatch.shade500),
                                  const InfoMessage(
                                      message:
                                          'Select the type of Deliveries your store support, and set a delivery tax value in case you deliver your orders.'),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: normal_100),
                                      child: Row(children: [
                                        Expanded(
                                            child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: small_100),
                                          child: LargeIconButton(
                                              onPressed: storeCreationValidation
                                                  .toggleSelfPickup,
                                              selected: (storeCreationValidation
                                                      .selfPickup ??
                                                  false),
                                              icon: DuotoneIcon(
                                                  primaryLayer: ProximityIcons
                                                      .self_pickup_duotone_1,
                                                  secondaryLayer: ProximityIcons
                                                      .self_pickup_duotone_2,
                                                  color: redSwatch.shade500),
                                              title: 'Self Pickup'),
                                        )),
                                        Expanded(
                                            child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: small_100),
                                          child: LargeIconButton(
                                              onPressed: storeCreationValidation
                                                  .toggleDelivery,
                                              selected: (storeCreationValidation
                                                      .delivery ??
                                                  false),
                                              icon: DuotoneIcon(
                                                  primaryLayer: ProximityIcons
                                                      .delivery_duotone_1,
                                                  secondaryLayer: ProximityIcons
                                                      .delivery_duotone_2,
                                                  color: redSwatch.shade500),
                                              title: 'Delivery'),
                                        ))
                                      ])),
                                  if (storeCreationValidation.selfPickup ??
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
                                  ],
                                  if (storeCreationValidation.delivery ??
                                      false) ...[
                                    const SizedBox(height: normal_100),
                                    Padding(
                                      padding: const EdgeInsets.all(normal_100)
                                          .copyWith(top: 0),
                                      child: TertiaryButton(
                                          onPressed: () async {
                                            final Address _result =
                                                await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AreaSelectionScreen(
                                                                currentAddress:
                                                                    storeCreationValidation
                                                                        .storeAddress)));
                                            storeCreationValidation
                                                .changeAddress(_result);
                                          },
                                          title: 'Set Delivery Area.'),
                                    ),
                                    EditText(
                                      hintText: 'Delivery Tax.',
                                      keyboardType: TextInputType.number,
                                      saved:
                                          (storeCreationValidation.tax == null)
                                              ? ""
                                              : storeCreationValidation.tax
                                                  .toString(),
                                      //   enabled:
                                      // (store.policy == null) || editScreen,
                                      onChanged:
                                          storeCreationValidation.changeTax,
                                    )
                                  ],
                                ],
                              )),
                          getReservationWidget(
                              storeCreationValidation, context),
                          getReturnWidget(storeCreationValidation, context),
                          Step(
                              isActive: _currentStep >= 3,
                              title: Text("Orders"),
                              content: Container()),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        }));
  }

  Step getReservationWidget(
      StoreCreationValidation storeCreationValidation, BuildContext context) {
    return Step(
        isActive: _currentStep >= 1,
        title: Text("Reservation "),
        content: Column(
          children: [
            SectionDivider(
                leadIcon: Icons.book_outlined,
                title: 'Reservation fee.',
                color: redSwatch.shade500),
            const InfoMessage(
                message:
                    'indicate the reservation policy for your product. Include whether the reservation is free, partial or total, the maximum days for reservation, and any applicable cancellation fees.'),
            Padding(
              padding: const EdgeInsets.all(normal_100).copyWith(right: 0),
              child: Column(
                children: [
                  ListToggle(
                      title: 'Free Reservation',
                      value: storeCreationValidation.reservationFree!,
                      onToggle: storeCreationValidation.toggleReservationFree),
                  ListToggle(
                      title: 'Partial Reservation',
                      value: storeCreationValidation.reservationPartial!,
                      onToggle:
                          storeCreationValidation.toggleReservationPartial),
                  ListToggle(
                      title: 'Total Reservation',
                      value: storeCreationValidation.reservationTotal!,
                      onToggle: storeCreationValidation.toggleReservationTotal),
                  if ((storeCreationValidation.reservationPartial ?? true)) ...[
                    const SizedBox(height: normal_100),
                    EditText(
                      hintText: 'Reservation Price.',
                      keyboardType: TextInputType.number,
                      saved: (storeCreationValidation.selfPickupPrice == null)
                          ? ""
                          : storeCreationValidation.selfPickupPrice.toString(),
                      //enabled: (store.policy == null) || editScreen,
                      onChanged: storeCreationValidation.changeSelfPickupPrice,
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
              onChanged: storeCreationValidation.changeResevationDuration,
              borderType: BorderType.middle,
              savedValue:
                  storeCreationValidation.reservationDuration.toString(),
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
            SectionDivider(
                leadIcon: Icons.cancel_outlined,
                title: 'Reservation cancelation.',
                color: redSwatch.shade500),
            Padding(
              padding: const EdgeInsets.all(normal_100).copyWith(right: 0),
              child: Column(
                children: [
                  ListToggle(
                      title: 'Free Cancelation',
                      value:
                          storeCreationValidation.reservationConcelationFree!,
                      onToggle: storeCreationValidation
                          .toggleReservationConcelationFree),
                  ListToggle(
                      title: 'Chargeable Cancelation',
                      value: storeCreationValidation
                          .reservationConcelationPartial!,
                      onToggle: storeCreationValidation
                          .toggleReservationConcelationPartial),
                  if ((storeCreationValidation.reservationConcelationPartial ??
                      true)) ...[
                    const SizedBox(height: normal_100),
                    EditText(
                      hintText: 'Cancelation Fee.',
                      keyboardType: TextInputType.number,
                      saved: (storeCreationValidation.selfPickupPrice == null)
                          ? ""
                          : storeCreationValidation.selfPickupPrice.toString(),
                      //enabled: (store.policy == null) || editScreen,
                      onChanged: storeCreationValidation.changeSelfPickupPrice,
                    )
                  ],
                ],
              ),
            ),
          ],
        ));
  }

  Step getReturnWidget(
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
                  ListToggle(
                      title: 'Decline Returns',
                      value: storeCreationValidation.returnNotAccept!,
                      onToggle: storeCreationValidation.toggleReturnNotAccept),
                ],
              ),
            ),
            const SizedBox(height: normal_100),
            storeCreationValidation.returnAccept!
                ? Column(
                    children: [
                      SectionDivider(
                          leadIcon: Icons.timelapse_outlined,
                          title: 'Return  duration.',
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
