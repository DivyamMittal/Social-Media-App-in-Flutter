// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:firebase_sample/Models/user_model.dart';
import 'package:firebase_sample/Screens/UI/Profile/profile_screen.dart';
import 'package:firebase_sample/Screens/UI/UserProfile/user_profile.dart';
import 'package:firebase_sample/firebase/apis.dart';
import 'package:firebase_sample/utils/profile_search_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<UserModel> searchList = [];
  List<UserModel> _list = [];

  // value notifier
  ValueNotifier<List<UserModel>> userList = ValueNotifier<List<UserModel>>([]);

  @override
  Widget build(BuildContext context) {
    var _searchController = TextEditingController();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color.fromARGB(255, 32, 32, 32)),
            child: TextField(
              controller: _searchController,
              onChanged: (value) async {
                searchList.clear();
                if (value.isNotEmpty) {
                  _list = await APIs().getAllUsers();
                  for (var i in _list) {
                    if (i.name.toLowerCase().contains(value.toLowerCase()) ||
                        i.username
                            .toLowerCase()
                            .contains(value.toLowerCase())) {
                      searchList.add(i);
                    }
                  }
                  for (var i in searchList) {
                    log("${i.name}");
                  }
                }
                userList.value =
                    List<UserModel>.from(searchList); // Trigger rebuild
              },
              decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(CupertinoIcons.search),
                  border: UnderlineInputBorder(borderSide: BorderSide.none)),
            ),
          ),
        ),
        body: ValueListenableBuilder<List<UserModel>>(
          valueListenable: userList,
          builder:
              (BuildContext context, List<UserModel> value, Widget? child) {
            return ListView.builder(
              itemCount: searchList.length,
              itemBuilder: (context, index) {
                if (_searchController.text.isNotEmpty) {
                  return InkWell(
                      onTap: () {
                        if (searchList[index].username == APIs.me.username) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ProfileScreen()));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) =>
                                  UserProfile(user: searchList[index])));
                        }
                      },
                      child: ProfileSearchTile(user: searchList[index]));
                }
              },
            );
          },
        ),

        // ListView.builder(
        //   itemCount: searchList.length,
        //   itemBuilder: (context, index) {
        //     // searchList.map((e) => ProfileSearchTile(user: e)).toList()
        //     return ProfileSearchTile(user: searchList[index]);
        //     // if (_searchController.text.isEmpty) {
        //     //   return Container();
        //     // } else {
        //     //   log("search tile appaer");
        //     //   return ProfileSearchTile(user: searchList[index]);
        //     // }
        //   },
        // )
      ),
    );
  }
}
