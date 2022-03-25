import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:login_page/firebase_manager/firebase_manager.dart';
import 'package:login_page/model/User/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../decoration/style.dart';
import '../validate/validates.dart';

class name extends StatefulWidget {
  name({Key? key}) : super(key: key);

  @override
  State<name> createState() => _nameState();
}

class _nameState extends State<name> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  get title => null;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FireBaseManager fireBaseManager = FireBaseManager();
  @override
  initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Stack(children: [
        Positioned(
          child: Image.asset('asset/images/backgroud.jpg'),
          top: 0,
        ),
        Positioned(
          child: loginWidget(),
          top: 290,
          bottom: 0,
          left: 0,
          right: 0,
        ),
        Container(
          height: 800,
        )
      ])),
    );
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Widget loginWidget() {
    return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(12, 40, 30, 20),
                alignment: Alignment.topLeft,
                child: const Text(
                  "Sign In",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: TextFormField(
                  controller: emailController,
                  decoration: textFeildDecoration("Email"),
                  validator: (value) {
                    return validateEmail(value!);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: textFeildDecoration("Password"),
                  validator: (value) {
                    return validatePassword(value!);
                  },
                ),
              ),
              Container(
                  width: double.infinity,
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromRGBO(254, 156, 128, 1)),
                          overlayColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 252, 148, 119))),
                      child: const Text(
                        "Sign in",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await fireBaseManager.login(emailController.text,
                              passwordController.text, context);
                          loadUser();
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                        }
                      })),
              Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.fromLTRB(12, 25, 12, 8),
                  child: GestureDetector(
                    child: Text(
                      "Forgot password ?",
                      style: textGray,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/forgotPassword");
                    },
                  )),
              Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.fromLTRB(12, 50, 12, 8),
                  child: GestureDetector(
                    child: Text(
                      "Don't have account ? Sign up",
                      style: textGray,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                  )),
            ],
          ),
        ));
  }

  loadUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (fireBaseManager.auth.currentUser != null) {
        String user = jsonEncode(fireBaseManager.getUser());
        prefs.setString("user", user);
        Map userMap = jsonDecode(prefs.getString('user')!);
        UserDetail users = UserDetail.fromJson(userMap);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
