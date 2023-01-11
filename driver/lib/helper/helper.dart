import 'package:flutter/material.dart';

import '../styles/styles.dart';

showAlertDialog(BuildContext context) {

  // set up the button
  Widget okButton = TextButton(
    style: TextButton.styleFrom(
      primary: primaryColor
    ),
    child: Text("OK"),
    onPressed: () { Navigator.pop(context); },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(

    title: Text("Invalid"),
    content: Text("Enter valid mobile number"),
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