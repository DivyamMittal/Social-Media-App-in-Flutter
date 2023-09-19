// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_sample/firebase/apis.dart';
import 'package:firebase_sample/providers/username_provider.dart';
import 'package:firebase_sample/utils/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String usernameText = APIs.me.username;

  @override
  Widget build(BuildContext context) {
    final usernameProvider = Provider.of<UsernameProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit profile"),
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              CupertinoIcons.multiply,
              size: 40,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    APIs()
                        .updateSelfInfo(usernameText)
                        .then((value) => Dialogs().showSnackbar(
                            context, "Profile Updated Successfully"))
                        .onError((error, stackTrace) => Dialogs()
                            .showSnackbar(context, "Something went wrong!"));
                    setState(() {});
                    Navigator.pop(context);
                  }
                },
                icon: Icon(
                  Icons.check_rounded,
                  size: 40,
                )),
          )
        ],
      ),

      backgroundColor: Colors.black,
      // body
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: APIs.me.image.isEmpty
                      ? NetworkImage(
                          "https://www.mountsinai.on.ca/wellbeing/our-team/team-images/person-placeholder/image")
                      : NetworkImage(APIs.me.image),
                ),
              ),
            ),

            // Name
            TextFormField(
              onSaved: (newValue) {
                APIs.me.name = newValue ?? '';
              },
              initialValue: APIs.me.name,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                labelText: "Name",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Required Field";
                } else {
                  return null;
                }
              },
            ),

            SizedBox(
              height: 10,
            ),

            // Username
            TextFormField(
              onChanged: (value) async {
                if (await APIs().checkUsernameAvailability(value)) {
                  bool isAvailable =
                      await APIs().checkUsernameAvailability(value);
                  usernameProvider.usernameAvailable = isAvailable;
                  usernameText = value;
                } else {
                  usernameProvider.usernameAvailable = false;
                }
              },
              initialValue: APIs.me.username,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                labelText: "Username",
              ),
              validator: (value) {
                if (value == null || value.length < 3 || value.isEmpty) {
                  return "Username must be 3 character long";
                } else if (usernameText != APIs.me.username &&
                    usernameProvider.usernameAvailable == false) {
                  return "Username not available";
                } else {
                  return null;
                }
              },
            ),

            SizedBox(
              height: 10,
            ),

            // Bio
            TextFormField(
              onSaved: (newValue) {
                APIs.me.bio = newValue ?? '';
              },
              initialValue: APIs.me.bio,
              minLines: 1,
              maxLines: 4,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                labelText: "bio",
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
