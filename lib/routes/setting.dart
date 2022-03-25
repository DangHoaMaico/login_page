import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:login_page/colors/color.dart';
import 'package:login_page/decoration/style.dart';
import 'package:login_page/firebase_manager/firebase_manager.dart';
import 'package:login_page/model/User/User.dart';

import 'package:login_page/widget/avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  late SharedPreferences prefs;

  late UserDetail user = UserDetail("", "", "", "", "", "");
  FireBaseManager fireBaseManager = FireBaseManager();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.primaryColor,
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(10, 30, 0, 0),
              child: Text(
                "Setting",
                style: GoogleFonts.aBeeZee(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Row(
                  children: <Widget>[
                    avatar(user.urlAvatar, 40),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        textDirection: TextDirection.ltr,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              "Hi",
                              style: textGray,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            width: 150,
                            child: Text(
                              user.name,
                              style: GoogleFonts.aBeeZee(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: 150,
                            child: Text(
                              user.email,
                              style: GoogleFonts.aBeeZee(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.fromLTRB(20, 15, 0, 0),
                      child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: MyColor.titleColor,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, "/profile");
                          }),
                    )
                  ],
                )),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.fromLTRB(10, 30, 0, 0),
              child: Text(
                "Your profile",
                style: GoogleFonts.aBeeZee(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.normal),
              ),
            ),
            Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.fromLTRB(10, 30, 0, 0),
                child: GestureDetector(
                  child: Text(
                    "Change password",
                    style: GoogleFonts.aBeeZee(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.normal),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/changePassword");
                  },
                )),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.fromLTRB(10, 30, 0, 0),
              child: GestureDetector(
                child: Text(
                  "Signout",
                  style: GoogleFonts.aBeeZee(
                      fontSize: 20,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  fireBaseManager.SiginOut(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  LoadData() async {
    user = await fireBaseManager.getUser();
    setState(() {});
  }
}
