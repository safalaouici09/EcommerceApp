import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity/widgets/forms/edit_text_spacer.dart';
import 'package:proximity_commercant/ui/pages/product_pages/product_pages.dart';
import 'package:proximity_commercant/domain/product_repository/product_repository.dart';
import 'package:proximity_commercant/ui/pages/product_pages/widgets/datePicker.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    /// a boolean to help fetch data ONLY if necessary
    bool didFetch = true;
    //todo :  final productService = Provider.of<ProductService>(context);
    // productService.getOffer(id);

    return Consumer2<ProductService, ProductCreationValidation>(
        builder: (context, productService, productCreationValidation, child) {
      Product product =
          productService.products!.firstWhere((element) => element.id == id);
      int index =
          productService.products!.indexWhere((element) => element.id == id);
      //productService.getOffer(id);

      /// Do a getShop if necessary

      didFetch = product.allFetched();
      if (!didFetch) {
        product =
            productService.products!.firstWhere((element) => element.id == id);
        //print("prod" + product.policy!.toJson().toString());
      }

      return Scaffold(
          body: Stack(alignment: Alignment.bottomCenter, children: [
        ListView(children: [
          ProductImageCarousel(id: id, images: product.images),
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
          const SizedBox(height: normal_100),
          Padding(
              padding: const EdgeInsets.all(normal_100).copyWith(top: 0),
              child: SecondaryButton(
                  title: 'Edit Product.',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductCreationScreen(
                                product: product,
                                index: index,
                                editScreen: true)));
                  })),
          Row(children: [
            const SizedBox(width: normal_100),
            Expanded(
                child: SecondaryButton(
                    title: 'Promote.',
                    onPressed: () {
                      !productService.loading
                          ? offerDialog(context, productService, product, index)
                              .then((val) {})
                          : CircularProgressIndicator();
                    })),
            const SizedBox(width: normal_100),
            Expanded(
                child: SecondaryButton(
                    title: 'Delete.',
                    onPressed: () {
                      ProductDialogs.deleteProduct(context, id);
                    })),
            const SizedBox(width: normal_100),
          ]),
          ProductVariantsSection(id: id, productVariants: product.variants!),
          ProductDescription(description: product.description!),
          const SizedBox(height: huge_200)
        ])
      ]));
    });
  }

  Future<dynamic> offerDialog(BuildContext context,
      ProductService productService, Product product, int index) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Promote this product.',
                  style: Theme.of(context).textTheme.subtitle2),
              content: Container(
                height: 200,
                child: Column(
                  children: [
                    DropDownSelector<String>(
                      // labelText: 'Product Category.',
                      hintText: 'Discount .',
                      onChanged: productService.changeDiscountAmount,
                      borderType: BorderType.middle,
                      savedValue: productService.discountAmount.toString(),
                      items: percentageValues.entries
                          .map((item) => DropdownItem<String>(
                              value: item.key,
                              child: Text(item.value,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(fontWeight: FontWeight.w600))))
                          .toList(),
                    ),
                    EditTextSpacer(),
                    EditText(
                      hintText: 'Offer Stock. ',
                      keyboardType: TextInputType.number,
                      saved: (productService.offerStock == null)
                          ? ""
                          : productService.offerStock.toString(),
                      //   enabled:
                      // (store.policy == null) || editScreen,
                      onChanged: productService.changeOfferStock,
                    ),
                    EditTextSpacer(),
                    DateInput(),

                    /*   Row(
                      children: [
                        EditText(
                            hintText: "Offer Expiration Date .",
                            suffixIcon: Icons.calendar_month_outlined,
                            suffixOnPressed: () =>
                                productService.changeOfferExpirationDate(),
                            saved: productService.formattedDate,

                            // onChanged: ( DateTime value) => ,

                            borderType: BorderType.bottom),
                      ],
                    ),*/
                  ],
                ),
              ),
              actions: [
                TertiaryButton(
                    onPressed: () async {
                      if (product.offer_id == null) {
                        await productService.createOffer(
                            context, productService.toFormData(), id);
                        await productService.editProductDiscount(
                            context, index, productService.discountAmount);
                      } else {
                        await productService.archiveOffer(product.offer_id!);
                        await productService.editProductDiscount(
                            context, index, 0);
                      }

                      Navigator.pop(context);
                    },
                    title: product.offer_id == null ? 'submit' : 'archive'),
                //      title: /*product.offer_id == null ? 'Submit' : 'archiver'),
                if (product.offer_id != null)
                  TertiaryButton(
                      onPressed: () async {
                        /*  productService.updateOffer(
                                                productService.toFormData());*/
                        await productService.editProductDiscount(
                            context, index, productService.discountAmount);

                        Navigator.pop(context);
                      },
                      title: 'update')
              ],
            ));
  }
}
