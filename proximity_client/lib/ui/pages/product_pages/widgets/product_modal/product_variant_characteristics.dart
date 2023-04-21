import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/product_repository/src/product_service.dart';

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

  final Map<String, List<String>> characteristics;

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);
    /*  Map<String, List<String>> characteristics = {
      "key1": ["value1", "value2", "value3"],
      "key2": ["value4", "value5"],
      "key3": ["value6"],
    };*/

    /*  List<Column> _list = [];
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
    _list.removeLast();*/
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: normal_100),
        child:
            /* width: 200,
            height: 200,*/
            MasonryGrid(
                column: 1,
                padding: const EdgeInsets.symmetric(horizontal: small_100),
                children: List.generate(
                  characteristics.length,
                  (index) {
                    String key = characteristics.keys.elementAt(index);
                    List<String> values =
                        characteristics.values.elementAt(index);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(key), // Display the key in a Text widget
                        SizedBox(height: 10), // Add some spacing
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: GroupedChoiceChip(
                            values: values,
                            onSelected: (selectedValue) {
                              productService.addFilter(key, selectedValue);
                              // Handle selected value here
                            },
                          ),
                        ),
                      ],
                    );
                  },
                )));
  }
}

class GroupedChoiceChip extends StatefulWidget {
  final List<String> values;
  final Function(String) onSelected;

  GroupedChoiceChip({
    required this.values,
    required this.onSelected,
  });

  @override
  _GroupedChoiceChipState createState() => _GroupedChoiceChipState();
}

class _GroupedChoiceChipState extends State<GroupedChoiceChip> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: widget.values.map((value) {
        return ChoiceChip(
          label: Text(value),
          selectedColor: Color(0xFF42A4F5),
          selected: _selectedValue == value,
          onSelected: (selected) {
            setState(() {
              _selectedValue = selected ? value : null;
            });
            widget.onSelected(_selectedValue!);
          },
        );
      }).toList(),
    );
  }
}
