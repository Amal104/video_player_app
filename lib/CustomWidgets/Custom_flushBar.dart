import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class CustomFlushBar {
 static customFlushBar(BuildContext context,String title,String msg,) {
    return Flushbar(
      title: title,
      titleColor: Colors.red,
      message: msg,
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 400),
      backgroundColor: Colors.black,
      flushbarPosition: FlushbarPosition.TOP,
      icon: const Padding(
        padding: EdgeInsets.all(10.0),
        child: Icon(
          Icons.notifications_active,
          color: Colors.red,
        ),
      ),
    ).show(context);
  }
}