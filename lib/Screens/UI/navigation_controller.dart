// ignore_for_file: prefer_const_constructors

import 'package:firebase_sample/Screens/UI/activity_screen.dart';
import 'package:firebase_sample/Screens/UI/create_screen.dart';
import 'package:firebase_sample/Screens/UI/home_screen.dart';
import 'package:firebase_sample/Screens/UI/Profile/profile_screen.dart';
import 'package:firebase_sample/Screens/UI/search_screen.dart';
import 'package:firebase_sample/firebase/apis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    APIs();
  }

  var myIndex = 0;
  List<Widget> widgetList = [
    HomeScreen(),
    SearchScreen(),
    CreateScreen(),
    ActivityScreen(),
    FutureBuilder(
      future:
          APIs().getSelfInfo(), // Use the same instance to ensure consistency
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // You can use a loading indicator here
        } else if (snapshot.hasError) {
          return Text("Error loading profile"); // Handle error
        } else {
          return ProfileScreen(); // Pass the initialized me data
        }
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: myIndex,
          backgroundColor: Colors.black,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              myIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon:
                    myIndex == 0 ? Icon(Icons.home) : Icon(Icons.home_outlined),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.search,
                ),
                label: "Search"),
            BottomNavigationBarItem(
                icon: myIndex == 2
                    ? Icon(CupertinoIcons.add_circled_solid)
                    : Icon(CupertinoIcons.add_circled),
                label: "Create"),
            BottomNavigationBarItem(
                icon: myIndex == 3
                    ? Icon(CupertinoIcons.heart_fill)
                    : Icon(CupertinoIcons.heart),
                label: "Heart"),
            BottomNavigationBarItem(
                icon: myIndex == 4
                    ? Icon(
                        Icons.person,
                      )
                    : Icon(Icons.person_outline_outlined),
                label: "Profile"),
          ]),
      body: IndexedStack(
        index: myIndex,
        children: widgetList,
      ),
    );
  }
}
