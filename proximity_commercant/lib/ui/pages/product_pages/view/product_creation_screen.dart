import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_commercant/domain/product_repository/product_repository.dart';
import 'package:proximity_commercant/domain/store_repository/store_repository.dart';
import 'package:proximity_commercant/ui/pages/product_pages/product_pages.dart';

class ProductCreationScreen extends StatelessWidget {
  const ProductCreationScreen(
      {Key? key, this.index, required this.product, this.editScreen = false})
      : super(key: key);

  final int? index;
  final Product product;
  final bool editScreen;

  @override
  Widget build(BuildContext context) {
    /// a boolean to help fetch data ONLY if necessary
    bool didFetch = true;

    return ChangeNotifierProvider<ProductCreationValidation>(
        create: (context) => ProductCreationValidation.setProduct(product),
        child: Consumer2<ProductCreationValidation, ProductService>(builder:
            (context, productCreationValidation, productService, child) {
          /// first check if [index] is null or not
          /// if it is null then it's a ShopAddingScreen, so no need to fetch data
          /// to edit it, and no need for a loading screen
          ///
          /// otherwise we need to check if we already fetched the data and then
          /// proceed with the rendering
          ///
          if (index != null) {
            didFetch = productService.products![index!].allFetched();
            if (!didFetch) productService.getProductByIndex(index!);
          }
          return Scaffold(
              body: SafeArea(
                  child: Stack(alignment: Alignment.bottomCenter, children: [
            ListView(children: [
              const TopBar(title: 'Create a new Product.'),

              /// Store Name
              SectionDivider(
                  leadIcon: ProximityIcons.store,
                  title: 'Store.',
                  color: redSwatch.shade500),
              Selector<StoreService, String?>(
                  selector: (_, storeService) =>
                      storeService.getStoreById(product.storeId!).name,
                  builder: (context, storeName, child) {
                    return EditText(
                        hintText: 'Shop name.',
                        saved: storeName,
                        enabled: false);
                  }),

              /// Product Details
              SectionDivider(
                  leadIcon: ProximityIcons.edit,
                  title: 'Product details.',
                  color: redSwatch.shade500),
              RichEditText(children: [
                EditText(
                  hintText: 'Name.',
                  borderType: BorderType.top,
                  saved: productCreationValidation.name.value,
                  errorText: productCreationValidation.name.error,
                  enabled: (product.name == null) || editScreen,
                  onChanged: productCreationValidation.changeName,
                ),
                EditText(
                  hintText: 'Product Description.',
                  borderType: BorderType.bottom,
                  saved: productCreationValidation.description.value,
                  errorText: productCreationValidation.description.error,
                  maxLines: 5,
                  enabled: (product.description == null) || editScreen,
                  onChanged: productCreationValidation.changeDescription,
                )
              ]),

              const InfoMessage(
                message: 'Each Product should fit in one category, ',
              ),
              Selector<StoreService, List<Category>?>(
                  selector: (_, storeService) =>
                      storeService.getStoreById(product.storeId!).categories,
                  builder: (context, categories, child) {
                    return DropDownSelector<String>(
                        hintText: 'Select a Category.',
                        savedValue: productCreationValidation.category.value,
                        onChanged: productCreationValidation.changeCategory,
                        items: categories!
                            .map((item) => DropdownItem<String>(
                                value: item.id!,
                                child: Text("${item.name}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(
                                            fontWeight: FontWeight.w600))))
                            .toList());
                  }),

              /// Error Messages
              const SizedBox(height: small_100),
              ErrorMessage(errors: [
                productCreationValidation.name.error,
                productCreationValidation.description.error
              ]),

              /// You Offer (Price and Quantity)
              SectionDivider(
                  leadIcon: ProximityIcons.cart,
                  title: 'Your Offer.',
                  color: redSwatch.shade500),
              RichEditText(children: [
                EditText(
                    hintText: 'Base Price in €.',
                    borderType: BorderType.top,
                    saved: productCreationValidation.price.toString(),
                    enabled: (product.price == null) || editScreen,
                    onChanged: productCreationValidation.changePrice),
                EditText(
                    hintText: 'Base Quantity.',
                    borderType: BorderType.bottom,
                    saved: productCreationValidation.quantity.toString(),
                    enabled: (product.quantity == null) || editScreen,
                    onChanged: productCreationValidation.changeQuantity),
              ]),

              /// Product Variants
              SectionDivider(
                  leadIcon: ProximityIcons.product,
                  title: 'Variations.',
                  color: redSwatch.shade500),
              ListButton(
                  title: productCreationValidation.characteristicsTitle,
                  leadIcon: ProximityIcons.description,
                  onPressed: () async {
                    final Map<String, Set<String>>? newCharacteristics =
                        await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CharacteristicEditScreen(
                                            characteristics:
                                                productCreationValidation
                                                    .characteristics)))
                            as Map<String, Set<String>>?;
                    if (newCharacteristics != null) {
                      productCreationValidation
                          .changeCharacteristics(newCharacteristics);
                    }
                  }),
              VariantCreator(
                  productVariants: productCreationValidation.variants,
                  maxVariants: productCreationValidation.variantsMaxSize,
                  characteristics: productCreationValidation.characteristics,
                  onVariantAdded: productCreationValidation.addVariant,
                  onVariantRemoved: productCreationValidation.removeVariant),

              /// Image Picker
              SectionDivider(
                  leadIcon: ProximityIcons.picture,
                  title: 'Product Images.',
                  color: redSwatch.shade500),
              ImagePickerWidget(
                  images: productCreationValidation.images,
                  maxImages: 9,
                  onImageAdded: productCreationValidation.addProductImage,
                  onImageRemoved: productCreationValidation.removeProductImage),
              const SizedBox(height: huge_100)
            ]),
            BottomActionsBar(buttons: [
              PrimaryButton(
                  buttonState: productService.formsLoading
                      ? ButtonState.loading
                      : (productCreationValidation.isValid)
                          ? ButtonState.enabled
                          : ButtonState.disabled,
                  onPressed: () {
                    if (editScreen) {
                      productService.editProduct(context, index!,
                          productCreationValidation.toFormData());
                    } else {
                      productService.addProduct(
                          context, productCreationValidation.toFormData());
                    }
                  },
                  title: editScreen ? 'Update.' : 'Confirm.')
            ])
          ])));
        }));
  }
}
