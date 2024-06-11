import 'package:flutter/material.dart';

Color primaryColor = const Color(0xFF252B30);
Color secondaryColor = const Color(0xff243A73);
Color accentColor = const Color(0xff7C3E66);
Color TilesColor = const Color(0xff161B31);
Color TilesBackgroundColor = const Color(0xff080C25);
Color WhiteTextColor = const Color(0xFFFAFAFA);
// Color CardBackgroundColor = Color(0x14000000);
Color CardBackgroundColor = const Color(0x1FFFFFFF);
Color MachineCardColor = const Color(0x27FFFFFF);


getBtnStyle(context) => ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), backgroundColor: primaryColor,
    fixedSize: Size(MediaQuery.of(context).size.width, 47),
    textStyle: const TextStyle(fontWeight: FontWeight.bold));
var btnTextStyle = TextStyle(fontSize: 18.00);

const List<String> monthName = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];

typedef reloadCallback = void Function();
typedef updateIntCallback = void Function(int total);

RegExp macRegExp = RegExp(r"(:[:]?[a-fA-F0-9]{2}){5}");
RegExp passRegExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');