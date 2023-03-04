import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity/widgets/forms/edit_text_spacer.dart';
import 'package:proximity_commercant/domain/store_repository/store_repository.dart';
import 'package:proximity_commercant/domain/user_repository/user_repository.dart';
import 'package:proximity_commercant/ui/widgets/address_picker/address_picker.dart';

import 'package:proximity_commercant/ui/pages/store_pages/store_pages.dart';

class StoreCreationScreen extends StatelessWidget {
  const StoreCreationScreen(
      {Key? key, this.index, required this.store, this.editScreen = false})
      : super(key: key);

  final int? index;
  final Store store;
  final bool editScreen;

  @override
  Widget build(BuildContext context) {
    /// a boolean to help fetch data ONLY if necessary
    bool didFetch = true;

    return ChangeNotifierProvider<StoreCreationValidation>(
        create: (context) => StoreCreationValidation.setStore(store),
        child: Consumer2<StoreCreationValidation, StoreService>(
            builder: (context, storeCreationValidation, storeService, child) {
          /// first check if [index] is null or not
          /// if it is null then it's a ShopAddingScreen, so no need to fetch data
          /// to edit it, and no need for a loading screen
          ///
          /// otherwise we need to check if we already fetched the data and then
          /// proceed with the rendering
          ///
          if (index != null) {
            didFetch = storeService.stores![index!].allFetched();
            if (!didFetch) storeService.getStoreByIndex(index!);
          }
          return Scaffold(
              body: SafeArea(
                  child: Stack(alignment: Alignment.bottomCenter, children: [
            ListView(children: [
              TopBar(title: editScreen ? 'Edit Store.' : 'Create a new Store.'),
              SectionDivider(
                  leadIcon: ProximityIcons.user,
                  title: 'Store owner.',
                  color: redSwatch.shade500),
              Selector<UserService, String?>(
                  selector: (_, userService) => userService.user!.email,
                  builder: (context, email, child) {
                    return RichEditText(
                      children: [
                        EditText(
                            hintText: 'Owner email.',
                            saved: email,
                            enabled: true),
                      ],
                    );
                  }),

              /// Store Details
              SectionDivider(
                  leadIcon: ProximityIcons.edit,
                  title: 'Store details.',
                  color: redSwatch.shade500),
              RichEditText(children: [
                EditText(
                  hintText: 'Name.',
                  borderType: BorderType.top,
                  saved: storeCreationValidation.storeName.value,
                  errorText: storeCreationValidation.storeName.error,
                  enabled: (store.name == null) || editScreen,
                  onChanged: storeCreationValidation.changeStoreName,
                ),
              ]),
              const EditTextSpacer(),
              RichEditText(
                children: [
                  EditText(
                    hintText: 'Description.',
                    borderType: BorderType.bottom,
                    keyboardType: TextInputType.multiline,
                    saved: storeCreationValidation.storeDescription.value,
                    errorText: storeCreationValidation.storeDescription.error,
                    maxLines: 5,
                    enabled: (store.description == null) || editScreen,
                    onChanged: storeCreationValidation.changeStoreDescription,
                  ),
                ],
              ),

              /// Error Messages
              const SizedBox(height: small_100),
              ErrorMessage(errors: [
                storeCreationValidation.storeName.error,
                storeCreationValidation.storeDescription.error
              ]),

              /// Policy

              const SizedBox(height: normal_100),

              SectionDivider(
                  leadIcon: Icons.timer_outlined,
                  title: 'Working time.',
                  color: redSwatch.shade500),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: normal_100),
                  child: Row(children: [
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: small_100),
                            child: TimeButton(
                              onPressed: (() async {
                                storeCreationValidation.getStartTime(
                                    context, storeCreationValidation.openTime);
                              }),
                              /* selected:
                              (storeCreationValidation.selfPickup ?? false),*/
                              text: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: normal_100),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${storeCreationValidation.openTime?.hour.toString().padLeft(2, '0')}:${storeCreationValidation.openTime?.minute.toString().padLeft(2, '0')}',
                                      style: const TextStyle(fontSize: 15),
                                      textAlign: TextAlign.center,
                                    ),
                                    Icon(
                                      Icons.timer_outlined,
                                      size: normal_200,
                                      color: redSwatch.shade500,
                                    ),
                                  ],
                                ),
                              ),
                            ))),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: small_100),
                      child: Text(
                        ' To ',
                        style: const TextStyle(fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: small_100),
                            child: TimeButton(
                              onPressed: (() async {
                                storeCreationValidation.getClosingTime(
                                    context, storeCreationValidation.closeTime);
                              }),
                              /* selected:
                              (storeCreationValidation.selfPickup ?? false),*/
                              text: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: normal_100),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${storeCreationValidation.closeTime?.hour.toString().padLeft(2, '0')}:${storeCreationValidation.closeTime?.minute.toString().padLeft(2, '0')}',
                                      style: const TextStyle(fontSize: 15),
                                      textAlign: TextAlign.center,
                                    ),
                                    Icon(
                                      Icons.timer_outlined,
                                      size: normal_200,
                                      color: redSwatch.shade500,
                                    ),
                                  ],
                                ),
                              ),
                            ))),
                  ])),

              /// Address
              SectionDivider(
                  leadIcon: ProximityIcons.address,
                  title: 'Address.',
                  color: redSwatch.shade500),
              const InfoMessage(
                  message:
                      'Select your Store Location from the Address Picker, then edit the address info for more accuracy.'),
              Padding(
                padding: const EdgeInsets.all(normal_100).copyWith(top: 0),
                child: TertiaryButton(
                    onPressed: () async {
                      final Address _result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddressSelectionScreen(
                                  currentAddress:
                                      storeCreationValidation.storeAddress)));
                      storeCreationValidation.changeAddress(_result);
                    },
                    title: 'Select Address.'),
              ),
              RichEditText(children: [
                EditText(
                  hintText: 'Street Address Line 1.',
                  borderType: BorderType.top,
                  saved: storeCreationValidation.storeAddress.fullAddress,
                  enabled: (store.address == null) || editScreen,
                  onChanged: storeCreationValidation.changeFullAddress,
                ),
              ]),
              const EditTextSpacer(),
              RichEditText(
                children: [
                  EditText(
                    hintText: 'Street Address Line 2.',
                    borderType: BorderType.middle,
                    saved: storeCreationValidation.storeAddress.streetName,
                    enabled: (store.address == null) || editScreen,
                    onChanged: storeCreationValidation.changeStreetName,
                  ),
                ],
              ),
              const EditTextSpacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: normal_100),
                child: DropDownSelector<String>(
                  // labelText: 'Product Category.',
                  hintText: 'Country.',
                  onChanged: storeCreationValidation.changeCountry,
                  borderType: BorderType.middle,
                  savedValue: storeCreationValidation.storeAddress.countryCode,
                  items: countryList.entries
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
              const EditTextSpacer(),
              RichEditText(
                children: [
                  EditText(
                    hintText: 'Region.',
                    borderType: BorderType.middle,
                    saved: storeCreationValidation.storeAddress.region,
                    enabled: (store.address == null) || editScreen,
                    onChanged: storeCreationValidation.changeRegion,
                  ),
                ],
              ),
              const EditTextSpacer(),
              RichEditText(
                children: [
                  EditText(
                    hintText: 'City.',
                    borderType: BorderType.middle,
                    saved: storeCreationValidation.storeAddress.city,
                    enabled: (store.address == null) || editScreen,
                    onChanged: storeCreationValidation.changeCity,
                  ),
                ],
              ),
              RichEditText(children: [
                EditText(
                  hintText: 'Postal Code.',
                  borderType: BorderType.bottom,
                  saved: storeCreationValidation.storeAddress.postalCode,
                  enabled: (store.address == null) || editScreen,
                  onChanged: storeCreationValidation.changePostalCode,
                ),
              ]),

              /// Image Picker
              SectionDivider(
                  leadIcon: ProximityIcons.picture,
                  title: 'Store Image.',
                  color: redSwatch.shade500),
              ImagePickerWidget(
                  images: storeCreationValidation.storeImages,
                  maxImages: 1,
                  onImageAdded: storeCreationValidation.addStoreImage,
                  onImageRemoved: storeCreationValidation.removeStoreImage),

              const SizedBox(height: huge_100)
            ]),
            BottomActionsBar(buttons: [
              PrimaryButton(
                  buttonState: storeService.formsLoading
                      ? ButtonState.loading
                      : (storeCreationValidation.isValid)
                          ? ButtonState.enabled
                          : ButtonState.disabled,
                  onPressed: () {
                    if (editScreen) {
                      storeService.editStore(context, index!,
                          storeCreationValidation.toFormData(), []);
                    } else {
                      StoreDialogs.confirmStore(context, 1);
                      storeService.addStore(
                          context, storeCreationValidation.toFormData());
                    }
                  },
                  title: 'Confirm.')
            ])
          ])));
        }));
  }
}

/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity/widgets/forms/edit_text_spacer.dart';
import 'package:proximity_commercant/domain/store_repository/store_repository.dart';
import 'package:proximity_commercant/domain/user_repository/user_repository.dart';
import 'package:proximity_commercant/ui/pages/home_pages/home_pages.dart';
import 'package:proximity_commercant/ui/widgets/address_picker/address_picker.dart';

class StoreCreationScreen extends StatelessWidget {
  const StoreCreationScreen(
      {Key? key, this.index, required this.store, this.editScreen = false})
      : super(key: key);

  final int? index;
  final Store store;
  final bool editScreen;

  @override
  Widget build(BuildContext context) {
    /// a boolean to help fetch data ONLY if necessary
    bool didFetch = true;

    return ChangeNotifierProvider<StoreCreationValidation>(
        create: (context) => StoreCreationValidation.setStore(store),
        child: Consumer2<StoreCreationValidation, StoreService>(
            builder: (context, storeCreationValidation, storeService, child) {
          /// first check if [index] is null or not
          /// if it is null then it's a ShopAddingScreen, so no need to fetch data
          /// to edit it, and no need for a loading screen
          ///
          /// otherwise we need to check if we already fetched the data and then
          /// proceed with the rendering
          ///
          if (index != null) {
            didFetch = storeService.stores![index!].allFetched();
            if (!didFetch) storeService.getStoreByIndex(index!);
          }
          return Scaffold(
              body: SafeArea(
                  child: Stack(alignment: Alignment.bottomCenter, children: [
            ListView(children: [
              TopBar(title: editScreen ? 'Edit Store.' : 'Create a new Store.'),
              SectionDivider(
                  leadIcon: ProximityIcons.user,
                  title: 'Store owner.',
                  color: redSwatch.shade500),
              Selector<UserService, String?>(
                  selector: (_, userService) => userService.user!.email,
                  builder: (context, email, child) {
                    return EditText(
                        borderType: BorderType.middle,
                        hintText: 'Owner email.',
                        saved: email,
                        enabled: false);
                  }),

              /// Store Details
              SectionDivider(
                  leadIcon: ProximityIcons.edit,
                  title: 'Store details.',
                  color: redSwatch.shade500),
              EditText(
                hintText: 'Name.',
                borderType: BorderType.middle,
                saved: storeCreationValidation.storeName.value,
                errorText: storeCreationValidation.storeName.error,
                enabled: (store.name == null) || editScreen,
                onChanged: storeCreationValidation.changeStoreName,
              ),
              const EditTextSpacer(),
              EditText(
                hintText: 'Description.',
                borderType: BorderType.middle,
                keyboardType: TextInputType.multiline,
                saved: storeCreationValidation.storeDescription.value,
                errorText: storeCreationValidation.storeDescription.error,
                maxLines: 5,
                enabled: (store.description == null) || editScreen,
                onChanged: storeCreationValidation.changeStoreDescription,
              ),

              /// Error Messages
              const SizedBox(height: small_100),
              ErrorMessage(errors: [
                storeCreationValidation.storeName.error,
                storeCreationValidation.storeDescription.error
              ]),

              /// Policy
              SectionDivider(
                  leadIcon: ProximityIcons.policy,
                  title: 'Store Policy.',
                  color: redSwatch.shade500),
              const InfoMessage(
                  message:
                      'Select the type of Deliveries your store support, and set a delivery tax value in case you deliver your orders.'),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: small_100),
                  child: Row(children: [
                    Expanded(
                        child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: small_100),
                      child: LargeIconButton(
                          onPressed: storeCreationValidation.toggleSelfPickup,
                          selected:
                              (storeCreationValidation.selfPickup ?? false),
                          icon: DuotoneIcon(
                              primaryLayer:
                                  ProximityIcons.self_pickup_duotone_1,
                              secondaryLayer:
                                  ProximityIcons.self_pickup_duotone_2,
                              color: redSwatch.shade500),
                          title: 'Self Pickup'),
                    )),
                    Expanded(
                        child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: small_100),
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
              if (storeCreationValidation.selfPickup ?? false) ...[
                ListToggle(
                    title: 'Free SelfPickup',
                    value: storeCreationValidation.selfPickupFree!,
                    onToggle: storeCreationValidation.toggleSelfPickupFree),
                ListToggle(
                    title: 'Partial SelfPickup',
                    value: storeCreationValidation.selfPickupPartial!,
                    onToggle: storeCreationValidation.toggleSelfPickupPartial),
                ListToggle(
                    title: 'Total SelfPickup',
                    value: storeCreationValidation.selfPickupTotal!,
                    onToggle: storeCreationValidation.toggleSelfPickupTotal),
                if (!(storeCreationValidation.selfPickupFree ?? false)) ...[
                  const SizedBox(height: normal_100),
                  EditText(
                    hintText: 'SelfPickup Price.',
                    keyboardType: TextInputType.number,
                    saved: (storeCreationValidation.selfPickupPrice == null)
                        ? ""
                        : storeCreationValidation.selfPickupPrice.toString(),
                    enabled: (store.policy == null) || editScreen,
                    onChanged: storeCreationValidation.changeSelfPickupPrice,
                  )
                ],
              ],
              if (storeCreationValidation.delivery ?? false) ...[
                const SizedBox(height: normal_100),
                EditText(
                  hintText: 'Delivery Tax.',
                  keyboardType: TextInputType.number,
                  saved: (storeCreationValidation.tax == null)
                      ? ""
                      : storeCreationValidation.tax.toString(),
                  enabled: (store.policy == null) || editScreen,
                  onChanged: storeCreationValidation.changeTax,
                )
              ],
              const SizedBox(height: normal_100),
              const EditText(
                hintText: 'Opening Time.',
                prefixIcon: Icons.timer_outlined,
                // suffixIcon: ProximityIcons.chevron_bottom,
                borderType: BorderType.middle,
              ),
              const EditTextSpacer(),
              const EditText(
                hintText: 'Closing Time.',
                prefixIcon: Icons.timer_outlined,
                // suffixIcon: ProximityIcons.chevron_bottom,
                borderType: BorderType.middle,
              ),

              /// Address
              SectionDivider(
                  leadIcon: ProximityIcons.address,
                  title: 'Address.',
                  color: redSwatch.shade500),
              const InfoMessage(
                  message:
                      'Select your Store Location from the Address Picker, then edit the address info for more accuracy.'),
              Padding(
                padding: const EdgeInsets.all(normal_100).copyWith(top: 0),
                child: TertiaryButton(
                    onPressed: () async {
                      final Address _result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddressSelectionScreen(
                                  currentAddress:
                                      storeCreationValidation.storeAddress)));
                      storeCreationValidation.changeAddress(_result);
                    },
                    title: 'Select Address.'),
              ),
              EditText(
                hintText: 'Street Address Line 1.',
                //  borderType: BorderType.middle,
                saved: storeCreationValidation.storeAddress.fullAddress,
                enabled: (store.address == null) || editScreen,
                onChanged: storeCreationValidation.changeFullAddress,
              ),
              const EditTextSpacer(),
              EditText(
                hintText: 'Street Address Line 2.',
                borderType: BorderType.middle,
                saved: storeCreationValidation.storeAddress.streetName,
                enabled: (store.address == null) || editScreen,
                onChanged: storeCreationValidation.changeStreetName,
              ),

              DropDownSelector<String>(
                padding: true,

                // labelText: 'Product Category.',
                hintText: 'Country.',
                onChanged: storeCreationValidation.changeCountry,
                // borderType: BorderType.middle,
                savedValue: storeCreationValidation.storeAddress.countryCode,
                items: countryList.entries
                    .map((item) => DropdownItem<String>(
                        value: item.key,
                        child: Text(item.value,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(fontWeight: FontWeight.w600))))
                    .toList(),
              ),
              const EditTextSpacer(),
              EditText(
                hintText: 'Region.',
                borderType: BorderType.middle,
                saved: storeCreationValidation.storeAddress.region,
                enabled: (store.address == null) || editScreen,
                onChanged: storeCreationValidation.changeRegion,
              ),
              const EditTextSpacer(),
              EditText(
                hintText: 'City.',
                borderType: BorderType.middle,
                saved: storeCreationValidation.storeAddress.city,
                enabled: (store.address == null) || editScreen,
                onChanged: storeCreationValidation.changeCity,
              ),
              const EditTextSpacer(),

              EditText(
                hintText: 'Postal Code.',
                borderType: BorderType.bottom,
                saved: storeCreationValidation.storeAddress.postalCode,
                enabled: (store.address == null) || editScreen,
                onChanged: storeCreationValidation.changePostalCode,
              ),

              /// Image Picker
              SectionDivider(
                  leadIcon: ProximityIcons.picture,
                  title: 'Store Image.',
                  color: redSwatch.shade500),
              ImagePickerWidget(
                  images: storeCreationValidation.storeImages,
                  maxImages: 1,
                  onImageAdded: storeCreationValidation.addStoreImage,
                  onImageRemoved: storeCreationValidation.removeStoreImage),

              const SizedBox(height: huge_100)
            ]),
            BottomActionsBar(buttons: [
              PrimaryButton(
                  buttonState: storeService.formsLoading
                      ? ButtonState.loading
                      : (storeCreationValidation.isValid)
                          ? ButtonState.enabled
                          : ButtonState.disabled,
                  onPressed: () async {
                    if (editScreen) {
                      await storeService.editStore(context, index!,
                          storeCreationValidation.toFormData(), []);
                      
                    } else {
                      await storeService.addStore(
                          context, storeCreationValidation.toFormData());
                      if (!storeService.formsLoading) {
                    
                      }
                    }
                  },
                  title: 'Confirm.')
            ])
          ])));
        }));
  }
}
*/
