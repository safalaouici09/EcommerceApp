import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(alignment: Alignment.bottomCenter, children: [
      ListView(children: [
        const TopBar(title: 'Order Confirmation.'),
        SectionDivider(
            leadIcon: ProximityIcons.visa,
            title: 'Visa Card Info.',
            color: blueSwatch.shade500),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: large_200),
          child: Image.network(
              'https://i.ibb.co/zmn2F5b/Vector-Visa-Credit-Card.png'),
        ),
        const SizedBox(height: normal_100),
        const RichEditText(children: [
          EditText(
              hintText: 'CVC',
              obscureText: true,
              borderType: BorderType.topLeft),
          EditText(hintText: 'MM/YY', borderType: BorderType.topRight),
          EditText(
              hintText: '1000 ---- ---- ----', borderType: BorderType.bottom),
        ]),
        const InfoMessage(
            message:
                "This is a secure SSH access only page where you can input your Credit Card info with all safety.")
      ]),
      BottomActionsBar(buttons: [
        PrimaryButton(
          title: "Validate.",
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ])
    ])));
  }
}
