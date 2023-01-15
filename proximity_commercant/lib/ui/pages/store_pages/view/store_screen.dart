import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_commercant/ui/pages/store_pages/store_pages.dart';
import 'package:proximity_commercant/ui/pages/product_pages/product_pages.dart';
import 'package:proximity_commercant/domain/store_repository/store_repository.dart';
import 'package:proximity_commercant/domain/product_repository/product_repository.dart';
import 'dart:developer';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  late ScrollController _controller;
  bool reachedEnd = false;

  /// a boolean to help fetch data ONLY if necessary
  bool didFetch = true;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        setState(() {
          reachedEnd = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreService>(builder: (context, storeService, child) {
      Store store =
          storeService.stores!.firstWhere((element) => element.id == widget.id);
      int index =
      storeService.stores!.indexWhere((element) => element.id == widget.id);
      

      /// Do a getShop if necessary
      didFetch = store.allFetched();
      if (!didFetch) {
        storeService.getStoreById(widget.id);
        store = storeService.stores!
            .firstWhere((element) => element.id == widget.id);
      }
      log('data: $store');
      return Scaffold(
          body: ListView(children: [
        StoreMap(address: store.address!),
        StoreDetails(
            name: store.name!,
            rating: store.rating!,
            image: store.image,
            followers: store.followers!.length),
        Row(children: [
          const SizedBox(width: normal_100),
          Expanded(
              child: SecondaryButton(
                  title: 'Edit Shop.',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                StoreEditScreen(index: index, store: store)));
                  })),
          const SizedBox(width: normal_100),
          Expanded(
              child: SecondaryButton(
                  title: 'Promote.',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                StoreEditScreen(index: index, store: store)));
                  })),
          const SizedBox(width: normal_100),
        ]),
        StoreDescription(description: store.description!),

        /// StoreProducts
        SectionDivider(
            leadIcon: ProximityIcons.product,
            title: 'Store Products.',
            color: Theme.of(context).primaryColor),
        Consumer<ProductService>(builder: (_, productService, __) {
          // if (productService.fetchMore && reachedEnd) {
          //   productService.getStoreProducts();
          //   reachedEnd = false;
          // }
          return Column(children: [
            /// Scroll Tab Bar to select a Product Category
            ScrollTabBar(
              tabs: [
                ScrollTab(name: "All Products", onPressed: () {}),
                if (store.categories != null)
                  ...store.categories!
                      .map((item) =>
                          ScrollTab(name: item.name!, onPressed: () {}))
                      .toList(),
              ],
            ),
            if (productService.products == null)
              const Center(child: CircularProgressIndicator())
            else
              MasonryGrid(
                  padding: const EdgeInsets.symmetric(
                      vertical: normal_100, horizontal: small_100),
                  column: 2,
                  children: [
                    const ProductCreationButton(),
                    ...List.generate(
                        productService.products!.length,
                        (index) => ProductCard(
                            product: productService.products![index]))
                  ])
          ]);
        })
      ]));
    });
  }
}
