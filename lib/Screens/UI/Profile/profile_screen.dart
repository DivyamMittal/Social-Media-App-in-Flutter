// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_sample/Models/user_model.dart';
import 'package:firebase_sample/Screens/UI/Profile/edit_profile_screen.dart';
import 'package:firebase_sample/firebase/apis.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });
  // final UserModel user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // APIs().getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Divyam Mittal"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => EditProfileScreen()));
              },
              icon: Icon(Icons.edit))
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Image
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: CircleAvatar(
                radius: 50, backgroundImage: NetworkImage(APIs.me.image)),
          ),
        ),
        SizedBox(
          height: 10,
        ),

        // Name
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            APIs.me.name,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        SizedBox(
          height: 10,
        ),

        // Bio
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            APIs.me.bio,
            maxLines: 4,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 17, color: Colors.white),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text.rich(TextSpan(
                  text: "0",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  children: [
                    TextSpan(text: "  Posts", style: TextStyle(fontSize: 16))
                  ])),
              Text.rich(TextSpan(
                  text: "0",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  children: [
                    TextSpan(text: " Followers", style: TextStyle(fontSize: 16))
                  ])),
              Text.rich(TextSpan(
                  text: "0",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  children: [
                    TextSpan(text: " Following", style: TextStyle(fontSize: 16))
                  ]))
            ],
          ),
        )
      ]),
    );
  }
}
