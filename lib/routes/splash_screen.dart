import 'dart:async';

import 'package:flutter/material.dart';
import 'package:login_page/colors/color.dart';
import 'package:login_page/decoration/style.dart';
import 'package:login_page/firebase_manager/firebase_manager.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FireBaseManager _baseManager = FireBaseManager();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.secondColor,
      body: Center(
        child: Container(
          child: icon(),
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();
    Timer timer = Timer(Duration(seconds: 1), () async {
      if (_baseManager.auth.currentUser != null) {
        await _baseManager.fecthContact();
        Navigator.popAndPushNamed(context, "/home");
      } else {
        Navigator.popAndPushNamed(context, "/login");
      }
    });
  }

  Widget icon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(10),
          child: const Icon(
            Icons.account_box_sharp,
            size: 80,
            color: Colors.white,
          ),
        ),
        Container(
          margin: EdgeInsets.all(20),
          child: Text(
            "Contact App",
            style: texth2,
          ),
        ),
        CircularProgressIndicator()
      ],
    );
  }
}
