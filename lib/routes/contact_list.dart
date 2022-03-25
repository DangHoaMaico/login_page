import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:login_page/decoration/style.dart';
import 'package:login_page/firebase_manager/firebase_manager.dart';
import 'package:login_page/main.dart';
import 'package:login_page/model/User/contact.dart';
import 'package:login_page/routes/contact_detail.dart';
import 'package:login_page/widget/circle_progess.dart';

import 'package:paginate_firestore/bloc/pagination_listeners.dart';

import '../colors/color.dart';
import '../file_manager/file_manager.dart';
import '../widget/liscontact_item.dart';

class ContactList extends StatefulWidget {
  ContactList({Key? key}) : super(key: key);

  @override
  State<ContactList> createState() => _ContactList();
}

class _ContactList extends State<ContactList>
    with SingleTickerProviderStateMixin {
  FireBaseManager fireBaseManager = FireBaseManager();
  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();
  List<Contact> listContact = [];
  List<Contact> display = [];
  List<Contact> listContactIsMarked = [];

  bool isLoading = true;
  bool isEdit = true;
  String search = "";
  late FocusNode myFocusNode = FocusNode();
  late TabController _tabController;
  final _controller = TextEditingController();

  late Stream<QuerySnapshot> contactStream = fireBaseManager.firestore
      .collection("contacts")
      .doc(fireBaseManager.auth.currentUser!.uid)
      .collection("contact_list")
      .snapshots();

  late QuerySnapshot data;

  late FileManager fileManager;
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: MyColor.primaryColor,
      title: const Text('Contacts'),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    fileManager = FileManager();

    super.initState();

    fireBase.listenContactsSnapshot(() {
      Refesh();
    });
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColor.primaryColor,
        appBar: buildAppBar(context),
        body: Column(
          children: <Widget>[
            TabBar(controller: _tabController, tabs: <Tab>[
              TabbarItem(Icons.contacts),
              TabbarItem(Icons.bookmark),
            ]),
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: [
                ListAllContact(),
                ListMarkedContact(true),
              ],
            )),
          ],
        ));
  }

  LoadData() async {
    setState(() {
      isLoading = true;
    });

    listContact.clear();
    listContactIsMarked.clear();

    listContact = await fileManager.loadBigList();
    listContact.forEach((element) {
      if (element.isMark) {
        display.add(element);
        listContactIsMarked.add(element);
      }
    });
    print(listContact.length);
    await Future.delayed(Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  onMarkContact(Contact contact) {
    fireBaseManager.firestore
        .collection("contacts")
        .doc(fireBaseManager.auth.currentUser!.uid)
        .collection("contact_list")
        .doc(contact.uid)
        .update({"isMark": !contact.isMark}).whenComplete(() {
      LoadData();
    });
  }

  Tab TabbarItem(IconData iconData) {
    return Tab(
      icon: Icon(
        iconData,
      ),
    );
  }

  Widget ListMarkedContact(bool? isMark) {
    return isLoading == true
        ? circleProges_Center
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: listContactIsMarked.length,
            itemBuilder: (BuildContext context, int index) {
              return ListContacstItem(
                  onClickItem: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContactDetail(
                                idContact: listContactIsMarked[index].uid)));
                  },
                  contact: listContactIsMarked[index],
                  onMarkContact: () {
                    onMarkContact(listContactIsMarked[index]);
                  });
            },
          );
  }

  Widget ListAllContact() {
    return isLoading == true
        ? circleProges_Center
        : Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                child: TextField(
                  focusNode: myFocusNode,
                  controller: _controller,
                  style: texth3,
                  onChanged: (string) {
                    if (string == "") {
                      setState(() {
                        listContact = display;
                      });
                    }
                  },
                  onSubmitted: (string) {
                    Searching(string);
                  },
                  decoration: InputDecoration(
                      hintText: 'Search',
                      suffixIcon: search != ""
                          ? IconButton(
                              onPressed: () => onClickCLear(),
                              icon: const Icon(
                                Icons.clear,
                              ),
                            )
                          : null,
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      )),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: listContact.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListContacstItem(
                        onClickItem: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContactDetail(
                                      idContact: listContact[index].uid)));
                        },
                        contact: listContact[index],
                        onMarkContact: () {
                          onMarkContact(listContact[index]);
                        });
                  },
                ),
              ),
            ],
          );
  }

  Future<void> Refesh() async {
    if (mounted) {
      await fireBaseManager.fecthContact();
      await Future.delayed(Duration(milliseconds: 300));
      await LoadData();
    }
    if (mounted) {
      setState(() {});
    }
  }

  onClickCLear() {
    _controller.clear();
    setState(() {
      search = "";
    });
  }

  Future<void> Searching(String string) async {
    List<Contact> listTemp = [];
    display = await fileManager.loadBigList();
    display.forEach((element) {
      if (element.name.toLowerCase().contains(string.toLowerCase())) {
        listTemp.add(element);
      }
    });
    if (string == "") {
      setState(() {
        listContact = display;
      });
    } else {
      setState(() {
        listContact = listTemp;
      });
    }
    myFocusNode.requestFocus();
    FocusScope.of(context).requestFocus(myFocusNode);
  }
}
