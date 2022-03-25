import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:login_page/firebase_manager/firebase_manager.dart';
import 'package:login_page/model/User/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../decoration/style.dart';
import '../validate/validates.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);
  get title => null;
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordPage> {
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
                  "Forget password",
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
                        "Send Verify Mail",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await fireBaseManager.sendResetPassEmail(
                              emailController.text, context);

                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                        }
                      })),
              Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.fromLTRB(12, 50, 12, 8),
                  child: GestureDetector(
                    child: Text(
                      "Login",
                      style: textGray,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )),
              Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                  child: GestureDetector(
                    child: Text(
                      "Don't have account ? Sign up",
                      style: textGray,
                    ),
                    onTap: () {
                      Navigator.popAndPushNamed(context, "/signup");
                    },
                  )),
            ],
          ),
        ));
  }
}
