import 'package:flutter/material.dart';

class Dialogs {
  void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.black54.withOpacity(0.7),
      behavior: SnackBarBehavior.floating,
    ));
  }
}
