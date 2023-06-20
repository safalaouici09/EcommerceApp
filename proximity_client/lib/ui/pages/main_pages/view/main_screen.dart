import 'dart:ui';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
import 'home_tab_screen.dart';
import 'map_tab_screen.dart';
import 'cart_tab_screen.dart';
import 'profile_tab_screen.dart';
import 'package:proximity_client/domain/data_persistence/data_persistence.dart';
import 'package:proximity_client/domain/user_repository/user_repository.dart';
import 'package:proximity_client/ui/pages/main_pages/view/cart_slider_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:proximity_client/domain/notification_repository/notification_repository.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  String _debugLabelString = "";
  String notification_type = "Refund";
  Map<String, dynamic>? notification = null;
  String notification_title = "";
  String notification_body = "";

  int nbr_of_notifications = 0;

  NotificationService notificationServiceGlobal = NotificationService();

  @override
  void initState() {
    super.initState();
    _index = 0;
    notificationServiceGlobal.getNotifications(null);
    initPlatform(notificationServiceGlobal);
  }

  @override
  Widget build(BuildContext parentContext) {
    final userService = Provider.of<UserService>(parentContext);
    final notificationService = Provider.of<NotificationService>(parentContext);

    var credentialsBox = Boxes.getCredentials();
    String? _token = credentialsBox.get('token');

    if (_token != null && userService.user == null) {
      userService.getUserData();
    }

    if (_debugLabelString != "") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        handleNotification(notification, notificationService, parentContext);
        setState(() {
          _debugLabelString = "";
        });
      });
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Stack(alignment: Alignment.bottomCenter, children: [
          (() {
            switch (_index) {
              case 0:
                return const HomeTabScreen();
              case 1:
                return const MapTabScreen();
              case 2:
                return const CartTabScreen();
              // return  CartSliderScreen() ;
              case 3:
                return const ProfileTabScreen();
              default:
                return const HomeTabScreen();
            }
          }()),
          Material(
              color: Colors.transparent,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: normal_100,
                    sigmaY: normal_100,
                  ),
                  child: Container(
                      height: large_200,
                      decoration: BoxDecoration(
                          color: Theme.of(parentContext)
                              .cardColor
                              .withOpacity(0.9),
                          border: Border(
                              top: BorderSide(
                                  color: Theme.of(parentContext).dividerColor,
                                  width: tiny_50))),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                                child: InkWell(
                              onTap: () => setState(() {
                                _index = 0;
                              }),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_index == 0) ...[
                                      DuotoneIcon(
                                        primaryLayer:
                                            ProximityIcons.home_duotone_1,
                                        secondaryLayer:
                                            ProximityIcons.home_duotone_2,
                                        color: blueSwatch.shade500,
                                      ),
                                      Text('Home',
                                          style: Theme.of(parentContext)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(height: 0.9)),
                                      const SizedBox(height: tiny_50),
                                      Container(
                                          height: tiny_50,
                                          width: normal_150,
                                          decoration: BoxDecoration(
                                              color: blueSwatch.shade500,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      tinyRadius)))
                                    ] else
                                      const Icon(ProximityIcons.home),
                                  ]),
                            )),
                            Expanded(
                                child: InkWell(
                              onTap: () => setState(() {
                                _index = 1;
                              }),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_index == 1) ...[
                                      DuotoneIcon(
                                        primaryLayer:
                                            ProximityIcons.map_duotone_1,
                                        secondaryLayer:
                                            ProximityIcons.map_duotone_2,
                                        color: greenSwatch.shade300,
                                      ),
                                      Text('Map',
                                          style: Theme.of(parentContext)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(height: 0.9)),
                                      const SizedBox(height: tiny_50),
                                      Container(
                                          height: tiny_50,
                                          width: normal_150,
                                          decoration: BoxDecoration(
                                              color: greenSwatch.shade300,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      tinyRadius)))
                                    ] else
                                      const Icon(ProximityIcons.map),
                                  ]),
                            )),
                            Expanded(
                                child: InkWell(
                              onTap: () => setState(() {
                                _index = 2;
                              }),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_index == 2) ...[
                                      DuotoneIcon(
                                        primaryLayer:
                                            ProximityIcons.cart_duotone_1,
                                        secondaryLayer:
                                            ProximityIcons.cart_duotone_2,
                                        color: yellowSwatch.shade600,
                                      ),
                                      Text('Cart',
                                          style: Theme.of(parentContext)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(height: 0.9)),
                                      const SizedBox(height: tiny_50),
                                      Container(
                                          height: tiny_50,
                                          width: normal_150,
                                          decoration: BoxDecoration(
                                              color: yellowSwatch.shade600,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      tinyRadius)))
                                    ] else
                                      const Icon(ProximityIcons.cart),
                                  ]),
                            )),
                            Expanded(
                                child: InkWell(
                              onTap: () => setState(() {
                                _index = 3;
                              }),
                              child: Consumer<NotificationService>(
                                  builder: (_, notificationService, __) {
                                var nb_notifs = notificationService
                                    .notifications
                                    .where((element) =>
                                        element.seendInList != true)
                                    .length;
                                return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Stack(children: [
                                        if (nb_notifs > 0)
                                          Container(
                                              padding:
                                                  const EdgeInsets.all(tiny_50),
                                              margin: const EdgeInsets.only(
                                                  top: 2, left: 25),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          tinyRadius),
                                                  color: redSwatch.shade500),
                                              child: Text(
                                                '${nb_notifs}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption!
                                                    .copyWith(
                                                        color:
                                                            primaryTextDarkColor,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                        if (_index == 3)
                                          Column(
                                            children: [
                                              DuotoneIcon(
                                                primaryLayer: ProximityIcons
                                                    .user_duotone_1,
                                                secondaryLayer: ProximityIcons
                                                    .user_duotone_2,
                                                color: redSwatch.shade500,
                                              ),
                                              Text('Profile',
                                                  style: Theme.of(parentContext)
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(height: 0.9)),
                                              Container(
                                                  height: tiny_50,
                                                  width: normal_150,
                                                  decoration: BoxDecoration(
                                                      color: redSwatch.shade500,
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              tinyRadius))),
                                              const SizedBox(height: tiny_50),
                                            ],
                                          ),
                                        if (_index != 3)
                                          const Icon(ProximityIcons.user),
                                      ])
                                    ]);
                              }),
                            )),
                          ])),
                ),
              ))
        ])));
  }

  Future<void> initPlatform(NotificationService notificationService) async {
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult event) {
      notificationServiceGlobal.getNotifications(null);
      print('BODY ${event.notification.body}');
      print('TITLE: ${event.notification.title}');
      print(
          "Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
      var credentialsBox = Boxes.getCredentials();
      var _id = credentialsBox.get('id');

      print(_id);
      print("event.notification.additionalData 1");
      print(event.notification.additionalData);

      if (_id != null &&
          _id != "" &&
          event.notification.additionalData != null &&
          event.notification.additionalData!["owner_id"].contains(_id)) {
        print("is the owner");
        setState(() {
          _debugLabelString = event.notification.jsonRepresentation();
          notification = event.notification.additionalData;
          notification_title = event.notification.title ?? "";
          notification_body = event.notification.body ?? "";
        });
      }
      print('"OneSignal: notification opened: ${event}');
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      notificationServiceGlobal.getNotifications(null);
      print("event.notification.additionalData");
      print(event.notification.additionalData);
      print('BODY ${event.notification.body}');
      print('TITLE: ${event.notification.title}');
      print(
          "Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
      var credentialsBox = Boxes.getCredentials();
      var _id = credentialsBox.get('id');

      print(_id);

      if (_id != null &&
          _id != "" &&
          event.notification.additionalData != null &&
          event.notification.additionalData!["owner_id"].contains(_id)) {
        print("is the owner");
        setState(() {
          _debugLabelString = event.notification.jsonRepresentation();
          notification = event.notification.additionalData;
          notification_title = event.notification.title ?? "";
          notification_body = event.notification.body ?? "";
          nbr_of_notifications += 1;
        });
        notificationService.getNotifications(null);
      } else {
        event.complete(null);
      }
    });
  }

  void handleNotification(
      notification, NotificationService notificationService, parentContext) {
    print("abousssssssssssssssss");
    var notification_icon = ProximityIcons.delivery_duotone_1;
    var notification_text = "Apple store responded to one of your orders";
    var notification_redirection = "";
    var notification_image = null;

    switch (notification!["sub_type"]) {
      case "Delivery":
        notification_icon = ProximityIcons.delivery_duotone_1;
        break;
      case "Pickup":
        notification_icon = ProximityIcons.self_pickup_duotone_1;
        break;
      case "Reservation":
        notification_icon = ProximityIcons.history_duotone_1;
        break;
      case "Return":
        notification_image = "assets/img/return_icon.png";
        break;
      case "Refund":
        notification_image = "assets/img/refund_icon.png";
        break;
      case "Cancel":
        notification_icon = ProximityIcons.rejected_duotone_1;
        break;
      default:
    }

    showDialogPopup(
        barrierDismissible: false,
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
                        if (notification_image == null ||
                            notification_image == "")
                          Icon(notification_icon,
                              color: redSwatch.shade500, size: normal_300),
                        if (notification_image != null &&
                            notification_image != "")
                          SizedBox(
                              height: 40,
                              width: 40,
                              child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Positioned.fill(
                                        child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    normalRadius),
                                            child: FittedBox(
                                                fit: BoxFit.cover,
                                                child: Image.asset(
                                                    notification_image)))),
                                  ])),
                      ]),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: normal_100,
                              left: normal_100,
                              right: normal_100),
                          child: Text(
                              notification_title
                              // message
                              ,
                              style: Theme.of(context).textTheme.headline3,
                              textAlign: TextAlign.center)),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: normal_100,
                              left: normal_100,
                              right: normal_100),
                          child: Text(
                              notification_body
                              // message
                              ,
                              style: Theme.of(context).textTheme.subtitle2,
                              textAlign: TextAlign.center)),
                      Padding(
                          padding: const EdgeInsets.all(normal_100),
                          child: Row(mainAxisSize: MainAxisSize.max, children: [
                            Expanded(
                                child: SecondaryButton(
                                    title: 'Cancel.',
                                    onPressed: () =>
                                        Navigator.of(context).pop())),
                            const SizedBox(
                              width: small_100,
                            ),
                            Expanded(
                                child: SecondaryButton(
                                    title: 'Voir.',
                                    onPressed: () async {
                                      notificationService.makeItSeend(
                                          notification!["notification_id"]);
                                      if (notification!["type"] == 'order') {
                                        Navigator.of(context).pop();
                                        await notificationService.getOrder(
                                            notification!["id"], parentContext,
                                            refundOrder:
                                                notification!["sub_type"] ==
                                                    "Refund",
                                            returnOrder:
                                                notification!["sub_type"] ==
                                                    "Return");
                                      }
                                    })),
                          ]))
                    ])))));
  }
}
