import 'dart:math';
import 'package:external_path/external_path.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:json_store/json_store.dart';
import 'package:login_page/file_manager/file_manager.dart';
import 'package:login_page/firebase_manager/firebase_manager.dart';
import 'package:login_page/model/User/contact.dart';
import 'package:login_page/routes/add_contact.dart';
import 'package:login_page/routes/change_password.dart';
import 'package:login_page/routes/contact_edit.dart';
import 'package:login_page/routes/contact_list.dart';
import 'package:login_page/routes/forgot_password.dart';
import 'package:login_page/routes/home.dart';
import 'package:login_page/routes/profile.dart';
import 'package:login_page/routes/splash_screen.dart';

import 'routes/contact_detail.dart';
import 'routes/login_page.dart';
import 'routes/signup_page.dart';

JsonStore jsonStore = JsonStore();
FileManager fileManager = FileManager();
FireBaseManager fireBase = FireBaseManager();
Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        routes: {
          "/splashScreen": (context) => SplashScreen(),
          "/login": (context) => const LoginPage(),
          "/signup": (context) => const SignupPage(),
          "/contactList": (context) => ContactList(),
          "/addContact": (context) => const AddContact(),
          "/home": (context) => Home(),
          "/profile": (context) => Profile(),
          "/contactDetail": (context) => ContactDetail(
                idContact: "",
              ),
          "/contactEdit": (context) => ContactEdit(
                idContact: '',
              ),
          "/changePassword": (context) => const ChangePasswordPage(),
          "/forgotPassword": (context) => const ForgotPasswordPage(),
        });
  }
}
