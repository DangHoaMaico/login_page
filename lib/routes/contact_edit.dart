import 'dart:io';

import 'package:animate_icons/animate_icons.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_page/colors/color.dart';
import 'package:login_page/decoration/style.dart';
import 'package:login_page/dialog_manager/dialog.dart';
import 'package:login_page/file_manager/file_manager.dart';
import 'package:login_page/firebase_manager/firebase_manager.dart';

import 'package:login_page/model/contact/contact.dart';
import 'package:login_page/validate/validates.dart';

class ContactEdit extends StatefulWidget {
  String idContact;
  ContactEdit({Key? key, required this.idContact}) : super(key: key);

  @override
  State<ContactEdit> createState() => _ContactEditState();
}

class _ContactEditState extends State<ContactEdit> {
  FileManager _fileManager = FileManager();
  FireBaseManager fireBaseManager = FireBaseManager();
  final picker = ImagePicker();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  late AnimateIconController editController, backController;
  late Contact contact = Contact(
      "uid", "name", "email", "urlAvatar", "phoneNumber", "address", false);
  bool isEdit = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.idContact);
    getContact(widget.idContact);
    editController = AnimateIconController();
    backController = AnimateIconController();
  }

  File? _image;
  String? _imageUrl;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: MyColor.primaryColor,
            title: const Text('Edit Contact'),
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
            centerTitle: true,
            leading: IconButton(
              icon: Icon(isEdit ? Icons.close : Icons.arrow_back),
              onPressed: () {
                if (isEdit == true) {
                  setState(() {
                    isEdit = false;
                  });
                  getContact(widget.idContact);
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
                                    ? Text(contact.name[0])
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
    nameController.text = contact.name;
    phoneNumberController.text = contact.phoneNumber;
    addressController.text = contact.address;
    emailController.text = contact.email;
    _imageUrl = contact.urlAvatar;
    print("loaddata" + nameController.text);
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

  Future<void> getContact(String uid) async {
    final doc = await fireBaseManager.firestore
        .collection("contacts")
        .doc(fireBaseManager.auth.currentUser!.uid)
        .collection("contact_list")
        .doc(uid)
        .snapshots();
    doc.forEach((element) {
      Map<String, dynamic> data = element.data() as Map<String, dynamic>;
      setState(() {
        contact = Contact.fromJson(data);
      });
      loadData();
    });
  }

  Future<void> UpadateUserAndUploadImage() async {
    showLoaderDialog(context, "Saving...");

    Contact userDetail = Contact(
        contact.uid,
        nameController.text,
        emailController.text,
        contact.urlAvatar,
        phoneNumberController.text,
        addressController.text,
        contact.isMark);
    bool checkPhone = await checkExitPhone(userDetail);
    if (checkPhone == false) {
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
            contact = userDetail;
            loadData();
            UpdateContact(userDetail, "Saving success");
          });
        } else {
          contact = userDetail;
          loadData();
          UpdateContact(userDetail, "Saving success");
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

  Future<void> UpdateContact(Contact contact, String content) async {
    await fireBaseManager.pushContact(contact, context).whenComplete(() {
      Navigator.pop(context);
      showSuccessDialog(context, content, () {
        setState(() {
          isEdit = false;
        });
        Navigator.pop(context);
      });
    });
  }

  Future<bool> checkExitPhone(Contact contact) async {
    List<Contact> list = await _fileManager.loadBigList();
    for (Contact item in list) {
      if (item.phoneNumber == contact.phoneNumber) {
        if (contact.uid != item.uid) {
          return true;
        }
      }
    }
    return false;
  }
}
