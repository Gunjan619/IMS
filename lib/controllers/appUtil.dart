// ignore_for_file: file_names
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gims/responsive.dart';

class AppUtil {
  static appLogs(Object msg) {
    if (Foundation.kReleaseMode) {
      print(msg.toString() + '  RM');
    } else {
      print(msg.toString() + '  DM');
    }
  }

  static showToast(String msg, String type) {
    Color color = Colors.black;

    if (type == 's') {
      color = Colors.green;
    } else if (type == 'e') {
      color = Colors.redAccent;
    } else if (type == 'i') {
      color = Colors.orange;
    }

    Fluttertoast.showToast(
        msg: msg,
        fontSize: 14.0,
        backgroundColor: color,
        textColor: Colors.white);
  }

  static double dashBoxRatio(BuildContext context) {
    double ratio = 0;

    if (Responsive.isDesktop(context)) {
      ratio = (1 / 1.2);
    } else if (Responsive.isTablet(context)) {
      ratio = (1 / 1.4);
    } else {
      //mobile
      ratio = (1 / 1.19);
    }
    return ratio;
  }
}
