import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity/widgets/forms/edit_text_spacer.dart';
import 'package:proximity_commercant/domain/product_repository/product_repository.dart';
import 'package:proximity_commercant/domain/store_repository/store_repository.dart';
import 'package:proximity_commercant/domain/user_repository/models/user_model.dart';
import 'package:proximity_commercant/domain/user_repository/src/user_service.dart';
import 'package:proximity_commercant/ui/pages/product_pages/product_pages.dart';
import 'package:proximity_commercant/ui/pages/store_pages/view/store_policy_screen.dart';

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
    bool showImagePicker = false;
    User? _user = context.watch<UserService>().user;

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
              editScreen
                  ? const TopBar(title: 'Update  Product.')
                  : const TopBar(title: 'Create a new Product.'),

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
              const InfoMessage(
                message:
                    'Every product must belong to a single category. Categorizing products accurately for better promotion and visibility. ',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: normal_100),
                child: Selector<StoreService, List<Category>?>(
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
              ),
              const EditTextSpacer(),
              EditText(
                hintText: 'Name.',
                borderType: BorderType.middle,
                saved: productCreationValidation.name.value,
                errorText: productCreationValidation.name.error,
                enabled: (product.name == null) || editScreen,
                onChanged: productCreationValidation.changeName,
              ),
              const EditTextSpacer(),
              EditText(
                hintText: 'Product Description.',
                borderType: BorderType.bottom,
                saved: productCreationValidation.description.value,
                errorText: productCreationValidation.description.error,
                maxLines: 5,
                enabled: (product.description == null) || editScreen,
                onChanged: productCreationValidation.changeDescription,
              ),

              /// Image Picker
              SectionDivider(
                  leadIcon: ProximityIcons.picture,
                  title: 'Product Images.',
                  color: redSwatch.shade500),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: normal_100),
                child: ImagePickerWidget(
                    images: productCreationValidation.images,
                    maxImages: 9,
                    onImageAdded: productCreationValidation.addProductImage,
                    onImageRemoved:
                        productCreationValidation.removeProductImage),
              ),
              // const SizedBox(height: huge_100),

              /// Error Messages
              const SizedBox(height: small_100),
              ErrorMessage(errors: [
                productCreationValidation.name.error,
                productCreationValidation.description.error
              ]),
              SectionDivider(
                  leadIcon: ProximityIcons.cart,
                  title: 'Your Offer.',
                  color: redSwatch.shade500),
              InfoMessage(
                  message:
                      ' Please enter the price and quantity for each product accurately. If you offer product variants, specify the base details and variations. Keep your product information up to date for a smooth selling experience.'),

              if (!productCreationValidation.hasVariants!)
                Column(
                  children: [
                    EditText(
                        hintText: 'Price in €.',
                        keyboardType: TextInputType.number,
                        errorText: productCreationValidation.price!.error,
                        borderType: BorderType.top,
                        saved: productCreationValidation.price!.value,
                        enabled: (product.price == null) || editScreen,
                        onChanged: productCreationValidation.changePrice),
                    const EditTextSpacer(),
                    EditText(
                        hintText: 'Quantity.',
                        keyboardType: TextInputType.number,
                        borderType: BorderType.bottom,
                        errorText: productCreationValidation.quantity!.error,
                        saved: productCreationValidation.quantity!.value
                                    .toString() !=
                                "null"
                            ? productCreationValidation.quantity!.value
                                .toString()
                            : "",
                        enabled: (product.quantity == null) || editScreen,
                        onChanged: productCreationValidation.changeQuantity),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.all(normal_150).copyWith(top: 0),
                child: ListToggle(
                    title: 'add variants ',
                    value: productCreationValidation.hasVariants!,
                    onToggle: productCreationValidation.toggleVariants),
              ),
              if (productCreationValidation.hasVariants!)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionDivider(
                        leadIcon: ProximityIcons.product,
                        title: 'Options.',
                        color: redSwatch.shade500),
                   
                    productCreationValidation.characteristicsList.isEmpty
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: normal_125),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Wrap(
                                spacing: small_100,
                                runSpacing: 4.0,
                                children: productCreationValidation
                                    .characteristicsList
                                    .map((value) {
                                  return Chip(
                                    label: Text(
                                      value,
                                      style: TextStyle(
                                        color: primaryTextLightColor,
                                        fontSize: normal_100,
                                      ),
                                    ),
                                    backgroundColor:
                                        dividerLightColor.withOpacity(0.2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: BorderSide(
                                        color: dividerLightColor,
                                        width: 2.0,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ), Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TertiaryButton(
                            onPressed: () async {
                              final Map<String, Set<String>>?
                                  newCharacteristics = await Navigator.push(
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
                            },
                            title: 'Add options.'),
                      ],
                    ),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                    productCreationValidation.characteristics.isEmpty
                        ? Container()
                        : Column(
                            children: [
                              SectionDivider(
                                  leadIcon: ProximityIcons.product,
                                  title: 'Variations.',
                                  color: redSwatch.shade500),
                              VariantCreator(
                                  productVariants:
                                      productCreationValidation.variants,
                                  maxVariants:
                                      productCreationValidation.variantsMaxSize,
                                  characteristics:
                                      productCreationValidation.characteristics,
                                  onVariantAdded:
                                      productCreationValidation.addVariant,
                                  onVariantRemoved:
                                      productCreationValidation.removeVariant),
                            ],
                          ),
                  ],
                ),

              /// You Offer (Price and Quantity) if the product have no variants

              // Product Policy
              SectionDivider(
                  leadIcon: ProximityIcons.policy,
                  title: 'Product Policy.',
                  color: redSwatch.shade500),
              const InfoMessage(
                  message:
                      'Keep  global policy ensures fair and transparent transactions. When creating a new store, you can keep this policy for all your stores or create a custom policy for each store. Review the policy and create custom policies to build trust with your customers'),

              Padding(
                padding: const EdgeInsets.all(normal_100).copyWith(top: 0),
                child: Column(
                  children: [
                    ListToggle(
                        title: 'keep store policy',
                        value: productCreationValidation.storePolicy!,
                        onToggle: productCreationValidation.toggleStorePolicy),
                    if (!productCreationValidation.storePolicy!)
                      Padding(
                        padding:
                            const EdgeInsets.all(normal_100).copyWith(top: 0),
                        child: TertiaryButton(
                            onPressed: () async {
                              Policy? policyResult = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StorePolicyScreen(
                                          global: false,
                                          store: false,
                                          product: true,
                                          policy: product.policy ??
                                              _user!.policy)));
                              productCreationValidation.setPolicy(
                                  policyResult); // storeCreationValidation.changeAddress(_result);
                            },
                            title: 'Set product  Policy .'),
                      )
                    else
                      Container(),
                  ],
                ),
              ),

              /* VariantCreator(
                  productVariants: productCreationValidation.variants,
                  maxVariants: productCreationValidation.variantsMaxSize,
                  characteristics: productCreationValidation.characteristics,
                  onVariantAdded: productCreationValidation.addVariant,
                  onVariantRemoved: productCreationValidation.removeVariant),*/

              /// Image Picker,

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
                      productService.editProduct(
                          context,
                          index!,
                          productCreationValidation
                              .toFormData(productCreationValidation.policy));
                    } else {
                      // productCreationValidation
                      // .toFormData(productCreationValidation.policy);
                      productService.addProduct(
                          context,
                          productCreationValidation
                              .toFormData(productCreationValidation.policy));
                    }
                  },
                  title: editScreen ? 'Update.' : 'Confirm.')
            ])
          ])));
        }));
  }
}
