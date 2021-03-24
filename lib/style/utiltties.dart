import 'package:flutter/material.dart';

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);
final kHintTextStyle2 = TextStyle(//ส่วนผสมวิธีืทำ
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