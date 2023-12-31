// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_sample/Models/user_model.dart';
import 'package:firebase_sample/Screens/UI/Profile/edit_profile_screen.dart';
import 'package:firebase_sample/Screens/UI/Profile/followers_list.dart';
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
    late UserModel myInfo;
    return Scaffold(
      appBar: AppBar(
        title: Text(APIs.me.username),
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
      body: StreamBuilder(
          stream: APIs().getMyInfo(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              myInfo = UserModel.fromJson(
                  snapshot.data!.data() as Map<String, dynamic>);
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: CircleAvatar(
                            radius: 50,
                            backgroundImage: APIs.me.image.isEmpty
                                ? NetworkImage(
                                    "https://www.mountsinai.on.ca/wellbeing/our-team/team-images/person-placeholder/image")
                                : NetworkImage(APIs.me.image)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    // Name
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child: Text(
                          myInfo.name,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    // Bio
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child: Text(
                          myInfo.bio,
                          maxLines: 4,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text.rich(TextSpan(
                              text: APIs.me.numPosts,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                              children: [
                                TextSpan(
                                    text: "  Posts",
                                    style: TextStyle(fontSize: 16))
                              ])),
                          StreamBuilder(
                              stream: APIs().getFollowersList(APIs.me),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => FollowersList(
                                                    user: APIs.me,
                                                    initialIndex: 0,
                                                  )));
                                    },
                                    child: Text.rich(TextSpan(
                                        text: "${snapshot.data?.size}",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                        children: [
                                          TextSpan(
                                              text: " Followers",
                                              style: TextStyle(fontSize: 16))
                                        ])),
                                  );
                                } else {
                                  return CircularProgressIndicator();
                                }
                              }),
                          StreamBuilder(
                              stream: APIs().getFollowingList(APIs.me),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => FollowersList(
                                                    user: APIs.me,
                                                    initialIndex: 1,
                                                  )));
                                    },
                                    child: Text.rich(TextSpan(
                                        text: "${snapshot.data?.size}",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                        children: [
                                          TextSpan(
                                              text: " Following",
                                              style: TextStyle(fontSize: 16))
                                        ])),
                                  );
                                } else {
                                  return CircularProgressIndicator();
                                }
                              })
                        ],
                      ),
                    )
                  ]);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
