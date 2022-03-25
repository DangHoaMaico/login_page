import 'package:flutter/material.dart';
import 'package:login_page/colors/color.dart';
import 'package:login_page/decoration/style.dart';
import 'package:animate_icons/animate_icons.dart';
import 'package:login_page/model/User/contact.dart';
import 'package:login_page/widget/avatar.dart';

class ListContacstItem extends StatefulWidget {
  Contact contact;
  Function onMarkContact;
  Function onClickItem;

  ListContacstItem(
      {Key? key,
      required this.contact,
      required this.onMarkContact,
      required this.onClickItem})
      : super(key: key);

  @override
  State<ListContacstItem> createState() =>
      _ListContacstItemState(contact, onMarkContact, onClickItem);
}

class _ListContacstItemState extends State<ListContacstItem>
    with SingleTickerProviderStateMixin {
  Contact contact;
  Function onMarkContact;
  Function onClickItem;

  late AnimateIconController controller;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (contact.isMark) {}
  }

  _ListContacstItemState(this.contact, this.onMarkContact, this.onClickItem);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: MyColor.secondColor,
        ),
        margin: EdgeInsets.all(10),
        child: Column(
          key: UniqueKey(),
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  child: contact.urlAvatar.isEmpty
                      ? Container(
                          child: CircleAvatar(
                            child: Text(contact.name[0]),
                          ),
                          margin: EdgeInsets.fromLTRB(8, 8.5, 0, 9),
                        )
                      : avatar(contact.urlAvatar, 20),
                  margin: const EdgeInsets.fromLTRB(15, 10, 0, 5),
                ),
                Container(
                    key: UniqueKey(),
                    margin: EdgeInsets.all(5),
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      child: Icon(
                        contact.isMark
                            ? Icons.bookmark
                            : Icons.bookmark_outline,
                        color: Colors.pink,
                        size: 30,
                      ),
                      onTap: () {
                        onMarkContact();
                      },
                    )),

                // ),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                contact.name,
                style: textContact,
              ),
              padding: const EdgeInsets.fromLTRB(15, 5, 20, 0),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                contact.phoneNumber,
                style: textMoreInfo,
              ),
              margin: const EdgeInsets.fromLTRB(15, 5, 20, 3),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                contact.address,
                style: textMoreInfo,
              ),
              padding: const EdgeInsets.fromLTRB(15, 2, 20, 3),
            )
          ],
        ),
      ),
      onTap: () {
        onClickItem();
      },
    );
  }
}
