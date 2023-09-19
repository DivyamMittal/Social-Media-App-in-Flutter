import 'dart:developer';

import 'package:firebase_sample/Screens/UI/Create%20Post/post_upload.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  String? _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                // Pick an image.
                // final XFile? image =
                //     await
                picker
                    .pickImage(source: ImageSource.gallery)
                    .then((XFile? image) {
                  if (image != null) {
                    log('Image path: ${image.path} -- Mime type: ${image.mimeType}');

                    _image = image.path;
                    setState(() {});
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => PostUploadScreen(image: _image)));
                  }
                }).onError((error, stackTrace) {
                  log("error while navigating to post upload screen");
                });
              },
              child: const Text("Choose from Gallery"),
            ),
            TextButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                // Pick an image.
                picker
                    .pickImage(source: ImageSource.camera)
                    .then((XFile? image) {
                  if (image != null) {
                    log('Image path: ${image.path} -- Mime type: ${image.mimeType}');

                    _image = image.path;
                    setState(() {});
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => PostUploadScreen(image: _image)));
                  }
                }).onError((error, stackTrace) {
                  log("error while navigating to post upload screen");
                });
              },
              child: const Text("Open camera"),
            )
          ],
        ),
      ),
    );
  }
}
