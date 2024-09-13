import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:storyflutter/provider/all_stories_provider.dart';
import 'package:storyflutter/provider/auth_provider.dart';
import 'package:storyflutter/provider/upload_provider.dart';
import 'package:provider/provider.dart';

class PostStoryScreen extends StatefulWidget {
  final Function() onPosted;

  const PostStoryScreen({Key? key, required this.onPosted}) : super(key: key);

  @override
  State<PostStoryScreen> createState() => _PostStoryScreenState();
}

class _PostStoryScreenState extends State<PostStoryScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post Your Story"),
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
          authProvider.getAllStories(allProvider);
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
                    ElevatedButton(
                      onPressed: () => _onCustomCameraView(),
                      child: const Text("Custom Camera"),
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

  _onUpload() async {
    final ScaffoldMessengerState scaffoldMessengerState =
        ScaffoldMessenger.of(context);
    final uploadProvider = context.read<UploadProvider>();
    final imagePath = uploadProvider.imagePath;
    final imageFile = uploadProvider.imagefile;
    if (imagePath == null || imageFile == null) return;

    final filename = imageFile.name;
    final bytes = await imageFile.readAsBytes();
    final newBytes = await uploadProvider.compressImage(bytes);

    if (_formKey.currentState!.validate()) {
      var descriptionText = description.text;

      await uploadProvider.upload(
          newBytes, filename, descriptionText);

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

  _onCustomCameraView() async {}

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
}
