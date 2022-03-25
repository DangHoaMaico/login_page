import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:login_page/dialog_manager/dialog.dart';
import 'package:login_page/file_manager/file_manager.dart';
import 'package:login_page/model/User/User.dart';
import 'package:login_page/model/contact/contact.dart';

import 'package:shared_preferences/shared_preferences.dart';

class FireBaseManager {
  FileManager fileManager = FileManager();
  FirebaseStorage storage = FirebaseStorage.instance;
  late DatabaseReference refUser;
  late DatabaseReference refContact;
  late DatabaseReference database;
  late Reference refAvatar;
  late FirebaseFirestore firestore;
  late FirebaseAuth auth;
  FireBaseManager() {
    Firebase.initializeApp();
    firestore = FirebaseFirestore.instance;
    database = FirebaseDatabase.instance.ref();
    auth = FirebaseAuth.instance;
    storage = FirebaseStorage.instance;
    refUser = FirebaseDatabase.instance.ref("users");
    if (auth.currentUser != null) {
      refContact = FirebaseDatabase.instance
          .ref("contacts")
          .child(auth.currentUser!.uid)
          .push();
    }

    refAvatar = FirebaseStorage.instance.ref().child("image");
  }
  void SiginOut(BuildContext context) {
    showLoaderDialog(context, "Loading...");
    auth.signOut().then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Signout success! ")));
      Navigator.popAndPushNamed(context, "/login");
    });
  }

  Future<void> fecthContact() async {
    var contacts = <Contact>[];
    final doc = firestore
        .collection("contacts")
        .doc(auth.currentUser!.uid)
        .collection("contact_list")
        .snapshots();
    doc.forEach((element) async {
      contacts.clear();
      element.docs.forEach((element) {
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;
        contacts.add(Contact.fromJson(data));
      });
      await fileManager.saveBigList(contacts);
    });
  }

  Future signUp(String email, String password, String name, String phoneNumber,
      String address, BuildContext context) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);

      UserDetail detail = UserDetail(
          userCredential.user!.uid, name, email, "", phoneNumber, address);

      // refUser.child(userCredential.user!.uid).set(detail.toJson());
      UpdateUser(detail, context);

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "SignUp success! ",
      )));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        await showFlushBar(context, "Error",
            "The account already exists for that email,\nPlease use orther email to sign up!");
      }
    } catch (e) {
      showAlertDialog(context, "Error", e.toString());
    }
  }

  Future<void> pushContact(Contact contact, BuildContext context) async {
    try {
      return firestore
          .collection("contacts")
          .doc(auth.currentUser!.uid)
          .collection("contact_list")
          .doc(contact.uid)
          .set(contact.toJson());
    } catch (e) {
      showAlertDialog(context, "Error", e.toString());
    }
  }

  Future<void> listenContactsSnapshot(Function function) async {
    firestore
        .collection("contacts")
        .doc(auth.currentUser!.uid)
        .collection("contact_list")
        .snapshots()
        .listen((event) {
      function();
    });
  }

  Future<void> deleteContact(Contact contact, BuildContext context) async {
    try {
      firestore
          .collection("contacts")
          .doc(auth.currentUser!.uid)
          .collection("contact_list")
          .doc(contact.uid)
          .delete()
          .whenComplete(() => Navigator.pop(context));
    } catch (e) {
      Navigator.pop(context);
      showAlertDialog(context, "Error", e.toString());
    }
  }

  Future<void> UpdateUser(UserDetail userDetail, BuildContext context) async {
    try {
      return firestore
          .collection("users/")
          .doc(userDetail.uid)
          .set(userDetail.toJson());
    } catch (e) {
      showAlertDialog(context, "Error", e.toString());
    }
  }

  loadUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (auth.currentUser != null) {
        String user = jsonEncode(getUser());
        prefs.setString("user", user);
        Map userMap = jsonDecode(prefs.getString('user')!);
        UserDetail users = UserDetail.fromJson(userMap);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future login(String email, String password, BuildContext context) async {
    try {
      showLoaderDialog(context, "Loading...");
      await auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Login success! ")));
      Navigator.pushNamed(context, "/home");
    } catch (e) {
      Navigator.pop(context);

      showAlertDialog(context, "Error", e.toString());
    }
  }

  Future sendResetPassEmail(String email, BuildContext context) async {
    try {
      showLoaderDialog(context, "Loading...");
      await auth.sendPasswordResetEmail(email: email.trim()).whenComplete(() {
        Navigator.pop(context);
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "We have sent a message to your email. Please check your email! ")));
    } catch (e) {
      showAlertDialog(context, "Error", e.toString());
    }
  }

  Future<UserDetail> getUser() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        (await firestore.collection("users").doc(auth.currentUser!.uid).get());
    print(snapshot.data());
    return UserDetail.fromJson(snapshot.data() as Map);
  }

  Future<TaskSnapshot?> uploadFile(
      String filePath, BuildContext context) async {
    File file = File(filePath);
    try {
      await refAvatar.putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }
    return null;
  }

  Future<void> changePassword(
      String currentPassword, String newPassword, BuildContext context) async {
    // Prompt the user to enter their email and password
    String email = auth.currentUser!.email!;
    String password = currentPassword;

// Create a credential
    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password);
    try {
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential)
          .then((value) {
        auth.currentUser!.updatePassword(newPassword).then((value) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Change password success! ")));
        }).catchError((e) {
          Navigator.pop(context);
          showAlertDialog(context, "Error", e.toString());
        });
      }).catchError((e) {
        Navigator.pop(context);
        showAlertDialog(context, "Error", e.toString());
      });
    } catch (e) {
      Navigator.pop(context);
      showAlertDialog(context, "Error", e.toString());
    }
// Reauthenticate
  }
}
