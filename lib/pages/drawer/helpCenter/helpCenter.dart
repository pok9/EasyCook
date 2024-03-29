
import 'package:easy_cook/pages/drawer/helpCenter/helpMyAccount/helpMyAccount.dart';
import 'package:easy_cook/pages/drawer/helpCenter/qrCodeShareApp/qrCodeShareApp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpCenter extends StatelessWidget {
  // const HelpCenter({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ศูนย์ช่วยเหลือ'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            
          },
          icon: Icon(Icons.clear),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              leading: Icon(
                Icons.account_box_outlined,
                color: Colors.blue,
                size: 25,
              ),
              title: Text(
                'บัญชีของฉัน',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w300,
                ),

                //     color: Colors.black)
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.blue,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpMyAccount()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.qr_code_2_sharp ,
                color: Colors.blue,
                size: 25,
              ),
              title: Text(
                'แบ่งปันแอปพลิเคชัน',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w300,
                ),

                //     color: Colors.black)
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.blue,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QrCodeShareApp()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
