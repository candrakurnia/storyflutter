// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:storyflutter/core.dart';
import 'package:storyflutter/provider/detail_story_provider.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  final String userId;
  final Function(double lat, double lon) onMaps;
  const DetailScreen({
    Key? key,
    required this.userId,
    required this.onMaps,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // final myLocation = const LatLng(-6.2417431, 107.0080811);
  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  @override
  void initState() {
    super.initState();
    final detailProvider = context.read<DetailStoryProvider>();
    Future.microtask(() async => detailProvider.fetchDetail(widget.userId));

    final myLocation = LatLng(
        detailProvider.detailStories?.story.lat ?? -6.2417431,
        detailProvider.detailStories?.story.lon ?? 107.0080811);
    var marker = Marker(
      markerId: const MarkerId("location"),
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
  void dispose() {
    markers.clear();
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
      ),
      body: Consumer<DetailStoryProvider>(
        builder: (context, value, child) {
          if (value.resultState == ResultState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (value.resultState == ResultState.hasData) {
            final myLocation = LatLng(
                value.detailStories?.story.lat ?? -6.2417431,
                value.detailStories?.story.lon ?? 107.0080811);
            // return Container(
            //   width: double.infinity,
            //   // height: MediaQuery.of(context).size.height,
            //   decoration: const BoxDecoration(color: Colors.white),
            //   child: Padding(
            //     padding: const EdgeInsets.all(8),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       crossAxisAlignment: CrossAxisAlignment.stretch,
            //       children: [
            //         Image.network(
            //             fit: BoxFit.contain,
            //             value.detailStories!.story.photoUrl),
            //         Text(value.detailStories!.story.name),
            //         const SizedBox(
            //           height: 8.0,
            //         ),
            //         Text(value.detailStories!.story.description),
            //         Text(
            //           DateFormat('EEEE, MM/d/y HH:mm').format(
            //             DateTime.parse(
            //               value.detailStories!.story.createdAt.toString(),
            //             ),
            //           ),
            //           style: const TextStyle(
            //               fontSize: 14.0, fontWeight: FontWeight.w400),
            //         ),
            //         SizedBox(
            //           width: double.infinity,
            //           height: 500,
            //           child: GoogleMap(
            //             initialCameraPosition: CameraPosition(
            //               zoom: 18,
            //               target: myLocation,
            //             ),
            //             markers: markers,
            //             onMapCreated: (controller) {
            //               setState(() {
            //                 mapController = controller;
            //               });
            //             },
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // );
            return Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      zoom: 18,
                      target:
                      myLocation
                    ),
                    markers: markers,
                    zoomControlsEnabled: false,
                    onMapCreated: (controller) {
                      setState(() {
                        mapController = controller;
                      });
                    },
                  ),
                ),
            Positioned(
              bottom: 8,
              right: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.all(16),
                constraints: const BoxConstraints(maxWidth: 500),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      blurRadius: 20,
                      offset: Offset.zero,
                      color: Colors.grey.withOpacity(0.5),
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(value.detailStories!.story.name),
                    const SizedBox(height: 5.0),
                    SizedBox(
                      height: 200,
                      child: Image.network(
                      value.detailStories!.story.photoUrl,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.3,
                      fit: BoxFit.fill,
                      ),
                    ),
                    Text(
                      value.detailStories!.story.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      DateFormat('EEE, M/d/y HH:mm').format(
                        DateTime.parse(
                          value.detailStories!.story.createdAt.toString(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
              ],
            );
          } else if (value.resultState == ResultState.noData) {
            return Center(
              child: Text(value.message),
            );
          } else {
            return const Center(
              child: Text("Terjadi Kesalahan, periksa koneksi anda"),
            );
          }
        },
      ),
    );
  }
}
