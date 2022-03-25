import 'package:flutter/material.dart';
import 'package:login_page/dialog_manager/dialog.dart';
import 'package:login_page/firebase_manager/firebase_manager.dart';

import '../colors/color.dart';
import '../decoration/style.dart';
import '../validate/validates.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);
  get title => null;
  @override
  State<ChangePasswordPage> createState() => ChangePasswordPageState();
}

class ChangePasswordPageState extends State<ChangePasswordPage> {
  FireBaseManager baseManager = FireBaseManager();
  @override
  initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.primaryColor,
        title: const Text('Change password'),
      ),
      body: SingleChildScrollView(child: signupWidget()),
    );
  }

  final newPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final verifyPasswordController = TextEditingController();

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
                margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: textFeildDecoration("Your Password"),
                  validator: (value) {
                    return validatePassword(value!);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: TextFormField(
                  obscureText: true,
                  controller: newPasswordController,
                  decoration: textFeildDecoration("New password"),
                  validator: (value) {
                    return validatePassword(value!);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: TextFormField(
                  obscureText: true,
                  controller: verifyPasswordController,
                  decoration: textFeildDecoration("Verify password"),
                  validator: (value) {
                    return validateVerifyPassword(
                        newPasswordController.text, value!);
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
                              MyColor.primaryColor),
                          overlayColor: MaterialStateProperty.all<Color>(
                              MyColor.secondColor)),
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          showLoaderDialog(context, "Loading...");
                          baseManager.changePassword(passwordController.text,
                              newPasswordController.text, context);
                        }
                        FocusScope.of(context).unfocus();
                      })),
            ],
          ),
        ));
  }
}
