import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeShareApp extends StatelessWidget {
  const QrCodeShareApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("แบ่งปันแอปพลิเคชัน"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              
              child: Stack(
                children: [
                  QrImage(
                    data:
                        "https://drive.google.com/file/d/1xp5kHyoM_gOjAZfOFkRYoUQyVWLg1Cpi/view?usp=sharing",
                    version: QrVersions.auto,
                    size: 300.0,
                    
                  ),
                  Positioned(
                    top: 125,
                    left: 125,
                    child: Card(
                      child: Container(
                        height: 40,
                        width: 40,
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(
                            'assets/images/hamburger256Px.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Easy Cook")],
            ),
          ],
        ),
      ),
    );
  }
}
