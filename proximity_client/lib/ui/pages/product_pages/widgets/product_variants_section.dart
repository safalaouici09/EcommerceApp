import 'dart:io';

import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/product_repository/product_repository.dart';
import 'package:proximity_client/ui/pages/product_pages/product_pages.dart';

class ProductVariantsSection extends StatelessWidget {
  const ProductVariantsSection(
      {Key? key, required this.id, required this.productVariants})
      : super(key: key);

  final String id;
  final List<ProductVariant> productVariants;

  @override
  Widget build(BuildContext context) {
    double _cardSize = (MediaQuery.of(context).size.width - normal_100 * 5) / 4;
    return Column(children: [
      SectionDivider(
          leadIcon: ProximityIcons.product,
          title: 'Product Variants.',
          color: Theme.of(context).primaryColor),
      Row(
          children: List.generate(
              (productVariants.length < 4) ? productVariants.length : 4,
              (index) => GestureDetector(
                  onTap: () => showProductModal(context, id,
                      variantId: productVariants[index].id),
                  child: Container(
                      height: _cardSize,
                      width: _cardSize,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(smallRadius),
                        border: Border.all(
                            color: Theme.of(context).dividerColor,
                            width: tiny_50)
                      ),
                      margin: (index == 0)
                          ? const EdgeInsets.only(
                              left: normal_100, right: small_100)
                          : (index == 4)
                              ? const EdgeInsets.only(
                                  left: small_100, right: normal_100)
                              : const EdgeInsets.symmetric(
                                  horizontal: small_100),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.vertical(top: smallRadius),
                        child: Stack(children: [
                          (productVariants[index].image! is File)
                              ? Image.file(productVariants[index].image!)
                              : Image.network(productVariants[index].image!,
                                  errorBuilder: (
                                  BuildContext context,
                                  Object error,
                                  StackTrace? stackTrace,
                                ) {
                                  return const AspectRatio(
                                      aspectRatio: 1.0,
                                      child: SizedBox(
                                          width: large_100, height: large_100));
                                }),
                          if (index == 3 && productVariants.length > 4)
                            Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .backgroundColor
                                        .withOpacity(0.9),
                                    borderRadius: const BorderRadius.all(
                                        innerBorderRadius)),
                                child: Text(
                                    '${productVariants.length - 3} more Variants',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                    textAlign: TextAlign.center))
                        ]),
                      )))))
    ]);
  }
}
