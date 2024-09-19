// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  final Function() onMaps;
  const MapsScreen({Key? key, required this.onMaps}) : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  final myLocation = const LatLng(-6.2417431, 107.0080811);
  late GoogleMapController mapController;
  final Set<Marker> markers = {};

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
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            zoom: 18,
            target: myLocation,
          ),
          markers: markers,
          onMapCreated: (controller) {
            setState(() {
              mapController = controller;
            });
          },
        ),
      ),
    );
  }
}
