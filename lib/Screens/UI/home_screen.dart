// ignore_for_file: prefer_const_constructors

import 'package:firebase_sample/Screens/AuthScreen/login_page.dart';
import 'package:firebase_sample/Screens/UI/Posts/post_tile.dart';
import 'package:firebase_sample/firebase/apis.dart';
import 'package:firebase_sample/utils/dialogs.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Homepage"),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 1,
                  onTap: () {
                    APIs().auth.signOut().then((value) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => LoginScreen()));
                    }).onError((error, stackTrace) {
                      Dialogs().showSnackbar(context, error.toString());
                    });
                  },
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Logout"),
                  ))
            ],
          )
        ],
      ),

      // body

      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return PostTileUi();
        },
      ),
    );
  }
}
