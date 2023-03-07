import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/ui/pages/product_pages/product_pages.dart';
import 'package:proximity_client/ui/pages/store_pages/store_pages.dart';
import 'package:proximity_client/domain/store_repository/store_repository.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// a boolean to help fetch data ONLY if necessary
    bool didFetch = true;

    return Consumer<StoreService>(builder: (context, storeService, child) {
      /// Do a getShop if necessary
      didFetch = storeService.store!.allFetched();
      if (!didFetch) storeService.getStore();

      return Scaffold(
          body: ListView(children: [
        StoreMap(address: storeService.store!.address!),
        StoreDetails(
            name: storeService.store!.name!,
            rating: storeService.store!.rating!),
        StoreDescription(description: storeService.store!.description!),

        /// StoreProducts
        SectionDivider(
            leadIcon: ProximityIcons.product,
            title: 'Store Products.',
            color: Theme.of(context).primaryColor),
        (storeService.products == null)
            ? const ProductCardsSkeleton()
            : MasonryGrid(
                column: 2,
                padding: const EdgeInsets.symmetric(horizontal: small_100),
                children: List.generate(storeService.products!.length,
                    (i) => ProductCard(product: storeService.products![i]))),
        const SizedBox(height: huge_200),
        SectionDivider(
            leadIcon: ProximityIcons.policy,
            title: 'Store Policy.',
            color: Theme.of(context).primaryColor),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RichText(
                maxLines: 2,
                textAlign: TextAlign.start,
                text: TextSpan(children: [
                  TextSpan(
                      text: '€ Shipping :               ',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: small_50,
                          decorationColor: redSwatch.shade500)),
                  TextSpan(
                      text: '12 ',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(fontWeight: FontWeight.bold))
                ]),
                overflow: TextOverflow.fade),
            const Expanded(child: Divider(height: tiny_50, thickness: tiny_50)),
            RichText(
                maxLines: 2,
                textAlign: TextAlign.start,
                text: TextSpan(children: [
                  TextSpan(
                      text: '€ Reservation :               ',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          //  decoration: TextDecoration.lineThrough,
                          decorationThickness: small_50,
                          decorationColor: redSwatch.shade500)),
                  TextSpan(
                      text: '30 % ',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(fontWeight: FontWeight.bold))
                ]),
                overflow: TextOverflow.fade),
            const Expanded(child: Divider(height: tiny_50, thickness: tiny_50)),
            RichText(
                maxLines: 2,
                textAlign: TextAlign.start,
                text: TextSpan(children: [
                  TextSpan(
                      text: 'Reservation :               ',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          // decoration: TextDecoration.lineThrough,
                          decorationThickness: small_50,
                          decorationColor: redSwatch.shade500)),
                  TextSpan(
                      text: '30 %',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(fontWeight: FontWeight.bold))
                ]),
                overflow: TextOverflow.fade),
            const Expanded(child: Divider(height: tiny_50, thickness: tiny_50)),
          ],
        )
        /*(storeService.products == null)
            ? const ProductCardsSkeleton()
            : MasonryGrid(
                column: 2,
                padding: const EdgeInsets.symmetric(horizontal: small_100),
                children: List.generate(storeService.products!.length,
                    (i) => ProductCard(product: storeService.products![i]))),
        const SizedBox(height: huge_200),*/
      ]));
    });
  }
}
