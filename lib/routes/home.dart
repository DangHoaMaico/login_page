import 'package:flutter/material.dart';
import 'package:login_page/decoration/style.dart';
import 'package:login_page/routes/contact_list.dart';
import 'package:login_page/routes/profile.dart';
import 'package:login_page/routes/setting.dart';

import '../colors/color.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 0;
  final List<Widget> listWidget = [ContactList(), Profile()];
  final PageStorageBucket pageBucket = PageStorageBucket();
  Widget currntScreen = ContactList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.primaryColor,
      body: PageStorage(
        bucket: pageBucket,
        child: currntScreen,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColor.floatButtonColor,
        onPressed: (() {
          Navigator.pushNamed(context, "/addContact");
        }),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: MyColor.secondColor,
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              BottomAppBarItem(ContactList(), 0, "Home", Icons.home,
                  Colors.white, Colors.grey),
              BottomAppBarItem(Setting(), 1, "Setting", Icons.settings,
                  Colors.white, Colors.grey)
            ],
          ),
        ),
      ),
    );
  }

  Widget BottomAppBarItem(Widget screen, int tab, String label, IconData icon,
      Color activeColor, Color inActiveColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        MaterialButton(
          minWidth: 130,
          onPressed: () {
            setState(() {
              currntScreen = screen;
              currentTab = tab;
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: currentTab == tab ? activeColor : inActiveColor,
              ),
              Text(
                label,
                style: TextStyle(
                    color: currentTab == tab ? activeColor : inActiveColor,
                    fontSize: 16),
              )
            ],
          ),
        ),
      ],
    );
  }
}
