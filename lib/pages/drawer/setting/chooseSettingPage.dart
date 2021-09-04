import 'package:easy_cook/pages/drawer/setting/chooseSetting/chooseWallpaperPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChooseSettingPage extends StatefulWidget {
  @override
  _ChooseSettingPageState createState() => _ChooseSettingPageState();
}

class _ChooseSettingPageState extends State<ChooseSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตั้งค่า'),
      ),
      body: ListView(
          children: [
            ListTile(
              leading: Icon(
                Icons.wallpaper_outlined,
                color: Colors.blue,
                size: 25,
              ),
              title: Text(
                'เลือกวอลล์เปเปอร์',
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChooseWallpaperPage()),
                );
              },
            ),
          ],
        ),
    );
  }
}
