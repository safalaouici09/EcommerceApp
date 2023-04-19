import 'package:flutter/material.dart';
import 'package:proximity_commercant/domain/order_repository/order_repository.dart';
import 'package:proximity_commercant/domain/product_repository/models/models.dart';
import 'package:proximity_commercant/ui/pages/product_pages/product_pages.dart';

class OrderItemTile extends ProductTile {
  OrderItemTile({
    Key? key,
    required OrderItem orderItem,
  }) : super(
            key: key,
            product: orderItem.toProduct(),
            productVariant: ProductVariant(
                id: orderItem.variantId,
                variantName: orderItem.variantName,
                characteristics: orderItem.characteristics,
                image: orderItem.image),
            bottomRightChild: Text('x${orderItem.orderedQuantity}'));
}
