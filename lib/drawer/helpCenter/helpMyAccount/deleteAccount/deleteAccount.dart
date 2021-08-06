import 'package:flutter/material.dart';

class DeleteAccountPage extends StatefulWidget {
  // const DeleteAccountPage({ Key? key }) : super(key: key);

  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ศูนย์ช่วยเหลือ'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
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
              title: Text("ลบบัญชี"),
            ),
            body: Column(
              children: [
                Text('ลบบัญชีผู้ใช้ของคุณ'),
                Text(
                    'คุณช่วยแชร์ให้เราหน่อยได้ไหมว่าอะไรที่ไม่ทำงาน? เรากำลังแก้ไขข้อบกพร่องทันทีที่เราตรวจพบ หากมีสิ่งใดเล็ดลอดนิ้วออกไป เรายินดีอย่างยิ่งที่ได้ทราบและแก้ไข')
              ],
            )));
  }
}
