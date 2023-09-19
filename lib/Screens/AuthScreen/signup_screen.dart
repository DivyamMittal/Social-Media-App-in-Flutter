// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:firebase_sample/Screens/AuthScreen/login_page.dart';
import 'package:firebase_sample/firebase/apis.dart';
import 'package:firebase_sample/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/username_provider.dart';
import '../UI/home_screen.dart';
import '../UI/navigation_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _nameController = TextEditingController();
    final _usernameController = TextEditingController();

    bool usernameAvailable = false;

    final usernameProvider = Provider.of<UsernameProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SignUp",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Name
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: "eg. john",
                            label: Text("Name"),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter your name";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        onChanged: (value) async {
                          if (await APIs().checkUsernameAvailability(
                              _usernameController.text)) {
                            bool isAvailable = await APIs()
                                .checkUsernameAvailability(
                                    _usernameController.text);
                            usernameProvider.usernameAvailable = isAvailable;
                          } else {
                            usernameProvider.usernameAvailable = false;
                          }
                        },
                        controller: _usernameController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.verified_user_outlined),
                            hintText: "Enter Username",
                            label: Text("Username"),
                            suffix: SizedBox(
                              child: InkWell(
                                  onTap: () async {
                                    if (await APIs().checkUsernameAvailability(
                                        _usernameController.text)) {
                                      bool isAvailable = await APIs()
                                          .checkUsernameAvailability(
                                              _usernameController.text);
                                      usernameProvider.usernameAvailable =
                                          isAvailable;
                                    } else {
                                      usernameProvider.usernameAvailable =
                                          false;
                                    }
                                    // usernameProvider
                                    //     .updateUsernameAvailability();
                                    // log("username available: $usernameAvailable");
                                    // log("username: ${await APIs().checkUsernameAvailability("divyam")}");
                                  },
                                  child: Text("Check")),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Username";
                          } else if (value.length < 3) {
                            return "Username must be 3 charater long";
                          } else if (usernameProvider.usernameAvailable ==
                              false) {
                            return "username not available";
                          } else {
                            return null;
                          }
                        },
                      ),
                      Consumer<UsernameProvider>(
                        builder: (context, value, child) => SizedBox(
                          child: _usernameController.text.length >= 3
                              ? usernameProvider.usernameAvailable == true
                                  ? Text(
                                      "Username available",
                                      style: TextStyle(color: Colors.green),
                                    )
                                  : Text(
                                      "Username not available",
                                      style: TextStyle(color: Colors.red),
                                    )
                              : null,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.mail),
                            hintText: "abc@abc.com",
                            label: Text("Email"),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Email";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: "Password",
                            label: Text("Password"),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Password";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate() &&
                                    usernameProvider.usernameAvailable ==
                                        true) {
                                  await APIs()
                                      .auth
                                      .createUserWithEmailAndPassword(
                                          email:
                                              _emailController.text.toString(),
                                          password: _passwordController.text
                                              .toString())
                                      .then((value) {
                                    // creating user in firestore

                                    APIs().createUser(
                                        _nameController.text,
                                        _emailController.text,
                                        _usernameController.text);

                                    // showing snakbar
                                    Dialogs()
                                        .showSnackbar(context, "User Created");

                                    // Navigating
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                NavigationScreen()));
                                  }).onError((error, stackTrace) {
                                    Dialogs().showSnackbar(
                                        context, error.toString());
                                  });
                                }
                              },
                              style: ButtonStyle(
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)))),
                              child: Text("Sign Up"))),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
              Divider(
                thickness: 1,
                color: Colors.black,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? "),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => LoginScreen()));
                      },
                      child: Text("Login"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
