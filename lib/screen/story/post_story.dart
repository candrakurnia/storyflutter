import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:storyflutter/common/common.dart';
import 'package:storyflutter/provider/all_stories_provider.dart';
import 'package:storyflutter/provider/auth_provider.dart';
import 'package:storyflutter/provider/upload_provider.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:storyflutter/screen/maps/widgets/placemark.dart';

class PostStoryScreen extends StatefulWidget {
  final Function() onPosted;

  const PostStoryScreen({Key? key, required this.onPosted}) : super(key: key);

  @override
  State<PostStoryScreen> createState() => _PostStoryScreenState();
}

class _PostStoryScreenState extends State<PostStoryScreen> {
  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  geo.Placemark? placemark;
  final Location location = Location();
  late bool serviceEnabled;
  late PermissionStatus permissionGranted;
  late LocationData locationData;

  final _formKey = GlobalKey<FormState>();
  TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var myLocation = const LatLng(-6.2417431, 107.0080811);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.postText),
        actions: [
          IconButton(
            onPressed: () => _onUpload(),
            icon: context.watch<UploadProvider>().isUploading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Icon(Icons.upload),
            tooltip: "Unggah",
          ),
        ],
      ),
      body: PopScope(
        onPopInvoked: (didPop) {
          final authProvider = context.read<AuthProvider>();
          final allProvider = context.read<AllStoriesProvider>();
          // authProvider.getAllStories(allProvider);
        },
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: context.watch<UploadProvider>().imagePath == null
                    ? const Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.image,
                          size: 100,
                        ),
                      )
                    : _showImage(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: TextFormField(
                      validator: (String? value) {
                        if (value!.length > 255) {
                          return "Karakter tidak boleh lebih dari 255 karakter";
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 4,
                      controller: description,
                      decoration: const InputDecoration(
                        hintText: 'Tuliskan Ceritamu ...',
                        hintStyle: TextStyle(
                          color: Colors.blueGrey,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 250,
                  child: Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          zoom: 18,
                          target: myLocation,
                        ),
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: false,
                        mapToolbarEnabled: false,
                        markers: markers,
                        onMapCreated: (controller) async {
                          final info = await geo.placemarkFromCoordinates(
                              myLocation.latitude, myLocation.longitude);
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
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _onGalleryView(),
                      child: const Text("Gallery"),
                    ),
                    ElevatedButton(
                      onPressed: () => _onCameraView(),
                      child: const Text("Camera"),
                    ),
                  ],
                ),
              )
            ],
          ),
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

  _onUpload() async {
    locationData = await location.getLocation();
    final ScaffoldMessengerState scaffoldMessengerState =
        ScaffoldMessenger.of(context);
    final uploadProvider = context.read<UploadProvider>();
    final imagePath = uploadProvider.imagePath;
    final imageFile = uploadProvider.imagefile;
    if (imagePath == null || imageFile == null) return;

    final filename = imageFile.name;
    final bytes = await imageFile.readAsBytes();
    final newBytes = await uploadProvider.compressImage(bytes);
    final lati = locationData.latitude;
    final longi = locationData.longitude;
    print("data lati $lati");
    print("data longi $longi");

    if (_formKey.currentState!.validate()) {
      var descriptionText = description.text;

      await uploadProvider.upload(
          newBytes, filename, descriptionText, lati!, longi!);

      if (uploadProvider.uploadResponse != null) {
        uploadProvider.setImageFile(null);
        uploadProvider.setImagePath(null);
      }
      scaffoldMessengerState.showSnackBar(
        SnackBar(content: Text(uploadProvider.message)),
      );
    }
  }

  _onGalleryView() async {
    final provider = context.read<UploadProvider>();
    final ImagePicker imagePicker = ImagePicker();

    final XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final provider = context.read<UploadProvider>();
    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  Widget _showImage() {
    final imagePath = context.read<UploadProvider>().imagePath;
    return kIsWeb
        ? Image.network(
            imagePath.toString(),
            fit: BoxFit.contain,
          )
        : Image.file(
            File(imagePath.toString()),
            fit: BoxFit.contain,
          );
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
