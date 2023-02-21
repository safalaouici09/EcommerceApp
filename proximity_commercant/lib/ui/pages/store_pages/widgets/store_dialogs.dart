import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_commercant/domain/store_repository/store_repository.dart';
import 'package:proximity_commercant/ui/pages/home_pages/home_pages.dart';

/// This class has a couple of DialogWidgets to avoid BoilerPlate between Widgets
///
/// The [id] indicates the index of the store
class StoreDialogs {
  /// A method to display the freeze dialog
  static void freezeStore(BuildContext context, int index, {int? popCount}) =>
      showDialogPopup(
          context: context,
          pageBuilder: (ctx, anim1, anim2) => StatefulBuilder(
              builder: (context, setState) => DialogPopup(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width - normal_200 * 2,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const SizedBox(height: normal_100),
                        Stack(children: [
                          ImageFiltered(
                              imageFilter: blurFilter,
                              child: Icon(ProximityIcons.freeze,
                                  color: blueSwatch.shade100.withOpacity(1 / 3),
                                  size: normal_300)),
                          Icon(ProximityIcons.freeze,
                              color: blueSwatch.shade100, size: normal_300)
                        ]),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: normal_100,
                                left: normal_100,
                                right: normal_100),
                            child: Text('Freeze Store Message.',
                                style: Theme.of(context).textTheme.subtitle2,
                                textAlign: TextAlign.center)),
                        Padding(
                            padding: const EdgeInsets.all(normal_100),
                            child:
                                Row(mainAxisSize: MainAxisSize.max, children: [
                              Expanded(
                                  child: SecondaryButton(
                                      title: 'Cancel.',
                                      onPressed: () => Navigator.pop(context))),
                              const SizedBox(width: normal_100),
                              Expanded(
                                  child: Consumer<StoreService>(
                                      builder: (context, storeService, child) =>
                                          Expanded(
                                              child: PrimaryButton(
                                                  title: 'Freeze.',
                                                  onPressed: () async {
                                                    int count = 0;
                                                    bool _bool =
                                                        await storeService
                                                            .freezeStore(
                                                                context, index);
                                                    if (_bool) {
                                                      Navigator.popUntil(
                                                          context, (route) {
                                                        return count++ ==
                                                            (popCount ?? 1);
                                                      });
                                                    }
                                                  }))))
                            ]))
                      ])))));

  /// A method to display the delete dialog
  static void deleteStore(BuildContext context, String id, {int? popCount}) =>
      showDialogPopup(
          context: context,
          pageBuilder: (ctx, anim1, anim2) => StatefulBuilder(
              builder: (context, setState) => DialogPopup(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width - normal_200 * 2,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const SizedBox(height: normal_100),
                        Stack(children: [
                          ImageFiltered(
                              imageFilter: blurFilter,
                              child: Icon(ProximityIcons.remove,
                                  color: Theme.of(context).errorColor,
                                  size: normal_300)),
                          Icon(ProximityIcons.remove,
                              color: Theme.of(context).errorColor,
                              size: normal_300)
                        ]),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: normal_100,
                                left: normal_100,
                                right: normal_100),
                            child: Text('Delete Store Message.',
                                style: Theme.of(context).textTheme.subtitle2,
                                textAlign: TextAlign.center)),
                        Padding(
                            padding: const EdgeInsets.all(normal_100),
                            child:
                                Row(mainAxisSize: MainAxisSize.max, children: [
                              Expanded(
                                  child: SecondaryButton(
                                      title: 'Cancel.',
                                      onPressed: () => Navigator.pop(context))),
                              const SizedBox(width: normal_100),
                              Expanded(
                                  child: Consumer<StoreService>(
                                      builder: (context, storeService, child) =>
                                          Expanded(
                                              child: PrimaryButton(
                                                  title: 'Delete.',
                                                  onPressed: () async {
                                                    int count = 0;
                                                    bool _bool =
                                                        await storeService
                                                            .deleteStore(id);
                                                    if (_bool) {
                                                      Navigator.popUntil(
                                                          context, (route) {
                                                        return count++ ==
                                                            (popCount ?? 1);
                                                      });
                                                    }
                                                  }))))
                            ]))
                      ])))));
  static void confirmStore(
    BuildContext context,
    int index,
    /*{int? popCount}*/
  ) =>
      showDialogPopup(
          context: context,
          pageBuilder: (ctx, anim1, anim2) => StatefulBuilder(
              builder: (context, setState) => DialogPopup(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width - normal_200 * 2,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const SizedBox(height: normal_100),
                        Stack(children: [
                          ImageFiltered(
                              imageFilter: blurFilter,
                              child: Icon(Icons.check_circle_outline_outlined,
                                  color: blueSwatch.shade100.withOpacity(1 / 3),
                                  size: normal_300)),
                          Icon(Icons.check_circle_outline_outlined,
                              color: blueSwatch.shade100, size: normal_300)
                        ]),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: normal_100,
                                left: normal_100,
                                right: normal_100),
                            child: Text(
                                'Thank you for your interest in creating a store on our platform./n Before we can activate your store, we need to verify its information to ensure that it complies with our policies./n we will get back to you as soon as possible.',
                                style: Theme.of(context).textTheme.subtitle2,
                                textAlign: TextAlign.center)),
                        Padding(
                            padding: const EdgeInsets.all(normal_100),
                            child:
                                Row(mainAxisSize: MainAxisSize.max, children: [
                              Expanded(
                                  child: SecondaryButton(
                                      title: 'Cancel.',
                                      onPressed: () => Navigator.pop(context))),
                              const SizedBox(width: normal_100),
                              Expanded(
                                  child: Consumer<StoreService>(
                                      builder: (context, storeService, child) =>
                                          Expanded(
                                              child: PrimaryButton(
                                                  title: 'Agree.',
                                                  onPressed: () {
                                                    /// Go to [HomeScreen]
                                                    Navigator.of(context)
                                                        .pushAndRemoveUntil(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const HomeScreen()),
                                                            (Route<dynamic>
                                                                    route) =>
                                                                false);
                                                  }))))
                            ]))
                      ])))));
}
