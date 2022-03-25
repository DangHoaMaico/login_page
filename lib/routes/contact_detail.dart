import 'package:flutter/material.dart';

import 'package:login_page/colors/color.dart';
import 'package:login_page/decoration/style.dart';
import 'package:login_page/dialog_manager/dialog.dart';
import 'package:login_page/firebase_manager/firebase_manager.dart';
import 'package:login_page/main.dart';

import 'package:login_page/model/contact/contact.dart';
import 'package:login_page/routes/contact_edit.dart';

import 'package:url_launcher/url_launcher.dart';

class ContactDetail extends StatefulWidget {
  String idContact;
  ContactDetail({Key? key, required this.idContact})
      : super(
          key: key,
        );

  @override
  State<ContactDetail> createState() => _ContactDetailState();
}

class _ContactDetailState extends State<ContactDetail> {
  FireBaseManager fireBaseManager = FireBaseManager();

  late Contact contact = Contact("", "N", "", "", "", "", false);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContact(widget.idContact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColor.primaryColor,
        appBar: AppBar(
          actions: [
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Edit', 'Delete'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
          backgroundColor: MyColor.primaryColor,
          title: Text("Contact "),
          centerTitle: true,
        ),
        body: Center(
            child: Container(
          child: Column(
            children: <Widget>[
              Stack(children: [
                Positioned(
                    child: Container(
                  margin: const EdgeInsets.only(top: 50, bottom: 15),
                  child: contact.urlAvatar.isEmpty
                      ? CircleAvatar(
                          backgroundColor: Color(0xffba1e1fa),
                          child: Text(
                            contact.name[0],
                          ),
                          radius: 50,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(contact.urlAvatar),
                          radius: 50,
                        ),
                )),
              ]),
              Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    contact.name,
                    style: textH1,
                  )),
              Container(
                margin: EdgeInsets.all(10),
                child: ActionButton(),
              ),
              Divider(color: MyColor.secondColor),
              Container(
                margin: EdgeInsets.all(10),
                child: PhoneNumber(),
              ),
              Divider(color: MyColor.secondColor),
              Container(
                margin: EdgeInsets.all(20),
                child: MoreInformation(),
              ),
            ],
          ),
        )));
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
      contact = Contact.fromJson(data);
      setState(() {});
    });
  }

  Widget ActionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircleButton(Icons.phone, 20, () => tell()),
        CircleButton(Icons.message, 20, () => message()),
        CircleButton(Icons.video_call, 20, () {})
      ],
    );
  }

  Widget PhoneNumber() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        const Icon(
          Icons.phone,
          color: Colors.white,
        ),
        Container(
          child: Text(
            contact.phoneNumber,
            style: texth2,
          ),
        ),
        const Icon(
          Icons.message,
          color: Colors.white,
        ),
      ],
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Edit':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ContactEdit(idContact: contact.uid)));

        break;
      case 'Delete':
        showCofirmDialog(context, "Thông báo",
            "Bạn có chắc chắn muốn xóa liên hệ này?", DeleteContact);
        break;
    }
  }

  Widget MoreInformation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Icon(
              Icons.email,
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                contact.email,
                style: texth2,
              ),
            ),
          ],
        ),
        Padding(padding: EdgeInsets.all(10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Icon(
              Icons.location_city_rounded,
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                contact.address,
                style: texth2,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget CircleButton(IconData iconData, double sizeIcon, Function onPress) {
    return RawMaterialButton(
      onPressed: () {
        onPress();
      },
      elevation: 2.0,
      fillColor: MyColor.iconButtonColor,
      child: Icon(
        iconData,
        size: sizeIcon,
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(15.0),
      shape: const CircleBorder(),
    );
  }

  tell() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: contact.phoneNumber,
    );
    await launch(launchUri.toString());
  }

  message() async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: contact.phoneNumber,
    );
    await launch(launchUri.toString());
  }

  Future<void> DeleteContact() {
    showLoaderDialog(context, "Loading");
    return fireBase.deleteContact(contact, context);
  }
}
