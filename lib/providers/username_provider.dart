import 'package:firebase_sample/firebase/apis.dart';
import 'package:flutter/material.dart';

class UsernameProvider extends ChangeNotifier {
  bool usernameAvailable = false;

  Future<bool> checkUsername(String username) async {
    return await APIs().checkUsernameAvailability(username);
  }

  void updateUsernameAvailability() {
    notifyListeners();
  }
}
