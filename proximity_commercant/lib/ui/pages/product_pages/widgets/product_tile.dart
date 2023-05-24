import 'dart:io';

import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_commercant/domain/product_repository/product_repository.dart';

class ProductTile extends StatelessWidget {
  const ProductTile(
      {Key? key,
      this.onPressed,
      required this.product,
      required this.productVariant,
      this.rightChild,
      this.leftChild,
      this.bottomRightChild})
      : super(key: key);

  final VoidCallback? onPressed;
  final Product product;
  final ProductVariant productVariant;
  final Widget? leftChild;
  final Widget? rightChild;
  final Widget? bottomRightChild;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
                top: BorderSide(
              width: tiny_50,
              color: Theme.of(context).dividerColor,
            ))),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: onPressed,
                child: SizedBox(
                    height: huge_100,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (leftChild != null) ...[
                            leftChild!,
                            const SizedBox(width: small_100)
                          ],
                          /*  (productVariant.image! is File)
                              ? Image.file(productVariant.image!,
                              fit: BoxFit.cover,
                              width: huge_100,
                              height: huge_100)
                              : Image.network(productVariant.image!,
                              fit: BoxFit.cover,
                              width: huge_100,
                              height: huge_100, errorBuilder: (
                                  BuildContext context,
                                  Object error,
                                  StackTrace? stackTrace,
                                  ) {
                                return const AspectRatio(
                                    aspectRatio: 1.0,
                                    child: SizedBox(
                                        width: large_100, height: large_100));
                              }),*/
                          const VerticalDivider(width: tiny_50),
                          const SizedBox(width: small_100),
                          Expanded(
                              child: Container(
                                  height: huge_100,
                                  padding: const EdgeInsets.all(small_100),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                            child: Row(children: [
                                          Expanded(
                                              child: RichText(
                                                  text: TextSpan(children: [
                                                    TextSpan(
                                                        text:
                                                            '${product.name}\n',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .subtitle2),
                                                    TextSpan(
                                                        text:
                                                            '${productVariant.variantName}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption)
                                                  ]),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2)),
                                          if (rightChild != null) rightChild!
                                        ])),
                                        SizedBox(
                                            height: normal_225,
                                            child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Expanded(
                                                      child: RichText(
                                                          text: TextSpan(
                                                              children: [
                                                        TextSpan(
                                                            text: '€ ',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1),
                                                        TextSpan(
                                                            text:
                                                                '${product.getPrice()}',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline4)
                                                      ]))),
                                                  if (bottomRightChild != null)
                                                    bottomRightChild!
                                                ]))
                                      ])))
                        ])))));
  }
}
