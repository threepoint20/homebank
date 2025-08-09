import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_date_range/in_date_range.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final String POINT_DB = "point";
final String USER_DB = "users";
final String JOB_DB = "job";

List<String> WORK_TYPES = ["作業類", "家事類", "運動類", "藝術類"];
List<Color> WORK_COLORS = [
  Color(0xFF6183DB),
  Color(0xFFDE707C),
  Color(0xFF65C36E),
  Color(0xFFFAB023)
];

List<String> ALL_WORK_TYPES = ["作業類", "家事類", "運動類", "藝術類", "兌換獎勵"];
List<Color> ALL_WORK_COLORS = [
  Color(0xFF6183DB),
  Color(0xFFDE707C),
  Color(0xFF65C36E),
  Color(0xFFFAB023),
  Colors.red,
];

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0);
}

void showErrorToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

Color getTypeColor(String type) {
  int index = ALL_WORK_TYPES.indexOf(type);
  print("index of $type is $index");
  if (index >= 0) {
    return ALL_WORK_COLORS[index];
  }
  return Colors.black;
}

String getYearMonth(DateTime date) {
  String year_month = "${date.year}-${date.month.toString().padLeft(2, "0")}";
  return year_month;
}

String getDateString(List<DateTime> dates) {
  if (dates.length == 1) {
    return dates.first.toString().split(" ").first;
  }
  StringBuffer buf = StringBuffer();
  for (DateTime date in dates) {
    buf.writeAll([
      date.month.toString().padLeft(2, "0"),
      "-",
      date.day.toString().padLeft(2, "0"),
      " "
    ]);
  }
  return buf.toString();
}

String getLongDate(String date_string) {
  DateTime date = DateTime.parse(date_string);
  return "${date.year}/${date.month.toString().padLeft(2, "0")}/${date.day.toString().padLeft(2, "0")}";
}

String getShortDate(String date_string) {
  DateTime date = DateTime.parse(date_string);
  return "${date.month.toString().padLeft(2, "0")}-${date.day.toString().padLeft(2, "0")}";
}

String getDateTimeString(DateTime date) {
  return date.toString().split(".").first;
}

bool isInMonth(String date_string, DateTime compare_date) {
  DateTime _date = DateTime.parse(date_string);
  if (_date.year == compare_date.year && _date.month == compare_date.month) {
    return true;
  }
  return false;
}

bool isInRange(String date_string, DateRange range) {
  DateTime _date = DateTime.parse(date_string);
  if (range.contains(_date)) {
    return true;
  }
  return false;
}
