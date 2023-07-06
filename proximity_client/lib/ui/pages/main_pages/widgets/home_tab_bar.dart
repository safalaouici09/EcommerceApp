import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/user_repository/user_repository.dart';
import 'package:proximity_client/ui/widgets/address_picker/address_selection_screen.dart';

import '../view/notifications_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomeTabBar extends StatefulWidget {
  const HomeTabBar({Key? key}) : super(key: key);

  @override
  State<HomeTabBar> createState() => _HomeTabBarState();
}

class _HomeTabBarState extends State<HomeTabBar> {
  String? _currentAddress;
  Position? _currentPosition;
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        /* _currentAddress = '${place.street}' +
            ', ${place.subLocality},' +
            '${place.subAdministrativeArea}' +
            ', ${place.postalCode}';*/
        _currentAddress = '${place.street}, ${place.locality}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void initState() {
    super.initState();

    _getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
            padding: const EdgeInsets.all(normal_100),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  /* Icon(Icons.pin_drop_outlined,
                      color: Theme.of(context)
                          .primaryColor), //hoverColor, size: normal_100),
                  */
                  GestureDetector(
                    onTap: () async {
                      _currentAddress = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddressSelectionScreen(
                                    currentAddress: Address(),
                                    navigation: true,
                                  )));
                    },
                    /*  print("""/////""" + _result);
                              print(AddressItem.fromAdress(_result));,*/
                    child: Row(
                      children: [
                        const SizedBox(width: small_50),
                        _currentAddress != null
                            ? Text(_currentAddress!,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(color: primaryTextLightColor))
                            : ShimmerFx(
                                child: Container(
                                    color: Theme.of(context).cardColor,
                                    child: Text('Montpellier, France',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2))),
                        const Icon(ProximityIcons.chevron_bottom),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SmallIconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationsScreen()));
                      },
                      icon: const Icon(ProximityIcons.notifications)),
                  const SizedBox(width: normal_100)
                ])),
      ],
    );
  }
}
