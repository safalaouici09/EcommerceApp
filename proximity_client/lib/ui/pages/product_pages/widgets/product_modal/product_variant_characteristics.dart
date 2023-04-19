import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';

/*class ProductVariantCharacteristics extends StatelessWidget {
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
}*/
class ProductVariantCharacteristics extends StatelessWidget {
  const ProductVariantCharacteristics({Key? key, required this.characteristics})
      : super(key: key);

  final List<dynamic> characteristics;

  @override
  Widget build(BuildContext context) {
    List<Column> _list = [];
    for (int i = 0; i < characteristics.length; i++) {
      _list.add(Column(children: [
        Text('${characteristics[i]["name"]} : ',
            style: Theme.of(context).textTheme.caption),
        Wrap(spacing: small_100, runSpacing: 0, children: [
          Chip(
            label: Text('${characteristics[i]["value"]}',
                style: Theme.of(context).textTheme.bodyText2),
          )
          //  .toList(),
          /* GestureDetector(
                                    onTap: () {
                                      openValueDialog(context, e.key,
                                         */
          /*    child: Chip(
                                        label: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                          Icon(ProximityIcons.add,
                                              size: normal_100,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          const SizedBox(width: small_100),
                                          Text('Add new Value.',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .primaryColor))
                                        ])))*/
        ])
      ]));
      /* _list.add(TextSpan(
          text: characteristics[i]["value"],
          style: Theme.of(context).textTheme.bodyText1));
      _list.add(
          TextSpan(text: ' / ', style: Theme.of(context).textTheme.caption));*/
    }
    _list.removeLast();
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: normal_100),
        child: SizedBox(
            width: 200, height: 200, child: ListView(children: _list)));
  }
}
