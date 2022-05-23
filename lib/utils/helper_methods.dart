import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

var numberFormat = NumberFormat('###,###.##');

void showToast(String msg, [bool error = true]) {
  Fluttertoast.showToast(msg: msg, textColor: Colors.white, backgroundColor: error ? Colors.red : Colors.green);
}
