import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/ui/pages/authentication_pages/authentication_pages.dart';
import 'package:proximity_client/ui/pages/product_pages/product_pages.dart';
import 'package:proximity_client/ui/pages/store_pages/store_pages.dart';
import 'package:proximity_client/domain/product_repository/product_repository.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    /// a boolean to help fetch data ONLY if necessary
    bool didFetch = true;

    return Consumer<ProductService>(builder: (context, productService, child) {
      Product product =
          productService.products.firstWhere((element) => element.id == id);

      /// Do a getShop if necessary
      didFetch = product.allFetched();
      if (!didFetch) {
        productService.getProduct(id);
        product =
            productService.products.firstWhere((element) => element.id == id);
      }

      return Scaffold(
          body: Stack(alignment: Alignment.bottomCenter, children: [
        ListView(children: [
          ProductImageCarousel(id: id, images: product.images!),
          if (product.tags != null && product.tags!.isNotEmpty)
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: small_100),
                child: Wrap(
                    spacing: small_100,
                    runSpacing: 0,
                    children: product.tags!
                        .map((item) => Chip(
                            label: Text(item,
                                style: Theme.of(context).textTheme.bodyText2)))
                        .toList())),
          ProductDetailsSection(
              name: product.name!,
              price: product.price!,
              discount: product.discount),
          ProductVariantsSection(id: id, productVariants: product.variants!),
          ProductDescription(description: product.description!),
          // policy section
          SectionDivider(
              leadIcon: ProximityIcons.policy,
              title: 'policy de livraison et de retours .',
              color: Theme.of(context).primaryColor),
          // MasonryGrid(
          PolicyCard(
            leadIcon: ProximityIcons.shipping,
            title: "Shipping",
            subTitle:
                "Estimated delivery time is [X] days. Shipping fees will apply and will be calculated at checkout based on your location",
          ),

          PolicyCard(
            leadIcon: ProximityIcons.self_pickup,
            title: "Pick UP",
            subTitle:
                "You're just [X] days away from getting your hands on it. Remember to pick up your order from our store within [X] days, or it will be returned to the shelves. Don't miss out on the chance to make it yours!.",
          ),
          PolicyCard(
            leadIcon: Icons.book_online,
            title: "Reservation",
            subTitle:
                "A deposit of [X] may be required to secure your reservation.Once your reservation is confirmed, you may pick up your item at our store on the date specified in your reservation confirmation.",
          ),

          PolicyCard(
            leadIcon: Icons.settings_backup_restore,
            title: "Return and Refund  ",
            subTitle:
                "You may return your item within [X] days of receipt for a refund, provided that the item is in its original condition and with all tags attached. Please note that all sales are final for items marked as 'final sale. ",
          ),

          /// Store Section

          StoreSection(idStore: product.storeId!),

          /// Similar Products Section
          SectionDivider(
              leadIcon: ProximityIcons.product,
              title: 'Similar Products.',
              color: Theme.of(context).primaryColor),
          // MasonryGrid(
          //     column: 2,
          //     padding: const EdgeInsets.symmetric(horizontal: small_100),
          //     children: List.generate(
          //         5,
          //         (i) => ProductCard(
          //             product: Product(
          //                 id: '0',
          //                 name: '87 Keys K16 Gaming Mouse Precision',
          //                 description: null,
          //                 price: 99.99,
          //                 discountEndDate: DateTime.now().add(const Duration(
          //                     days: 31, hours: 23, minutes: 48, seconds: 3)),
          //                 images: ['assets/img/products/product-${i + 1}.png'],
          //                 variants: [ProductVariant()])))),
          const SizedBox(height: huge_200)
        ]),
        BottomActionsBar(buttons: [
          PrimaryButton(
              onPressed: () => showProductModal(context, product.id!),
              title: 'Add to Cart.'),
          SecondaryButton(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                  (Route<dynamic> route) => true),
              title: 'Buy Now.')
        ])
      ]));
    });
  }
}

class PolicyCard extends StatelessWidget {
  PolicyCard(
      {Key? key,
      required this.leadIcon,
      required this.title,
      required this.subTitle})
      : super(key: key);
  final IconData leadIcon;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        leadIcon,
        color: Theme.of(context).disabledColor,
      ),
      title: Text(title,
          style: Theme.of(context).textTheme.bodyLarge!,
          textAlign: TextAlign.start),
      subtitle: Text(subTitle, style: Theme.of(context).textTheme.bodyText2),
    );
  }
}
