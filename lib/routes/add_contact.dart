import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_page/colors/color.dart';
import 'package:login_page/file_manager/file_manager.dart';

import 'package:login_page/firebase_manager/firebase_manager.dart';

import '../decoration/style.dart';

import '../dialog_manager/dialog.dart';
import '../model/contact/contact.dart';
import '../validate/validates.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  FileManager _fileManager = FileManager();
  FireBaseManager _baseManager = FireBaseManager();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  double? _progress;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor.primaryColor,
          title: const Text('Detail'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.save_outlined),
              // ignore: avoid_print
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  PushContactAndUploadImage();
                }
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: _isLoading
              ? SizedBox(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: _progress,
                      semanticsLabel: "Đang lưu dữ liệu",
                    ),
                  ))
              : Container(
                  margin: const EdgeInsets.fromLTRB(12, 20, 12, 20),
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: [
                          Positioned(
                            child: Container(
                                margin: const EdgeInsets.all(12),
                                child: CircleAvatar(
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
                                      : Text("N"),
                                  radius: 55,
                                )),
                          ),
                          Positioned(
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
                        ],
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin:
                                    const EdgeInsets.fromLTRB(12, 12, 12, 8),
                                child: TextFormField(
                                  controller: nameController,
                                  decoration: textFeildDecoration("Name"),
                                  validator: (value) {
                                    return validateStringNotEmty(value!);
                                  },
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.fromLTRB(12, 12, 12, 8),
                                child: TextFormField(
                                  controller: emailController,
                                  decoration: textFeildDecoration("Email "),
                                  validator: (value) {
                                    return validateEmail(value!);
                                  },
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.fromLTRB(12, 12, 12, 8),
                                child: TextFormField(
                                  controller: phoneNumberController,
                                  decoration:
                                      textFeildDecoration("Phone number"),
                                  validator: (value) {
                                    return validatePhone(value);
                                  },
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.fromLTRB(12, 12, 12, 8),
                                child: TextFormField(
                                  controller: addressController,
                                  decoration: textFeildDecoration("Address"),
                                ),
                              ),
                            ],
                          )),
                    ],
                  )),
        ));
  }

  Future<void> PushContactAndUploadImage() async {
    showLoaderDialog(context, "Saving...");

    Contact contact = Contact(
        _baseManager.refContact.key!,
        nameController.text,
        emailController.text,
        "",
        phoneNumberController.text,
        addressController.text,
        false);
    bool checkPhone = await checkExitPhone(contact);
    if ((checkPhone == false)) {
      Reference reference = _baseManager.storage
          .ref()
          .child("Image")
          .child(_baseManager.refContact.key!);
      try {
        if (_image != null) {
          UploadTask uploadTask = reference.putFile(File(_image!.path));
          uploadTask.whenComplete(() async {
            String imageUrl = await reference.getDownloadURL();
            contact.urlAvatar = imageUrl;
            PushContact(contact, "Saving success");
          });
        } else {
          PushContact(contact, "Saving success");
        }
      } catch (ex) {
        Navigator.pop(context);
        showAlertDialog(context, "Error", ex.toString());
      }
    } else {
      Navigator.pop(context);
      showAlertDialog(context, "Error", "Phone number already exists!");
    }
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

  void PushContact(Contact contact, String content) {
    _baseManager.pushContact(contact, context).whenComplete(() {
      Navigator.pop(context);
      showSuccessDialog(context, content, () {
        Navigator.pop(context);
      });
    });
  }

  Future<bool> checkExitPhone(Contact contact) async {
    List<Contact> list = await _fileManager.loadBigList();
    for (Contact item in list) {
      if (item.phoneNumber == contact.phoneNumber) {
        return true;
      }
    }
    return false;
  }
}
