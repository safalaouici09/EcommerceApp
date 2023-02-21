import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/user_repository/user_repository.dart';
import 'package:proximity_client/ui/widgets/address_picker/address_picker.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserEditValidation.setUser(user),
      child: Consumer<UserEditValidation>(builder: (_, userEditValidation, __) {
        return Scaffold(
            body: SafeArea(
                child: Stack(alignment: Alignment.bottomCenter, children: [
                  ListView(children: [
                    const TopBar(title: 'Edit Profile.'),
                    ImagePickerWidget(
                        images: userEditValidation.profileImage.first,
                        maxImages: 1,
                        centered: true,
                        onImageAdded: userEditValidation.editProfileImage,
                        onImageRemoved: userEditValidation.removeProfileImage),
                    SectionDivider(
                        leadIcon: ProximityIcons.user,
                        title: 'Personal Info.',
                        color: redSwatch.shade500),
                    RichEditText(children: [
                      EditText(
                        hintText: 'First Name.',
                        borderType: BorderType.topLeft,
                        saved: userEditValidation.firstName.value,
                        onChanged: userEditValidation.changeFirstName,
                      ),
                      EditText(
                        hintText: 'Last Name.',
                        borderType: BorderType.topRight,
                        saved: userEditValidation.lastName.value,
                        onChanged: userEditValidation.changeLastName,
                      ),
                      const EditText(
                          hintText: 'Birth Date.',
                          prefixIcon: ProximityIcons.calendar,
                          suffixIcon: ProximityIcons.chevron_bottom,
                          borderType: BorderType.bottom)
                    ]),
                    SectionDivider(
                        leadIcon: ProximityIcons.email,
                        title: 'Email.',
                        color: redSwatch.shade500),
                    EditText(
                      hintText: 'Add email.',
                      prefixIcon: ProximityIcons.email,
                      saved: userEditValidation.emailAddress.value,
                      onChanged: userEditValidation.changeEmailAddress,
                    ),
                    SectionDivider(
                        leadIcon: ProximityIcons.phone,
                        title: 'Phone Number.',
                        color: redSwatch.shade500),
                    EditText(
                      hintText: 'Add Phone Number.',
                      saved: userEditValidation.phone.value,
                      onChanged: userEditValidation.changePhoneNumber,
                    ),

                    /// Address
                    SectionDivider(
                        leadIcon: ProximityIcons.address,
                        title: 'Address.',
                        color: redSwatch.shade500),
                    Padding(
                      padding: const EdgeInsets.all(normal_100).copyWith(top: 0),
                      child: TertiaryButton(
                          onPressed: () async {
                            final Address _result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddressSelectionScreen(
                                        currentAddress:
                                        userEditValidation.address)));
                            userEditValidation.changeAddress(_result);
                          },
                          title: 'Select Address.'),
                    ),
                    RichEditText(children: [
                      EditText(
                        hintText: 'Street Address Line 1.',
                        borderType: BorderType.top,
                        saved: userEditValidation.address.fullAddress,
                        onChanged: userEditValidation.changeFullAddress,
                      ),
                      EditText(
                        hintText: 'Street Address Line 2.',
                        borderType: BorderType.middle,
                        saved: userEditValidation.address.streetName,
                        onChanged: userEditValidation.changeStreetName,
                      ),
                      DropDownSelector<String>(
                        // labelText: 'Product Category.',
                        hintText: 'Country.',
                        onChanged: userEditValidation.changeCountry,
                        borderType: BorderType.middle,
                        savedValue: userEditValidation.address.countryCode,
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
                      EditText(
                        hintText: 'Region.',
                        borderType: BorderType.middle,
                        saved: userEditValidation.address.region,
                        onChanged: userEditValidation.changeRegion,
                      ),
                      EditText(
                        hintText: 'City.',
                        borderType: BorderType.middle,
                        saved: userEditValidation.address.city,
                        onChanged: userEditValidation.changeCity,
                      ),
                      EditText(
                        hintText: 'Postal Code.',
                        borderType: BorderType.bottom,
                        saved: userEditValidation.address.postalCode,
                        onChanged: userEditValidation.changePostalCode,
                      )
                    ]),
                    const InfoMessage(
                        message:
                        'Your Address will be automatically the shipping address.'),
                    const SizedBox(height: huge_100)
                  ]),
                  Consumer<UserService>(builder: (_, userService, __) {
                    return BottomActionsBar(buttons: [
                      PrimaryButton(
                          onPressed: () {
                            userService.updateUser(
                                context, userEditValidation.toDataForm());
                          },
                          buttonState: userService.loading
                              ? ButtonState.loading
                              : ButtonState.enabled,
                          title: 'Update.'),
                    ]);
                  })
                ])));
      }),
    );
  }
}
