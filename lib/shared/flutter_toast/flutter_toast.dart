import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// showing prompet when the action done " Like : Sing is succsse || Done "
void showToast({required String txt, required Color color}) =>
    Fluttertoast.showToast(
        msg: txt,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
