// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_sample/Models/user_model.dart';
import 'package:firebase_sample/Screens/UI/Profile/edit_profile_screen.dart';
import 'package:firebase_sample/Screens/UI/Profile/followers_list.dart';
import 'package:firebase_sample/firebase/apis.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({
    super.key,
    required this.user,
  });
  final UserModel user;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late bool isFollowing;

  @override
  Widget build(BuildContext context) {
    // bool isFollowing = await APIs().isFollow(widget.user);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.user.username),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: StreamBuilder<bool>(
          stream: APIs().isFollow(widget.user),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child:
                      CircularProgressIndicator()); // Display a loading indicator while waiting
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              bool isFollowing = snapshot.data ?? false;

              // content
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
                          widget.user.name,
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
                          widget.user.bio,
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
                              text: widget.user.numPosts,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                              children: [
                                TextSpan(
                                    text: "  Posts",
                                    style: TextStyle(fontSize: 16))
                              ])),
                          StreamBuilder(
                              stream: APIs().getFollowersList(widget.user),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => FollowersList(
                                                    user: widget.user,
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
                                  return Container();
                                }
                              }),
                          StreamBuilder(
                              stream: APIs().getFollowingList(widget.user),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => FollowersList(
                                                    user: widget.user,
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
                                  return Container();
                                }
                              })
                        ],
                      ),
                    ),

                    // follow button
                    Row(
                      mainAxisAlignment: isFollowing
                          ? MainAxisAlignment.spaceEvenly
                          : MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            if (isFollowing) {
                              APIs().unFollowUser(widget.user);
                              isFollowing = false;
                            } else {
                              APIs().followUser(widget.user);
                              isFollowing = true;
                            }
                            // setState(() {});
                          },
                          color: isFollowing
                              ? Color.fromARGB(255, 77, 77, 77)
                              : Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: isFollowing
                              ? Text(
                                  "Unfollow",
                                  style: TextStyle(fontSize: 16),
                                )
                              : Text(
                                  "Follow",
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),

                        // message button
                        // isFollowing
                        //     ? MaterialButton(
                        //         onPressed: () {},
                        //         color: const Color.fromARGB(255, 77, 77, 77),
                        //         shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(10)),
                        //         child: Text(
                        //           "Message",
                        //           style: TextStyle(fontSize: 16),
                        //         ),
                        //       )
                        //     : SizedBox()
                      ],
                    ),
                  ]);
            }
          },
        ));
  }
}
