import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/product_repository/product_repository.dart';
import 'package:proximity_client/ui/pages/main_pages/main_pages.dart';
import 'package:proximity_client/ui/pages/main_pages/view/notifications_screen.dart';
import 'package:proximity_client/ui/pages/product_pages/product_pages.dart';

class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductService>(builder: (_, productService, __) {
      return Scaffold(
        body: ListView(children: [
          const HomeTabBar(),
          const SearchBar(),

          /// Ad Section
          productService.ads.isEmpty
              ? const AdSectionSkeleton()
              : AdSection(ads: productService.ads),

          /// Today's Deals
          SectionDivider(
              leadIcon: ProximityIcons.flashdeal,
              title: "Today's Deals",
              color: yellowSwatch.shade600,
              seeMore: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TodayDealsScreen()));
              }),
          SizedBox(
              height: huge_100,
              child: (productService.loadingdealsList == true)
                  ? const SmallProductCardsSkeleton()
                  : productService.todayDeals.isEmpty
                      ? Center(
                          child: InkWell(
                          onTap: () {
                            productService.getTodayDeals();
                          },
                          child: Icon(Icons.refresh),
                        ))
                      : ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: normal_150),
                          children: List.generate(
                              productService.todayDeals.length,
                              (i) => SmallProductCard(
                                  product: productService.todayDeals[i])))),

          /// Products Around You
          SectionDivider(
              leadIcon: ProximityIcons.product,
              title: 'Products Around You',
              color: greenSwatch.shade300),
          (productService.loadingProductList == true)
              ? const ProductCardsSkeleton()
              : productService.products.isEmpty
                  ? Center(
                      child: InkWell(
                      onTap: () {
                        productService.getProximityProducts();
                      },
                      child: Icon(Icons.refresh),
                    ))
                  : MasonryGrid(
                      column: 2,
                      padding:
                          const EdgeInsets.symmetric(horizontal: small_100),
                      children: List.generate(
                          productService.products.length,
                          (i) => ProductCard(
                              product: productService.products[i]))),
          const SizedBox(height: large_200)
        ]),
      );
    });
  }
}
