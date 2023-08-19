import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sample/Models/user_model.dart';

class APIs {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // to store current user
  User get curUser => auth.currentUser!;

  // to store current user self info
  static late UserModel me;

  // to check username is available or not
  Future<bool> checkUsernameAvailability(String username) async {
    final QuerySnapshot snapshot = await firestore
        .collection("Users")
        .where('username', isEqualTo: username)
        .get();
    return snapshot.docs.isEmpty;
  }

  Future<void> createUser(String name, String email, String username) async {
    final time = DateTime.now().millisecondsSinceEpoch;
    final cUser = UserModel(
        id: curUser.uid,
        name: name,
        username: username,
        email: email,
        bio: "Hey",
        image: "",
        createdAt: time.toString(),
        lastActive: time.toString(),
        numPosts: "0",
        following: "0",
        followers: "0",
        isOnline: false);

    await firestore.collection("Users").doc(curUser.uid).set(cUser.toJson());
  }

  Future<void> getSelfInfo() async {
    await firestore
        .collection("Users")
        .doc(curUser.uid)
        .get()
        .then((user) async {
      me = UserModel.fromJson(user.data()!);
    }).onError((error, stackTrace) {
      log("error getSelfInfo: $error");
    });
  }

  Future<void> updateSelfInfo() async {
    await firestore
        .collection("Users")
        .doc(curUser.uid)
        .update({'name': me.name, 'bio': me.bio});
  }
}
