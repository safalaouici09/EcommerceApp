import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/ui/pages/authentication_pages/authentication_pages.dart';
import 'package:proximity_client/ui/pages/product_pages/product_pages.dart';
import 'package:proximity_client/ui/pages/store_pages/store_pages.dart';
import 'package:proximity_client/domain/product_repository/product_repository.dart';
import 'package:proximity_client/domain/data_persistence/data_persistence.dart';
import 'package:proximity_client/ui/pages/main_pages/view/cart_tab_screen.dart';
import 'package:proximity_client/domain/store_repository/store_repository.dart';
import 'package:proximity_client/domain/cart_repository/cart_repository.dart';
import 'package:proximity_client/ui/pages/product_pages/widgets/product_modal/product_variant_card.dart';
import 'package:proximity_client/ui/pages/product_pages/widgets/product_modal/product_variant_characteristics.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key, required this.id}) : super(key: key);

  final String id;
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _isExpanded = false;
  String id = "";
  @override
  void initState() {
    id = widget.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// a boolean to help fetch data ONLY if necessary
    var credentialsBox = Boxes.getCredentials();
    String? _token = credentialsBox.get('token');

    final cartService = Provider.of<CartService>(context);
    final storeService = Provider.of<StoreService>(context);
    // final productModalController = Provider.of<ProductModalController>(context);
    var didFetch = false;
    return Consumer<ProductService>(builder: (context, productService, child) {
      Product product = productService.products
              .firstWhere((element) => element.id == widget.id) ??
          productService.products[0] ??
          Product();

      /// Do a getShop if necessary
      if (!didFetch) {
        productService.getProduct(widget.id);
        product = productService.products
            .firstWhere((element) => element.id == widget.id);
        didFetch = true;
      }

      return Scaffold(
          body: Stack(alignment: Alignment.bottomCenter, children: [
        if (productService.loadingProduct == true)
          const Expanded(child: Center(child: CircularProgressIndicator())),
        if (productService.loadingProduct == false &&
            didFetch == true &&
            productService.products
                    .firstWhere((element) => element.id == widget.id) ==
                -1)
          Expanded(
              child: Center(
                  child: InkWell(
            onTap: () {
              productService.getProduct(widget.id);
            },
            child: Icon(Icons.refresh),
          ))),
        if (didFetch == true &&
            productService.loadingProduct == false &&
            product != -1)
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
                                  style:
                                      Theme.of(context).textTheme.bodyText2)))
                          .toList())),
            ProductDetailsSection(
                name: product.name!,
                price: product.price!,
                discount: product.discount),
            // ProductVariantsSection(id: id, productVariants: product.variants!),
            productService.getCharacteristics(product) != null
                ? ProductVariantCharacteristics(
                    characteristics:
                        productService.getCharacteristics(product)!)
                : Container(),
            const SizedBox(height: small_100),
            /*(productModalController.productVariantId == null)
                  ? const SizedBox()
                  :*/

            Consumer<ProductService>(builder: (_, productService, __) {
              return product.variants != null
                  ? GridView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: normal_100,
                        mainAxisSpacing: normal_100,
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: normal_100),
                      children: List.generate(
                          productService
                              .filterVariants(
                                product.variants!,
                              )
                              .length,
                          (index) => ProductVariantCard(
                              selected: product.variants!
                                  .where((el) => (el.id ==
                                      productService
                                          .filterVariants(
                                            product.variants!,
                                          )![index]
                                          .id))
                                  .isNotEmpty,
                              onChanged: () => {},
                              image: productService
                                  .filterVariants(
                                    product.variants!,
                                  )![index]
                                  .image!)))
                  : Container();
            }),
            ProductDescription(description: product.description!),
            // policy section
            SectionDivider(
                leadIcon: ProximityIcons.policy,
                title: 'policy de livraison et de retours .',
                color: Theme.of(context).primaryColor),
            // MasonryGrid(
            //delivery policy
            product.policy!.deliveryPolicy != null
                ? PolicyCard(
                    leadIcon: ProximityIcons.shipping,
                    title: "Shipping",
                    subTitle:
                        "Estimated delivery time is  days. Shipping fees will negociate for this product",
                  )
                : Container(),

            // pickup policy
            product.policy!.pickupPolicy != null &&
                    product.policy!.pickupPolicy!.timeLimit != null
                ? PolicyCard(
                    leadIcon: ProximityIcons.self_pickup,
                    title: "Pick UP",
                    subTitle:
                        "Remember to pick up your order from our store within ${product.policy!.pickupPolicy!.timeLimit} days, or it will be returned to the shelves. Don't miss out on the chance to make it yours!.",
                  )
                : Container(),

            // Return  Policy
            product.policy!.returnPolicy != null
                ? product.policy!.returnPolicy!.refund!.shipping != null &&
                        product.policy!.returnPolicy!.refund!.order != null
                    ? PolicyCard(
                        leadIcon: Icons.settings_backup_restore,
                        title: "Return and Refund  ",
                        subTitle:
                            "You may return your item within${product.policy!.returnPolicy!.duration} days of receipt for a refund, provided that the item is${product.policy!.returnPolicy!.productStatus}. in case the return is accepted , the store will refund shipping fees and ${product.policy!.returnPolicy!.refund!.order.fixe} % of the price  ",
                      )
                    : product.policy!.returnPolicy!.refund!.shipping == null &&
                            product.policy!.returnPolicy!.refund!.order != null
                        ? PolicyCard(
                            leadIcon: Icons.settings_backup_restore,
                            title: "Return and Refund  ",
                            subTitle:
                                "You may return your item within${product.policy!.returnPolicy!.duration} days of receipt for a refund, provided that the item is${product.policy!.returnPolicy!.productStatus}. in case the return is accepted , the store will refund ${product.policy!.returnPolicy!.refund!.order.fixe} % of the price , shipping fees are not refunded ",
                          )
                        : product.policy!.returnPolicy!.refund!.shipping !=
                                    null &&
                                product.policy!.returnPolicy!.refund!.order ==
                                    null
                            ? PolicyCard(
                                leadIcon: Icons.settings_backup_restore,
                                title: "Return and Refund  ",
                                subTitle:
                                    "You may return your item within${product.policy!.returnPolicy!.duration} days of receipt for a refund, provided that the item is${product.policy!.returnPolicy!.productStatus}. in case the return is accepted , the store will refund shipping fees ",
                              )
                            : Container()
                : Container(),

            /// Store Section

            StoreSection(
              idStore: product.storeId!,
              productPageContext: context,
            ),

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
        if (didFetch == true &&
            productService.loadingProduct == false &&
            productService.products
                    .firstWhere((element) => element.id == widget.id) !=
                -1)
          BottomActionsBar(buttons: [
            PrimaryButton(
                onPressed: () => showProductModal(context, product.id!),
                title: 'Add to Cart.'),
            SecondaryButton(
                onPressed: () => {
                      if (_token != null)
                        {
                          if (storeService.store != null && product != null)
                            {
                              cartService.addToCart(context, product,
                                  product.variants![0], storeService.store, 1,
                                  noredirection: 1)
                            }
                        }
                      else
                        {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => SignupScreen()),
                              (Route<dynamic> route) => true)
                        }
                    },
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
