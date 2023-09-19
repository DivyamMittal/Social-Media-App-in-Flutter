// ignore_for_file: prefer_const_constructors

import 'package:firebase_sample/Models/user_model.dart';
import 'package:flutter/material.dart';

class ProfileSearchTile extends StatelessWidget {
  const ProfileSearchTile({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: SizedBox(
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage("assets/images/placeholder.png"),
          ),
          title: Text(
            user.name,
            style: TextStyle(fontSize: 18),
          ),
          subtitle: Text(
            user.username,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
