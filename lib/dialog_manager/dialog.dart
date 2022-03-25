import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

showLoaderDialog(BuildContext context, String content) {
  AlertDialog alert = AlertDialog(
      content: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const CircularProgressIndicator(),
      Container(
        margin: const EdgeInsets.only(left: 7),
        child: Padding(
          child: Text(content),
          padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
        ),
      ),
    ],
  ));
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showSuccessDialog(BuildContext context, String content, Function onPressOK) {
  Widget okButton = TextButton(
    child: Text("Ok"),
    onPressed: () {
      onPressOK();
    },
  );
  AlertDialog alert = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.check,
          color: Colors.green,
          size: 30,
        ),
        Container(
            margin: const EdgeInsets.only(left: 7, top: 10),
            child: Text(content)),
      ],
    ),
    actions: [okButton],
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showProgessindIcatorDialog(BuildContext context, double value) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        CircularProgressIndicator(
          value: value,
        )
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialog(BuildContext context, String title, String content) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showCofirmDialog(BuildContext context, String title, String content,
    Future<void> function()) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      function();
      print("click oke");
      Navigator.pop(context);
    },
  );
  Widget no = TextButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [okButton, no],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showFlushBar(BuildContext context, String title, String content) async {
  await Flushbar(
    title: title,
    message: content,
    duration: Duration(seconds: 2),
    flushbarPosition: FlushbarPosition.TOP,
  ).show(context);
}
