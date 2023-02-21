import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';

class ProductVariantCharacteristics extends StatelessWidget {
  const ProductVariantCharacteristics({Key? key, required this.characteristics})
      : super(key: key);

  final List<dynamic> characteristics;

  @override
  Widget build(BuildContext context) {
    List<TextSpan> _list = [];
    for (int i = 0; i < characteristics.length; i++) {
      _list.add(
          TextSpan(text: '${characteristics[i]["name"]} : ', style: Theme.of(context).textTheme.caption));
      _list.add(TextSpan(
          text: characteristics[i]["value"],
          style: Theme.of(context).textTheme.bodyText1));
      _list.add(
          TextSpan(text: ' / ', style: Theme.of(context).textTheme.caption));
    }
    _list.removeLast();
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: normal_100),
        child: RichText(text: TextSpan(children: _list)));
  }
}
