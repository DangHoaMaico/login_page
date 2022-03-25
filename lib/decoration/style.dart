import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_page/colors/color.dart';

InputDecoration textFeildDecoration(String label) {
  return InputDecoration(labelText: label, border: const OutlineInputBorder());
}

OutlineInputBorder outlineInputBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15)));
TextStyle textGray = TextStyle(color: MyColor.detailColor, fontSize: 16);
TextStyle textContact = TextStyle(color: MyColor.titleColor, fontSize: 18);
TextStyle textMoreInfo = TextStyle(color: MyColor.detailColor, fontSize: 14);
TextStyle textBottomBar = TextStyle(color: MyColor.titleColor, fontSize: 16);
TextStyle textH1 = GoogleFonts.aBeeZee(
    fontSize: 30, color: Colors.white, fontWeight: FontWeight.normal);
TextStyle texth2 = GoogleFonts.aBeeZee(
    fontSize: 20, color: Colors.white, fontWeight: FontWeight.normal);
TextStyle texth3 = GoogleFonts.aBeeZee(
    fontSize: 18, color: Colors.white, fontWeight: FontWeight.normal);
InputDecoration txtfldWhite = const InputDecoration(
    border: OutlineInputBorder(),
    hintText: 'Enter a search term',
    hintStyle: TextStyle(color: Colors.white));
