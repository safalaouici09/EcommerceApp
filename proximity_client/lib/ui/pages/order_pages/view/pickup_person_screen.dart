import 'package:flutter/material.dart';
import 'package:proximity/l10n/app_localizations.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/order_repository/order_repository.dart';

class PickupPersonScreen extends StatelessWidget {
  const PickupPersonScreen({Key? key, required this.orderSliderValidation})
      : super(key: key);

  final OrderSliderValidation orderSliderValidation;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionDivider(
            leadIcon: ProximityIcons.self_pickup,
            title: AppLocalizations.of(context)!.pickupInfos,
            color: blueSwatch.shade500),
        SizedBox(height: 16),
        EditText(
          hintText: AppLocalizations.of(context)!.namePerson,
          onChanged: orderSliderValidation.changepickupName,
        ),
        SizedBox(height: 16),
        EditText(
          hintText: AppLocalizations.of(context)!.personNIN,
          keyboardType: TextInputType.number,
          onChanged: orderSliderValidation.changepickupNif,
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
