import 'package:flutter/material.dart';
import 'package:proximity/l10n/app_localizations.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/order_repository/order_repository.dart';

import 'package:provider/provider.dart';

class PickupPersonScreen extends StatefulWidget {
  const PickupPersonScreen({Key? key, required this.orderSliderValidation})
      : super(key: key);

  final OrderSliderValidation orderSliderValidation;
  @override
  _PickupPersonScreenState createState() => _PickupPersonScreenState();
}

class _PickupPersonScreenState extends State<PickupPersonScreen> {
  bool fetched = false;

  TextEditingController personController = TextEditingController();

  @override
  void dispose() {
    personController.dispose();
    super.dispose();
  }

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
        Consumer<OrderSliderValidation>(
            builder: (context, orderSliderValidation, child) {
          return Column(
            children: [
              ...orderSliderValidation.pickupPersons!.map((storeRayon) {
                return Row(children: [
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      size: 18,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      orderSliderValidation.deletePickupPerson(storeRayon.id);
                    },
                  ),
                  Expanded(
                      child: CheckboxListTile(
                    title: Text(storeRayon.name,
                        style: TextStyle(
                            fontSize: 15.0, color: Color(0xFF000000))),
                    value: storeRayon.selected,
                    onChanged: (value) {
                      setState(() {
                        orderSliderValidation.changeSelectPickupPerson(
                            value, storeRayon.id);
                      });
                    },
                  ))
                ]);
              }),
              _buildNewStoreCategoryField(orderSliderValidation),
            ],
          );
        }),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildNewStoreCategoryField(
      OrderSliderValidation orderSliderValidation) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: EditText(
              controller: personController,
              hintText: 'New Pickup Person.',
              suffixIcon: ProximityIcons.add,
              suffixOnPressed: () {
                final personName = personController.text.trim();
                if (personName.isNotEmpty) {
                  orderSliderValidation.addPickupPerson(personName);
                  setState(() {
                    personController.clear();
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
