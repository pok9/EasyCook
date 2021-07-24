import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);
final kHintTextStyle2 = TextStyle(
  //ส่วนผสมวิธีืทำ
  fontSize: 17,
  color: Colors.black,
  fontFamily: 'OpenSans',
  // fontSize: 40
);
final kHintTextStyle3 = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: Colors.black,
    fontFamily: 'OpenSans',
    decoration: TextDecoration.underline,
    decorationStyle: TextDecorationStyle.double
    // fontSize: 40
    );

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);
final kLabelStyle2 = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

//ปุ่มของหน้า test(เพิ่มสูตรอาหาร)
final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  primary: Colors.white,
  minimumSize: Size(88, 44),
  padding: EdgeInsets.symmetric(horizontal: 16.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
  backgroundColor: Colors.blue,
);




