import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:proximity/config/themes/google_map_theme.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocoder;
import 'package:proximity/proximity.dart';

class AddressSelectionScreen extends StatefulWidget {
  const AddressSelectionScreen({Key? key, required this.currentAddress})
      : super(key: key);

  final Address currentAddress;

  @override
  _AddressSelectionScreenState createState() => _AddressSelectionScreenState();
}

class _AddressSelectionScreenState extends State<AddressSelectionScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  // selected address and location
  Address? selectedAddress;
  late LatLng selectedLocation;

  // initial camera location
  LatLng? initialCameraLocation;
  double? initialZoom;

  // current country lo
  late LatLng franceLocation;

  /// This method is used to create the google map
  void _onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(
        (Theme.of(context).brightness == Brightness.dark)
            ? GoogleMapsThemes.darkTheme
            : GoogleMapsThemes.lightTheme);
    _controller.complete(controller);
  }

  /// This method is used to localise the client app
  Future<LocationData?> getUserLocation() async {
    Location location = Location();
    String error;
    try {
      return await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      return null;
    }
  }

  /// This method is retrieve the address of a given location (lat, long)
  Future<Address> getLocationAddress(LatLng latLng) async {
    var addresses = await geocoder.placemarkFromCoordinates(
        latLng.latitude, latLng.longitude);
    var address = addresses.first;
    return Address(
      lat: latLng.latitude,
      lng: latLng.longitude,
      countryName: address.country,
      countryCode: address.isoCountryCode,
      locality: address.subAdministrativeArea,
      region: address.administrativeArea,
      city: address.locality,
      fullAddress: address.street,
      streetName: address.street,
      postalCode: address.postalCode,
    );
  }

  @override
  void initState() {
    super.initState();
    franceLocation = const LatLng(46.2276, 2.2137);
    if (widget.currentAddress.isAddressValid) {
      setState(() {
        /// set selected address
        selectedAddress = widget.currentAddress;

        /// set selected location
        selectedLocation =
            LatLng(widget.currentAddress.lat!, widget.currentAddress.lng!);

        /// set initial Zoom and Camera Location
        initialCameraLocation = selectedLocation;
        initialZoom = 12.0;

        /// Initialize Marker
        const MarkerId markerId = MarkerId('4544');
        final Marker marker = Marker(
          markerId: markerId,
          position: selectedLocation,
        );
        markers[markerId] = marker;
      });
    } else {
      selectedLocation = franceLocation;
      initialCameraLocation = selectedLocation;
      getUserLocation().then((LocationData? locationData) => setState(() {
            initialCameraLocation =
                LatLng(locationData!.latitude!, locationData.longitude!);
            selectedLocation = initialCameraLocation!;
            initialZoom = 12.0;
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    getUserLocation();
    return Scaffold(
        body: Stack(children: [
      Expanded(
          child: GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationButtonEnabled: false,
              compassEnabled: true,
              trafficEnabled: false,
              zoomControlsEnabled: false,
              tiltGesturesEnabled: false,
              initialCameraPosition: CameraPosition(
                  target: initialCameraLocation ?? franceLocation,
                  zoom: initialZoom ?? 5.0),
              markers: Set<Marker>.of(markers.values),
              onTap: (LatLng latLng) {
                // creating a new MARKER
                const MarkerId markerId = MarkerId('4544');
                final Marker marker =
                    Marker(markerId: markerId, position: latLng);
                selectedLocation = latLng;
                getLocationAddress(latLng).then((address) {
                  setState(() {
                    selectedAddress = address;
                    markers.clear();
                    // adding a new marker to map
                    markers[markerId] = marker;
                  });
                });
              })),
      Container(
          padding: const EdgeInsets.symmetric(vertical: normal_100),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Theme.of(context).backgroundColor,
            Theme.of(context).backgroundColor.withOpacity(0.0),
          ], begin: Alignment.center, end: Alignment.bottomCenter)),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TopBar(title: 'Select an address'),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: normal_100),
                    child: Text(
                        (selectedAddress != null)
                            ? selectedAddress!.getAddressLine
                            : "Please Select an Address",
                        style: Theme.of(context).textTheme.subtitle2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis))
              ])),
      Align(
          alignment: Alignment.bottomCenter,
          child: BottomActionsBar(buttons: [
            PrimaryButton(
                title: 'Validate.',
                onPressed: selectedAddress != null
                    ? () {
                        Navigator.pop(context, selectedAddress);
                      }
                    : null)
          ]))
    ]));
  }
}
