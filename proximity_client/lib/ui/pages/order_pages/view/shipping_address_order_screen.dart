import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/order_repository/order_repository.dart';
import 'package:proximity_client/ui/pages/order_pages/order_pages.dart';
import 'package:proximity_client/ui/widgets/address_picker/area_selection_screen.dart';

class ShippingAddressOrderScreen extends StatelessWidget {
  const ShippingAddressOrderScreen(
      {Key? key, required this.orderSliderValidation})
      : super(key: key);

  final OrderSliderValidation orderSliderValidation;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SectionDivider(
            leadIcon: ProximityIcons.delivery,
            title: 'Delivery Infos.',
            color: blueSwatch.shade500),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(normal_100).copyWith(top: 0),
          child: TertiaryButton(
              onPressed: () async {
                final Address _result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AreaSelectionScreen(
                            currentAddress:
                                orderSliderValidation.deliveryAdresse)));
                orderSliderValidation.changeDeliveryAddress(_result);

                //  policyCreationValidation
                //  .changeAddress(_result);
              },
              title: 'Set Delivery Area.'),
        ),
        if (orderSliderValidation.deliveryAdresse != null)
          Padding(
            padding: const EdgeInsets.all(normal_100).copyWith(top: 0),
            child: OrderDetails(details: {
              'City': orderSliderValidation.deliveryAdresse!.city ?? "",
              'Region': orderSliderValidation.deliveryAdresse!.region ?? "",
              'Full Address':
                  orderSliderValidation.deliveryAdresse!.fullAddress ?? "",
            }),
          ),
        // if (orderSliderValidation.maxDeliveryFixe != null &&
        //     orderSliderValidation.maxDeliveryFixe != 0.0)
        //   Padding(
        //     padding: const EdgeInsets.all(normal_100).copyWith(top: 0),
        //     child: Row(
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Text("Delivery Price Fixed at ",
        //               style: Theme.of(context).textTheme.bodyText2?.copyWith(
        //                   color: Color(0xFF136DA5),
        //                   fontWeight: FontWeight.bold)),
        //           const SizedBox(width: small_100),
        //           Expanded(
        //               child: Text(
        //             ' € ${orderSliderValidation.maxDeliveryFixe.toString()}',
        //             style: Theme.of(context).textTheme.displaySmall?.copyWith(
        //                 color: Color(0xFF136DA5), fontWeight: FontWeight.bold),
        //             textAlign: TextAlign.end,
        //             maxLines: 2,
        //             overflow: TextOverflow.ellipsis,
        //           )),
        //         ]),
        //   )
        // else if (orderSliderValidation.distance != null &&
        //     orderSliderValidation.distance != 0.0)
        //   Padding(
        //     padding: const EdgeInsets.all(normal_100).copyWith(top: 0),
        //     child: Column(children: [
        //       Row(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Text("Distance ",
        //                 style: Theme.of(context).textTheme.bodyText2?.copyWith(
        //                     color: Color(0xFF136DA5),
        //                     fontWeight: FontWeight.bold)),
        //             const SizedBox(width: small_100),
        //             Expanded(
        //                 child: Text(
        //               '${(orderSliderValidation.distance ?? 1.0).toStringAsFixed(2)} Km ',
        //               style: Theme.of(context).textTheme.bodyText2?.copyWith(
        //                   color: Color(0xFF136DA5),
        //                   fontWeight: FontWeight.bold),
        //               textAlign: TextAlign.end,
        //               maxLines: 2,
        //               overflow: TextOverflow.ellipsis,
        //             )),
        //           ]),
        //       Row(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Text("Km Price ",
        //                 style: Theme.of(context).textTheme.bodyText2?.copyWith(
        //                     color: Color(0xFF136DA5),
        //                     fontWeight: FontWeight.bold)),
        //             const SizedBox(width: small_100),
        //             Expanded(
        //                 child: Text(
        //               '${(orderSliderValidation.maxDeliveryKm ?? 1.0).toStringAsFixed(2)} Km ',
        //               style: Theme.of(context).textTheme.bodyText2?.copyWith(
        //                   color: Color(0xFF136DA5),
        //                   fontWeight: FontWeight.bold),
        //               textAlign: TextAlign.end,
        //               maxLines: 2,
        //               overflow: TextOverflow.ellipsis,
        //             )),
        //           ]),
        //       SizedBox(height: 20),
        //       Row(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Text("Delivery Price ",
        //                 style: Theme.of(context).textTheme.bodyText2?.copyWith(
        //                     color: Color(0xFF136DA5),
        //                     fontWeight: FontWeight.bold)),
        //             const SizedBox(width: small_100),
        //             Expanded(
        //                 child: Text(
        //               ' € ${((orderSliderValidation.maxDeliveryKm ?? 1.0) * (orderSliderValidation.distance ?? 1.0)).toStringAsFixed(2)}',
        //               style: Theme.of(context).textTheme.displaySmall?.copyWith(
        //                   color: Color(0xFF136DA5),
        //                   fontWeight: FontWeight.bold),
        //               textAlign: TextAlign.end,
        //               maxLines: 2,
        //               overflow: TextOverflow.ellipsis,
        //             )),
        //           ])
        //     ]),
        //   ),
        // SizedBox(height: 20),
      ],
    );
  }
}
