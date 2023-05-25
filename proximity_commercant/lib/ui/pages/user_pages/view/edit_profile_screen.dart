import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity/widgets/forms/edit_text_spacer.dart';
import 'package:proximity/widgets/image_picker/image_card.dart';
import 'package:proximity/widgets/image_picker/image_profile.dart';
import 'package:proximity_commercant/domain/user_repository/user_repository.dart';
import 'package:proximity_commercant/ui/widgets/address_picker/address_picker.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserService>(
      builder: (_, userService, __) {
        return ChangeNotifierProvider(
          create: (_) => UserEditValidation.setUser(userService.user!),
          child: Consumer<UserEditValidation>(
              builder: (_, userEditValidation, __) {
            return Scaffold(
                body: SafeArea(
                    child: Stack(alignment: Alignment.bottomCenter, children: [
              ListView(children: [
                const TopBar(title: 'Edit Profile.'),
                /*Padding(
                  padding: const EdgeInsets.all(normal_100),
                  child: Wrap(
                    spacing: normal_100,
                    runSpacing: normal_100,
                    alignment: WrapAlignment.center,
                    children: [
                      Container(

                          //   width: double.infinity,
                          //   height: 150,
                          decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: userEditValidation.profileImage == null
                              ? AssetImage(
                                  'assets/proximity-logo-light.png',
                                ) 
                              : Image.file(userEditValidation.profileImage!)
                                  .image,
                          fit: BoxFit.cover,
                        ),
                      ))
                    ],
                  ),
                ),*/
                ImageProfile(
                    images: userEditValidation.profileImage,
                    maxImages: 1,
                    centered: true,
                    onImageAdded: (File file) {
                      userEditValidation.editProfileImage(file, userService);
                    },
                    onImageRemoved: userEditValidation.removeProfileImage),
                /*userEditValidation.profileImage == null
                    ? ImagePickerWidget(
                        images: userEditValidation.profileImage,
                        maxImages: 1,
                        centered: true,
                        onImageAdded: userEditValidation.editProfileImage,
                        onImageRemoved: userEditValidation.removeProfileImage)
                    : ImageCard(context,
                        image:
                            "https://cdn-icons-png.flaticon.com/512/5853/5853761.png"),

                Padding(
                  padding: const EdgeInsets.all(normal_100).copyWith(top: 0),
                  child: TertiaryButton(
                      onPressed: () async {
                        //await userEditValidation.getBottomSheet(context);
                      },
                      title: 'Modifier la photo de profile'),
                ),*/

                SectionDivider(
                    leadIcon: ProximityIcons.user,
                    title: 'Personal Info.',
                    color: redSwatch.shade500),
                RichEditText(children: [
                  EditText(
                    hintText: 'User Name.',
                    borderType: BorderType.topLeft,
                    saved: userEditValidation.userName.value,
                    onChanged: userEditValidation.changeUserName,
                  ),
                ]),
                SectionDivider(
                    leadIcon: ProximityIcons.email,
                    title: 'Email.',
                    color: redSwatch.shade500),
                RichEditText(children: [
                  EditText(
                    hintText: 'Add email.',
                    prefixIcon: ProximityIcons.email,
                    saved: userEditValidation.emailAddress.value,
                    onChanged: userEditValidation.changeEmailAddress,
                  ),
                ]),

                SectionDivider(
                    leadIcon: ProximityIcons.phone,
                    title: 'Phone Number.',
                    color: redSwatch.shade500),
                RichEditText(children: [
                  EditText(
                    hintText: 'Add Phone Number.',
                    saved: userEditValidation.phone.value,
                    onChanged: userEditValidation.changePhoneNumber,
                  ),
                ]),

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
                RichEditText(
                  children: [
                    EditText(
                      hintText: 'Street Address Line 1.',
                      saved: userEditValidation.address.fullAddress,
                      onChanged: userEditValidation.changeFullAddress,
                    ),
                  ],
                ),
                const EditTextSpacer(),
                RichEditText(
                  children: [
                    EditText(
                      hintText: 'Street Address Line 2.',
                      saved: userEditValidation.address.streetName,
                      onChanged: userEditValidation.changeStreetName,
                    ),
                  ],
                ),
                const EditTextSpacer(),
                RichEditText(
                  children: [
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
                  ],
                ),
                const EditTextSpacer(),
                RichEditText(
                  children: [
                    EditText(
                      hintText: 'Region.',
                      // borderType: BorderType.middle,
                      saved: userEditValidation.address.region,
                      onChanged: userEditValidation.changeRegion,
                    ),
                  ],
                ),
                const EditTextSpacer(),
                RichEditText(
                  children: [
                    EditText(
                      hintText: 'City.',
                      // borderType: BorderType.middle,
                      saved: userEditValidation.address.city,
                      onChanged: userEditValidation.changeCity,
                    ),
                  ],
                ),
                const EditTextSpacer(),
                RichEditText(
                  children: [
                    EditText(
                      hintText: 'Postal Code.',
                      // borderType: BorderType.bottom,
                      saved: userEditValidation.address.postalCode,
                      onChanged: userEditValidation.changePostalCode,
                    ),
                  ],
                ),
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
      },
    );
  }
}
