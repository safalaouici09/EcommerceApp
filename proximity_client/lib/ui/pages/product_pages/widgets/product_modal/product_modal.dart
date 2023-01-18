import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/cart_repository/cart_repository.dart';
import 'package:proximity_client/domain/product_repository/product_repository.dart';
import 'package:proximity_client/domain/store_repository/store_repository.dart';
import 'package:proximity_client/ui/pages/product_pages/widgets/product_modal/product_variant_card.dart';
import 'package:proximity_client/ui/pages/product_pages/widgets/product_modal/product_variant_characteristics.dart';

class ProductModal extends StatefulWidget {
  const ProductModal({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<ProductModal> createState() => _ProductModalState();
}

class _ProductModalState extends State<ProductModal> {
  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);
    final productModalController = Provider.of<ProductModalController>(context);

    /// cartProvider to add the product to cart
    final cartService = Provider.of<CartService>(context);

    final Product _product = productService.products
        .firstWhere((element) => element.id == widget.id);
    final ProductVariant? _selectedVariant =
        (productModalController.productVariantId == null)
            ? null
            : _product.variants!.firstWhere((element) =>
                element.id == productModalController.productVariantId);

    return Stack(children: [
      Container(
          height: double.infinity,
          width: double.infinity,
          margin: const EdgeInsets.only(top: normal_200),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(
                  color: Theme.of(context).dividerColor, width: tiny_50),
              borderRadius: const BorderRadius.vertical(top: smallRadius)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Expanded(
                child:
                    ListView(physics: const BouncingScrollPhysics(), children: [
              Container(
                  height: huge_100 - normal_200,
                  padding: const EdgeInsets.all(small_100),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: huge_100 + normal_100),
                        Expanded(
                            child: RichText(
                                text: TextSpan(children: [
                          TextSpan(
                              text: (productModalController.productVariantId == null)
                                  ? '€--' : '€ ${_selectedVariant!.getPrice(_product.discount)} ',
                              style: Theme.of(context).textTheme.headline4),
                          TextSpan(
                              text: '/ Piece',
                              style: Theme.of(context).textTheme.bodyText2)
                        ]))),
                        SmallIconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(ProximityIcons.remove))
                      ])),
              const SizedBox(height: small_100),
              (productModalController.productVariantId == null)
                  ? const SizedBox()
                  : ProductVariantCharacteristics(
                      characteristics: _selectedVariant!.characteristics!),
              const SizedBox(height: small_100),
              GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: normal_100,
                    mainAxisSpacing: normal_100,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: normal_100),
                  children: List.generate(
                      _product.variants!.length,
                      (index) => ProductVariantCard(
                          selected: _product.variants![index].id ==
                              productModalController.productVariantId,
                          onChanged: () => productModalController
                              .selectVariant(_product.variants![index].id!),
                          image: _product.variants![index].image!))),

              /// Quantity Section
              SectionDivider(
                  leadIcon: ProximityIcons.quantity,
                  title: 'Quantity.',
                  color: Theme.of(context).primaryColor),                
              if (productModalController.productVariantId != null)
                QuantitySelector(
                  quantity: productModalController.quantity,
                  maxQuantity: _selectedVariant!.quantity,
                  increaseQuantity: productModalController.increaseQuantity,
                  decreaseQuantity: productModalController.decreaseQuantity),

              /// Store Policy Section
              Consumer<StoreService>(
                builder: (context, storeService, _) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    /// Store Policy Section
                    if (storeService.store != null)
                      if (storeService.store!.policy != null) ...[
                        SectionDivider(
                            leadIcon: ProximityIcons.policy,
                            title: 'Store Policy.',
                            color: Theme.of(context).primaryColor),
                        if (storeService.store!.policy!.shippingMethods!
                            .contains(ShippingMethod.delivery))
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: small_100),
                              child: Row(children: [
                                Text('-',
                                    style: Theme.of(context).textTheme.bodyText1),
                                const Icon(ProximityIcons.delivery),
                                Text(
                                    'Delivery Option with a ${storeService.store!.policy!.tax} € fee.',
                                    style:
                                        Theme.of(context).textTheme.bodyText1)
                              ])),
                        if (storeService.store!.policy!.shippingMethods!
                            .contains(ShippingMethod.selfPickupTotal))
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: small_100),
                              child: Row(children: [
                                Text('-',
                                    style: Theme.of(context).textTheme.bodyText1),
                                const Icon(ProximityIcons.self_pickup),
                                Text(
                                    'SelfPickup Option with a ${storeService.store!.policy!.selfPickUpPrice} € fee.',
                                    style:
                                        Theme.of(context).textTheme.bodyText1)
                              ]))
                        else if (storeService.store!.policy!.shippingMethods!
                            .contains(ShippingMethod.selfPickupPartial))
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: small_100),
                              child: Row(children: [
                                Text('-',
                                    style: Theme.of(context).textTheme.bodyText1),
                                const Icon(ProximityIcons.self_pickup),
                                Text(
                                    'SelfPickup Option with a ${storeService.store!.policy!.selfPickUpPrice} € fee.',
                                    style:
                                        Theme.of(context).textTheme.bodyText1)
                              ]))
                        else if (storeService.store!.policy!.shippingMethods!
                            .contains(ShippingMethod.selfPickupTotal))
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: small_100),
                              child: Row(children: [
                                const Icon(ProximityIcons.self_pickup),
                                Text('SelfPickup Option with no tax.',
                                    style:
                                        Theme.of(context).textTheme.bodyText1)
                              ]))
                      ]
                  ]);
                },
              )
            ])),
            Consumer<StoreService>(
                builder: (context, storeService, _) =>
                    BottomActionsBar(buttons: [
                      PrimaryButton(
                          onPressed: (productModalController.valid() &&
                                  storeService.store != null)
                              ? () => cartService.addToCart(
                                  context,
                                  _product,
                                  _selectedVariant!,
                                  storeService.store!,
                                  productModalController.quantity)
                              : null,
                          title: 'Continue.')
                    ]))
          ])),
      Container(
          height: huge_100,
          width: huge_100,
          margin: const EdgeInsets.only(left: normal_100),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              image: DecorationImage(
                  image: NetworkImage(
                      (productModalController.productVariantId == null)
                          ? _product.images!.first
                          : _selectedVariant!.image!)),
              border: Border.all(
                  color: Theme.of(context).dividerColor, width: tiny_50),
              borderRadius: const BorderRadius.all(smallRadius)))
    ]);
  }
}
