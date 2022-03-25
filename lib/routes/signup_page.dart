import 'package:flutter/material.dart';
import 'package:login_page/dialog_manager/dialog.dart';
import 'package:login_page/firebase_manager/firebase_manager.dart';

import '../decoration/style.dart';
import '../validate/validates.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);
  get title => null;
  @override
  State<SignupPage> createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  FireBaseManager baseManager = FireBaseManager();
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
          child: signupWidget(),
          top: 50,
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
  final verifyPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();
  Widget signupWidget() {
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
                  "Sign Up",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: TextFormField(
                  controller: nameController,
                  decoration: textFeildDecoration("Your name"),
                  validator: (value) {
                    return validateStringNotEmty(value!);
                  },
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
                  controller: phoneNumberController,
                  decoration: textFeildDecoration("Phone Number"),
                  validator: (value) {
                    return validatePhone(value!);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: TextFormField(
                  controller: addressController,
                  decoration: textFeildDecoration("Address"),
                  validator: (value) {
                    return validateStringNotEmty(value!);
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
                margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: TextFormField(
                  controller: verifyPasswordController,
                  obscureText: true,
                  decoration: textFeildDecoration("Verify password"),
                  validator: (value) {
                    return validateVerifyPassword(
                        passwordController.text, value!);
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
                        "Sign up",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          showLoaderDialog(context, "Loading...");
                          baseManager
                              .signUp(
                                  emailController.text,
                                  passwordController.text,
                                  nameController.text,
                                  phoneNumberController.text,
                                  addressController.text,
                                  context)
                              .whenComplete(() => Navigator.pop(context));
                          FocusScope.of(context).unfocus();
                        }
                      })),
              Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.fromLTRB(12, 50, 12, 8),
                  child: GestureDetector(
                    child: Text(
                      "You have account ? Sign in",
                      style: textGray,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )),
            ],
          ),
        ));
  }
}
