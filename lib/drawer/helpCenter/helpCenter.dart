import 'package:easy_cook/drawer/helpCenter/helpMyAccount/helpMyAccount.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpCenter extends StatelessWidget {
  // const HelpCenter({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ศูนย์ช่วยเหลือ'),
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
                style: GoogleFonts.kanit(
                  fontSize: 17,
                  fontWeight: FontWeight.w300,
                ),

                //     color: Colors.black)
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.blue,),
              onTap: () {
               Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HelpMyAccount()),
                        );
              },
            ),
            
          ],
        ),
      ),
    );
  }
}
