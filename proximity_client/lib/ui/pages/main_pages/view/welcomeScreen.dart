import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:proximity/config/values.dart';
import 'package:proximity/domain_repository/models/address_model.dart';
import 'package:proximity/widgets/buttons/primary_button.dart';
import 'package:proximity/widgets/buttons/tertiary_button.dart';
import 'package:proximity_client/domain/data_persistence/src/boxes.dart';
import 'package:proximity_client/domain/user_repository/models/address_item_model.dart';
import 'package:proximity_client/ui/pages/authentication_pages/widgets/onboarding_carousel.dart';
import 'package:proximity_client/ui/pages/main_pages/view/main_screen.dart';
import 'package:proximity_client/ui/widgets/address_picker/address_selection_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              const OnboardingCarousel(),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                margin: EdgeInsets.only(top: 50),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(small_50),
                      child: Text(
                          "To get started, we just need your address so we can show produts from stores in your area .\n Let's take your shopping game to the next level together.\n Happy shopping!",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline6),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: small_100),
                      child: Container(
                        width: double.infinity,
                        child: PrimaryButton(
                            onPressed: () async {
                              final _result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddressSelectionScreen(
                                            currentAddress: Address(),
                                            navigation: true,
                                          )));
                              var credentialsBox = Boxes.getCredentials();
                              credentialsBox.put(
                                  'address', AddressItem.fromAdress(_result));
                              credentialsBox.put('first_time', false);

                              // storeCreationValidation.changeAddress(_result);
                            },
                            title: 'Select Address.'),
                      ),
                    ),
                  ],
                ),
              ),
            ])));
  }
}
