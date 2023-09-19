import 'dart:io';

import 'package:flutter/material.dart';

class PostUploadScreen extends StatelessWidget {
  const PostUploadScreen({super.key, required this.image});
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Post"),
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                "Post",
                style: TextStyle(color: Colors.blue, fontSize: 18),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
                width: 50,
                height: 50,
                child: Image.file(
                  File(image!),
                  fit: BoxFit.contain,
                )),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: TextField(
                maxLength: 100,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Write a caption..",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
