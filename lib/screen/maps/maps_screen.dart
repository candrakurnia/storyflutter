// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:storyflutter/screen/maps/widgets/placemark.dart';

class MapsScreen extends StatefulWidget {
  // final double lat, lon;
  // final Function() onMaps;
  const MapsScreen({Key? key,})
      : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  final myLocation = const LatLng(-6.2417431, 107.0080811);
  late GoogleMapController mapController;
  late final Set<Marker> markers = {};
  geo.Placemark? placemark;

  @override
  void initState() {
    super.initState();

    final marker = Marker(
      markerId: const MarkerId("dicoding"),
      position: myLocation,
      onTap: () {
        mapController.animateCamera(
          CameraUpdate.newLatLngZoom(myLocation, 18),
        );
      },
    );
    markers.add(marker);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Maps"),
      ),
      body: Center(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                zoom: 18,
                target:myLocation,
              ),
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              markers: markers,
              onMapCreated: (controller) async {
                final info =
                    await geo.placemarkFromCoordinates(myLocation.latitude, myLocation.longitude);
                print(info);
                final place = info[0];
                final street = place.street!;
                final address =
                    '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
                setState(() {
                  placemark = place;
                });
                defineMarker(myLocation, street, address);
                setState(() {
                  mapController = controller;
                });
              },
              onLongPress: (LatLng latlng) {
                onLongPressGoogleMap(latlng);
              },
            ),
            Positioned(
              child: FloatingActionButton(
                  child: const Icon(Icons.location_city),
                  onPressed: () {
                    onMyLocationButtonPress();
                  }),
            ),
            if (placemark == null)
              const SizedBox()
            else
              Positioned(
                bottom: 16,
                right: 16,
                left: 16,
                child: PlacemarkWidget(
                  placemark: placemark!,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
        markerId: const MarkerId("source"),
        position: latLng,
        infoWindow: InfoWindow(
          title: street,
          snippet: address,
        ));
    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }

  void onMyLocationButtonPress() async {
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print("Location services is not available");
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Location permission is denied");
        return;
      }
    }
    locationData = await location.getLocation();
    final latlng = LatLng(locationData.latitude!, locationData.longitude!);
    final info =
        await geo.placemarkFromCoordinates(latlng.latitude, latlng.longitude);

    final place = info[0];
    final street = place.street;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
    });
    defineMarker(latlng, street!, address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latlng),
    );
  }

  void onLongPressGoogleMap(LatLng latlng) async {
    final info =
        await geo.placemarkFromCoordinates(latlng.latitude, latlng.longitude);
    print(info[0]);
    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
    });
    defineMarker(latlng, street, address);
    print("object lat $latlng");

    mapController.animateCamera(
      CameraUpdate.newLatLng(latlng),
    );
  }
}
