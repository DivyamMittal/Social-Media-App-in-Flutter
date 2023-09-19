// ignore_for_file: prefer_const_constructors

import 'package:firebase_sample/Models/user_model.dart';
import 'package:firebase_sample/firebase/apis.dart';
import 'package:firebase_sample/utils/profile_search_tile.dart';
import 'package:flutter/material.dart';

import '../UserProfile/user_profile.dart';

class FollowersList extends StatelessWidget {
  const FollowersList(
      {super.key, required this.user, required this.initialIndex});
  final UserModel user;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    List<UserModel> _followingList = [];
    List<UserModel> _followersList = [];
    return DefaultTabController(
      length: 2,
      initialIndex: initialIndex,
      child: Scaffold(
        appBar: AppBar(
          title: Text(user.username),
          bottom: TabBar(indicatorColor: Colors.white, tabs: const [
            Tab(
              text: 'Followers',
            ),
            Tab(
              text: 'Following',
            )
          ]),
        ),
        body: TabBarView(children: [
          // followers
          FutureBuilder(
            future: APIs().getFollowersIds(user),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data?.docs;
                _followersList = data
                        ?.map((e) => UserModel.fromJson(
                            e.data() as Map<String, dynamic>))
                        .toList() ??
                    [];
                return ListView.builder(
                  itemCount: snapshot.data?.size,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) =>
                                  UserProfile(user: _followersList[index])));
                        },
                        child: ProfileSearchTile(user: _followersList[index]));
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),

          // following
          FutureBuilder(
            future: APIs().getFollowingIds(user),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data?.docs;
                _followingList = data
                        ?.map((e) => UserModel.fromJson(
                            e.data() as Map<String, dynamic>))
                        .toList() ??
                    [];
                return ListView.builder(
                  itemCount: snapshot.data?.size,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) =>
                                  UserProfile(user: _followingList[index])));
                        },
                        child: ProfileSearchTile(user: _followingList[index]));
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ]),
      ),
    );
  }
}
