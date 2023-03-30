import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/product_repository/product_repository.dart';
import 'package:proximity_client/domain/store_repository/store_repository.dart';
import 'package:proximity_client/ui/pages/product_pages/product_pages.dart';
import 'package:proximity_client/domain/cart_repository/cart_repository.dart';
import "package:proximity/widgets/widgets.dart" ;
import 'package:proximity_client/domain/order_repository/order_repository.dart';
import 'package:proximity/icons/proximity_icons.dart';

class CardItem extends StatelessWidget {
  const CardItem(
      {Key? key, required this.product, required this.orderSliderValidation ,  this.shrinkWidth = true})
      : super(key: key);

  final ProductCart product;
  final bool shrinkWidth;
  final OrderSliderValidation orderSliderValidation;

  @override
  Widget build(BuildContext context) {
    /// A [productProxy] is declared to update its value [idShop] whenever
    /// a new shop is selected
    final storeProxy = Provider.of<StoreProxy>(context);

    SizedBox _productCard = SizedBox(
        height:(product.characteristics ?? []).length == 0 ? 145 : 145 +((product.characteristics ?? []).length* 15) ,
        width: shrinkWidth ? 330 : null,
        child: Container(
            padding: const EdgeInsets.all(tiny_50),
            margin: const EdgeInsets.symmetric(horizontal: small_100 , vertical : small_100),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                ClipRRect(
                    borderRadius:
                        const BorderRadius.all(smallRadius),
                    child: 
                    Image.network(BASE_IMG_URL+'/'+(product.image ?? "" ),
                        height: huge_100 - small_50, 
                        width: huge_100 - small_50,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        errorBuilder: (
                            BuildContext context,
                            Object error,
                            StackTrace? stackTrace,
                            ) {
                            return const AspectRatio(
                                aspectRatio: 1.0,
                                child: SizedBox(
                                    width: large_100,
                                    height: large_100));
                        })),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(small_50),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment : MainAxisAlignment.center ,
                            children: [
                                Row(
                                    mainAxisAlignment : MainAxisAlignment.end ,
                                    children : [
                                        InkWell(
                                            onTap: () {
                                                orderSliderValidation.deleteProduct(product.id) ;
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'Item Deleted Successfully')));
                                                },
                                            child: Icon( ProximityIcons.rejected , color: redSwatch.shade500)
                                        )  
                                ]) ,
                                const Spacer(),
                                Row(
                                    mainAxisAlignment : MainAxisAlignment.center ,
                                    children : [
                                    Text(product.name!,
                                        style: Theme.of(context).textTheme
                                            .subtitle2!
                                            .copyWith(fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                        
                                    ]),
                                    const Spacer(),
                                    for(var item in (product.characteristics ?? []) ) 
                                            Row(
                                                mainAxisAlignment : MainAxisAlignment.center ,
                                                children : [
                                                    Text((item["name"]! ?? "")+" : ",
                                                    style: Theme.of(context).textTheme.bodyText1,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis),
                                                    Text(item["value"]!,
                                                    style: Theme.of(context).textTheme.bodyText1,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis),
                                            ]) ,

                                    Row(
                                        mainAxisAlignment : MainAxisAlignment.center ,
                                        children : [
                                        Text(
                                        '€ ${double.parse((product.price!).toStringAsFixed(2))}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .copyWith(fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                        )

                                    ]) ,
                                    const Spacer(),
                                    
                                    Row(
                                        mainAxisAlignment : MainAxisAlignment.center ,
                                        children : [
                                            QuantitySelector(
                                                    quantity: product.quantity ?? 0,
                                                    // maxQuantity: cartItem.quantity,
                                                    increaseQuantity: ()=> {
                                                        orderSliderValidation.changeQuantity((product.quantity ?? 0) +1 , product.id)
                                                    },
                                                    decreaseQuantity: ()=> {
                                                        if((product.quantity ?? 0) > 1 ) {
                                                            orderSliderValidation.changeQuantity((product.quantity ?? 0)-1 , product.id)
                                                        }
                                                    }
                                                )  ,

                                    ]) ,
                                
                            ]))),
                ]) 
            ));

    return Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(smallRadius),
            color: Color(0xFFE4E4E4)
        ),
        margin: const EdgeInsets.symmetric(vertical: small_100),
        child : Padding(
            padding:
                const EdgeInsets.all(small_100),
            child: 
            Column(
                children : [
                    (product.discount != 0.0)
                        ? Stack(children: [
                            _productCard,
                            Container(
                                padding: const EdgeInsets.all(tiny_50),
                                margin: const EdgeInsets.symmetric(vertical: small_100),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(tinyRadius),
                                    color: redSwatch.shade500),
                                child: Text(
                                '-${(product.discount * 100).toInt()}%',
                                style: Theme.of(context).textTheme.caption!.copyWith(
                                    color: primaryTextDarkColor,
                                    fontWeight: FontWeight.w800),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                ))
                        ])
                        : _productCard , 
                        if(product.reservationPolicy == true ) 
                        ListToggle(
                        title: 'Reservation',
                        value: product.reservation , 
                        onToggleId : orderSliderValidation.toggleReservation ,
                        toggleId : product.id , 
                        leadIcon : ProximityIcons.info , 
                        importantMessage : '${(product.reservationP * 100).toInt()}%'
                        )  ,
                        if(product.pickupPolicy == true && product.reservation == false )
                        ListToggle(
                        title: 'PickUp',
                        value: product.pickup, 
                        onToggleId : orderSliderValidation.togglePickup ,
                        toggleId : product.id  , 
                        leadIcon : ProximityIcons.info, 
                        importantMessage : "Free"
                        )  ,
                        if(product.deliveryPolicy == true && product.reservation == false) 
                        ListToggle(
                        title: 'Delivery',
                        value: product.delivery , 
                        onToggleId : orderSliderValidation.toggleDelivery ,
                        toggleId : product.id , 
                        leadIcon : ProximityIcons.info, 
                        importantMessage : '${(product.deliveryP * 100).toInt()}%'
                        )  ,
                        Row(
                            mainAxisAlignment : MainAxisAlignment.center ,
                            children : [
                            Text(
                                (product.discount != 0.0)
                                ? '€ ${double.parse((product.price! * (product.quantity ) * (1 - (product.reservation ? (product.reservationP) : 0) )  * (1 + (product.delivery && !product.reservation ? (product.deliveryP) : 0 )) * (1 - product.discount)).toStringAsFixed(2))}'
                                : '€ ${double.parse((product.price! * (product.quantity ) * (1 - (product.reservation ? (product.reservationP) : 0) )  * (1 + (product.delivery && !product.reservation ? (product.deliveryP) : 0) )  * (1)).toStringAsFixed(2))}',
                                style: TextStyle(
                                        fontFamily: 'Nunito',
                                        color: Color(0xFF136DA5),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600
                                        ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                                
                            ]),
                        
                ]
            )
            
        ));
  }
}
