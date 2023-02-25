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

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    /// a boolean to help fetch data ONLY if necessary
    bool didFetch = true;
    var credentialsBox = Boxes.getCredentials();
    String? _token = credentialsBox.get('token');
    
    final cartService = Provider.of<CartService>(context);
    final storeService = Provider.of<StoreService>(context);

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
              onPressed: () =>{
                  if(_token != null) {
                    if(storeService.store != null) {
                        cartService.addToCart(
                                      context,
                                      product,
                                      product.variants![0],
                                      storeService.store,
                                      1 , 
                                      noredirection: 1 )  
                    } 


                  }else {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => SignupScreen()),
                          (Route<dynamic> route) => true) 
                  }
                }
                  ,
              title: 'Buy Now.')
        ])
      ]));
    });
  }
}
