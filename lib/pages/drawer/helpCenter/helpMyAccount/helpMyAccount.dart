import 'package:easy_cook/pages/drawer/helpCenter/helpMyAccount/deleteAccount/deleteAccount.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpMyAccount extends StatelessWidget {
  // const HelpMyAccount({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ศูนย์ช่วยเหลือ'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          icon: Icon(Icons.clear),
        ),
      ),
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          centerTitle: true,
          title: Text('บัญชีของฉัน'),
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
                  'ลืมรหัสผ่าน',
                  style: GoogleFonts.kanit(
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
                  print("ลืมรหัสผ่าน");
                  //  Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => HelpMyAccount()),
                  //           );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.account_box_outlined,
                  color: Colors.blue,
                  size: 25,
                ),
                title: Text(
                  'ลบบัญชี',
                  style: GoogleFonts.kanit(
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
                  print("ลบบัญชี");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeleteAccountPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
