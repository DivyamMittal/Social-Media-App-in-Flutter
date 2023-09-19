import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sample/Models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

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

  Stream<DocumentSnapshot> getMyInfo() {
    return firestore.collection("Users").doc(curUser.uid).snapshots();
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

  Future<void> updateSelfInfo(String usernameText) async {
    await firestore
        .collection("Users")
        .doc(curUser.uid)
        .update({'name': me.name, 'username': usernameText, 'bio': me.bio});
  }

  Future<List<UserModel>> getAllUsers() async {
    final snapshot = await firestore.collection("Users").get();
    List<UserModel> users =
        snapshot.docs.map((e) => UserModel.fromJson(e.data())).toList();

    return users;
  }

  // to check the follow status
  Stream<bool> isFollow(UserModel user) {
    return firestore
        .collection("Users")
        .doc(curUser.uid)
        .collection("following")
        .doc(user.id)
        .snapshots()
        .map((snapshot) => snapshot.exists);
  }

  Future<void> followUser(UserModel user) async {
    // add the user to our following list
    await firestore
        .collection("Users")
        .doc(curUser.uid)
        .collection("following")
        .doc(user.id)
        .set(user.toJson());

    // add self to user followers list
    await firestore
        .collection("Users")
        .doc(user.id)
        .collection("followers")
        .doc(curUser.uid)
        .set(APIs.me.toJson());

    // set the count on profile Usermodel
    // int followingCount = await getFollowingCount(me) - 1;
    // await firestore
    //     .collection("Users")
    //     .doc(curUser.uid)
    //     .update({'following': (followingCount + 1).toString()});

    // // set the another user followers count
    // int followersCount = await getFollowersCount(user) - 1;
    // await firestore
    //     .collection("users")
    //     .doc(user.id)
    //     .update({'followers': (followersCount + 1).toString()});
  }

  Future<void> unFollowUser(UserModel user) async {
    // remove the user from our following list
    await firestore
        .collection("Users")
        .doc(curUser.uid)
        .collection("following")
        .doc(user.id)
        .delete();

    // remouve self from user followers list
    await firestore
        .collection("Users")
        .doc(user.id)
        .collection("followers")
        .doc(curUser.uid)
        .delete();

    // set the count on profile Usermodel
    // int followingCount = await getFollowingCount(me) - 1;
    // await firestore
    //     .collection("Users")
    //     .doc(curUser.uid)
    //     .update({'following': (followingCount - 1).toString()});

    // // set the another user followers count
    // int followersCount = await getFollowersCount(user) - 1;
    // await firestore
    //     .collection("users")
    //     .doc(user.id)
    //     .update({'followers': (followersCount - 1).toString()});
  }

  Future<QuerySnapshot> getFollowersIds(UserModel user) async {
    return await firestore
        .collection("Users")
        .doc(user.id)
        .collection("followers")
        .get();
  }

  Future<QuerySnapshot> getFollowingIds(UserModel user) async {
    return await firestore
        .collection("Users")
        .doc(user.id)
        .collection("following")
        .get();
  }

  Stream<QuerySnapshot> getFollowersList(UserModel user) {
    return firestore
        .collection("Users")
        .doc(user.id)
        .collection("followers")
        .snapshots();
  }

  Stream<QuerySnapshot> getFollowingList(UserModel user) {
    return firestore
        .collection("Users")
        .doc(user.id)
        .collection("following")
        .snapshots();
  }
}
