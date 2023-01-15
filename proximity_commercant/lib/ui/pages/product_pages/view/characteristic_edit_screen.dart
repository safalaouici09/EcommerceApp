import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_commercant/domain/product_repository/product_repository.dart';
import 'package:proximity_commercant/domain/store_repository/store_repository.dart';

class CharacteristicEditScreen extends StatelessWidget {
  const CharacteristicEditScreen({Key? key, required this.characteristics})
      : super(key: key);

  final Map<String, Set<String>> characteristics;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CharacteristicFormsController>(
        create: (context) => CharacteristicFormsController(characteristics),
        child: Consumer<CharacteristicFormsController>(
            builder: (context, characteristicFormsController, child) {
          return Scaffold(
              body: SafeArea(
                  child: Stack(alignment: Alignment.bottomCenter, children: [
            ListView(children: [
              const TopBar(title: "Variants Characteristic."),
              const InfoMessage(
                  message:
                      "Here you set the characteristics your product have\nEx: Color, Size, Language... etc"),
              ...characteristicFormsController.characteristics.entries.map((e) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(normal_100)
                              .copyWith(right: 0),
                          child: Row(children: [
                            Text('Option: ',
                                style: Theme.of(context).textTheme.bodyText2),
                            Text('${e.key} (${e.value.length})',
                                style: Theme.of(context).textTheme.subtitle2),
                            const SizedBox(width: small_100),
                            const Expanded(
                                child: Divider(
                                    height: tiny_50, thickness: tiny_50)),
                            const SizedBox(width: small_100),
                            if (characteristicFormsController
                                    .characteristics.length >
                                1) ...[
                              GestureDetector(
                                  onTap: () {
                                    openOptionDeleteDialog(context, e.key, characteristicFormsController);
                                  },
                                  child: const Icon(
                                      Icons.highlight_remove_rounded,
                                      size: normal_150)),
                              const SizedBox(width: normal_100),
                            ]
                          ])),
                      Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: small_100),
                          child: Wrap(
                              spacing: small_100,
                              runSpacing: 0,
                              children: [
                                ...e.value
                                    .map((item) => Chip(
                                          label: Text(item,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2),
                                          onDeleted: () {
                                            print('XXXXX ${e.value} $item');
                                            characteristicFormsController
                                                .removeValue(e.key, item);
                                          },
                                        ))
                                    .toList(),
                                GestureDetector(
                                    onTap: () {
                                      openValueDialog(context, e.key,
                                          characteristicFormsController);
                                    },
                                    child: Chip(
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
                                        ])))
                              ]))
                    ]);
              }).toList(),
              const Divider(thickness: tiny_50),
              Padding(
                  padding: const EdgeInsets.all(normal_100),
                  child: SecondaryButton(
                      onPressed: () {
                        openOptionDialog(
                            context, characteristicFormsController);
                      },
                      title: "Add new Option.")),
              const SizedBox(height: huge_100)
            ]),
            BottomActionsBar(buttons: [
              SecondaryButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  title: 'Cancel.'),
              PrimaryButton(
                  buttonState: characteristicFormsController.isValid
                      ? ButtonState.enabled
                      : ButtonState.disabled,
                  onPressed: () {
                    Navigator.pop(context, characteristicFormsController.characteristics);
                    },
                  title: 'Submit.')
            ])
          ])));
        }));
  }

  /// Dialog Form responsible of adding a new [Value] to an [Option]
  Future openValueDialog(BuildContext context, String option,
      CharacteristicFormsController characteristicFormController) =>
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Add a new Value.',
                style: Theme.of(context).textTheme.subtitle2),
            content: EditText(
              hintText: 'Value Name',
              onChanged: characteristicFormController.changeValue,
            ),
            actions: [
              TertiaryButton(
                  onPressed: () {
                    characteristicFormController.addValue(option);
                    Navigator.pop(context);
                  },
                  title: 'Submit')
            ],
          )).then((val) {
        characteristicFormController.changeValue('');
      });

  /// Dialog Form responsible of adding a new [Option]
  Future openOptionDialog(BuildContext context,
          CharacteristicFormsController characteristicFormController) =>
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Add a new Option.',
                    style: Theme.of(context).textTheme.subtitle2),
                content: EditText(
                  hintText: 'Option Name',
                  onChanged: characteristicFormController.changeOption,
                ),
                actions: [
                  TertiaryButton(
                      onPressed: () {
                        characteristicFormController.addOption();
                        Navigator.pop(context);
                      },
                      title: 'Submit')
                ],
              )).then((val) {
        characteristicFormController.changeOption('');
      });

  /// Dialog Form responsible of deleting a [Option]
  Future openOptionDeleteDialog(BuildContext context, String option,
      CharacteristicFormsController characteristicFormController) =>
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure you want to remove this Option?',
                style: Theme.of(context).textTheme.subtitle2),
            actions: [
              TertiaryButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  title: 'Cancel'),
              TertiaryButton(
                  onPressed: () {
                    characteristicFormController.removeOption(option);
                    Navigator.pop(context);
                  },
                  title: 'Delete')
            ],
          )).then((val) {
        characteristicFormController.changeValue('');
      });
}
