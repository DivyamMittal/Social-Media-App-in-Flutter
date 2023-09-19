// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../firebase/apis.dart';

class PostTileUi extends StatelessWidget {
  const PostTileUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
                radius: 17,
                backgroundImage: AssetImage(APIs.me.image.isEmpty
                    ? "assets/images/placeholder.png"
                    : APIs.me.image)),
            title: Text(
              "Divyam",
              style: TextStyle(fontSize: 17),
            ),
            trailing: Icon(Icons.more_vert),
          ),

          // Image
          SizedBox(
            child: Image.asset("assets/images/placeholder.png"),
          ),

          // Like, comment button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.suit_heart,
                      size: 30,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Icon(
                      CupertinoIcons.chat_bubble,
                      size: 30,
                    ),
                  ],
                ),
                Icon(
                  Icons.bookmark_border,
                  size: 30,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
