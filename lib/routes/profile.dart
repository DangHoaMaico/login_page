import 'dart:io';

import 'package:animate_icons/animate_icons.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_page/colors/color.dart';
import 'package:login_page/decoration/style.dart';
import 'package:login_page/dialog_manager/dialog.dart';
import 'package:login_page/firebase_manager/firebase_manager.dart';
import 'package:login_page/validate/validates.dart';
import 'package:login_page/widget/avatar.dart';
import 'package:login_page/model/User/User.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FireBaseManager fireBaseManager = FireBaseManager();
  final picker = ImagePicker();
  late UserDetail user = UserDetail("", "", "", "", "", "");
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  late AnimateIconController editController, backController;

  bool isEdit = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    editController = AnimateIconController();
    backController = AnimateIconController();
    loadData();
  }

  File? _image;
  String? _imageUrl;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: MyColor.primaryColor,
            title: const Text('Edit Profile'),
            actions: [
              IconButton(
                icon: Icon(isEdit ? Icons.check : Icons.edit),
                onPressed: () {
                  if (isEdit == true) {
                    UpadateUserAndUploadImage();
                  } else {
                    setState(() {
                      isEdit = true;
                    });
                  }
                },
              ),
            ],
            leading: IconButton(
              icon: Icon(isEdit ? Icons.close : Icons.arrow_back),
              onPressed: () {
                if (isEdit == true) {
                  setState(() {
                    isEdit = false;
                  });
                  loadData();
                } else {
                  Navigator.pop(context);
                }
              },
            )),
        body: SingleChildScrollView(
          child: Center(
              child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: [
                    Positioned(
                      child: Container(
                          margin: const EdgeInsets.all(12),
                          child: CircleAvatar(
                            backgroundImage: _imageUrl != null
                                ? NetworkImage(_imageUrl!)
                                : null,
                            backgroundColor: MyColor.secondColor,
                            child: (_image != null)
                                ? Container(
                                    width: 120.0,
                                    height: 120.0,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: FileImage(_image!))))
                                : _imageUrl == null
                                    ? Text("A")
                                    : Text(""),
                            radius: 55,
                          )),
                    ),
                    isEdit
                        ? Positioned(
                            bottom: -10,
                            left: 50,
                            right: 0,
                            child: Opacity(
                              child: Container(
                                  height: 40,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red),
                                  margin: const EdgeInsets.all(12),
                                  child: IconButton(
                                    onPressed: () {
                                      getImage();
                                    },
                                    icon: const Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  )),
                              opacity: 0.7,
                            ))
                        : Positioned(
                            bottom: -10,
                            left: 50,
                            right: 0,
                            child: Container(),
                          )
                  ],
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                          child: TextFormField(
                            enabled: isEdit,
                            controller: nameController,
                            decoration: textFeildDecoration("Name"),
                            validator: (value) {
                              return validateStringNotEmty(value!);
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                          child: TextFormField(
                            enabled: isEdit,
                            controller: emailController,
                            decoration: textFeildDecoration("Email "),
                            validator: (value) {
                              return validateEmail(value!);
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                          child: TextFormField(
                            enabled: isEdit,
                            controller: phoneNumberController,
                            decoration: textFeildDecoration("Phone number"),
                            validator: (value) {
                              return validatePhone(value);
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                          child: TextFormField(
                            enabled: isEdit,
                            controller: addressController,
                            decoration: textFeildDecoration("Address"),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          )),
        ));
  }

  loadData() async {
    user = await fireBaseManager.getUser();
    nameController.text = user.name;
    phoneNumberController.text = user.phoneNumber;
    addressController.text = user.address;
    emailController.text = user.email;
    _imageUrl = user.urlAvatar;
    print(user.name);
    setState(() {});
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void UpadateUserAndUploadImage() {
    showLoaderDialog(context, "Saving...");
    UserDetail userDetail = UserDetail(
        fireBaseManager.auth.currentUser!.uid,
        nameController.text,
        emailController.text,
        user.urlAvatar,
        phoneNumberController.text,
        addressController.text);
    Reference reference = fireBaseManager.storage
        .ref()
        .child("Image")
        .child(fireBaseManager.refContact.key!);
    try {
      if (_image != null) {
        UploadTask uploadTask = reference.putFile(File(_image!.path));
        uploadTask.whenComplete(() async {
          String imageUrl = await reference.getDownloadURL();
          userDetail.urlAvatar = imageUrl;
          UpdateUser(userDetail, "Saving success");
        });
      } else {
        UpdateUser(userDetail, "Saving success");
      }
    } catch (ex) {
      Navigator.pop(context);
      showAlertDialog(context, "Error", ex.toString());
    }
  }

  void UpdateUser(UserDetail userDetail, String content) {
    fireBaseManager.UpdateUser(userDetail, context).whenComplete(() {
      Navigator.pop(context);
      showSuccessDialog(context, content, () {
        setState(() {
          isEdit = false;
        });
        Navigator.pop(context);
      });
    });
  }
}
