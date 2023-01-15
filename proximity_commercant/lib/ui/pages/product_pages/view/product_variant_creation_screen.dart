import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_commercant/domain/product_repository/product_repository.dart';

class ProductVariantCreationScreen extends StatefulWidget {
  const ProductVariantCreationScreen({Key? key, required this.characteristics})
      : super(key: key);

  final Map<String, Set<String>> characteristics;

  @override
  State<ProductVariantCreationScreen> createState() =>
      _ProductVariantCreationScreenState();
}

class _ProductVariantCreationScreenState
    extends State<ProductVariantCreationScreen> {
  late ProductVariant _variant;

  @override
  void initState() {
    super.initState();
    _variant = ProductVariant(
        characteristics:
            List<dynamic>.filled(widget.characteristics.length, null),
        available: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(alignment: Alignment.bottomCenter, children: [
      ListView(children: [
        const TopBar(title: "Product Variant."),
        const InfoMessage(
            message:
                "Select below the characteristics of this Variant and pick an image."),
        SectionDivider(
            leadIcon: ProximityIcons.product,
            title: 'Variant Characteristics.',
            color: redSwatch.shade400),
        ...((){
          List<DropDownSelector> _list = [];
          for (int i = 0; i < widget.characteristics.length; i++) {
            _list.add(DropDownSelector(
                hintText: widget.characteristics.keys.elementAt(i),
                padding: true,
                // savedValue: ,
                onChanged: (value, index) {
                  setState(() {
                    _variant.characteristics![i] =
                        MapEntry(widget.characteristics.keys.elementAt(i), value);
                  });
                },
                items: widget.characteristics.values.elementAt(i)
                    .map((item) => DropdownItem<String>(
                    value: item,
                    child: Text(item,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontWeight: FontWeight.w600))))
                    .toList()));
          }
          return _list;
        }()),
        SectionDivider(
            leadIcon: ProximityIcons.cart,
            title: 'Variant Offer.',
            color: redSwatch.shade400),
        RichEditText(children: [
          EditText(
              hintText: 'Variant Price in €.',
              borderType: BorderType.top,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _variant.price = double.tryParse(value);
                });
              }),
          EditText(
              hintText: 'Variant Quantity.',
              borderType: BorderType.bottom,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _variant.quantity = int.tryParse(value);
                });
              }),
        ]),
        SectionDivider(
            leadIcon: ProximityIcons.picture,
            title: 'Variant Image.',
            color: redSwatch.shade400),
        ImagePickerWidget(
            images: (_variant.image == null) ? [] : [_variant.image],
            maxImages: 1,
            centered: true,
            onImageAdded: (List<dynamic> imageList) {
              setState(() {
                _variant.image = imageList.first;
              });
            },
            onImageRemoved: (int index) {
              setState(() {
                _variant.image = null;
              });
            }),
        const SizedBox(height: huge_100),
      ]),
      BottomActionsBar(buttons: [
        PrimaryButton(
            buttonState:
                _variant.isValid ? ButtonState.enabled : ButtonState.disabled,
            onPressed: () {
              Navigator.pop(context, _variant);
            },
            title: 'Submit.')
      ])
    ])));
  }
}
