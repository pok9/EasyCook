import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  // NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('การแจ้งเตือน'),
      ),
      body: ListView(
        children: [
          // ListTile(
          //   leading: CircleAvatar(
          //     backgroundImage: NetworkImage(
          //         "https://static.wikia.nocookie.net/characters/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20171118221229"),
          //   ),
          //   title: Row(
          //     children: [
          //       Expanded(
          //         child: Text(
          //           'ชื่อเล่น<--->  Now, the row first asks the logo to lay out, and then asks the icon to lay out. The Icon, ',
          //           style: TextStyle(fontWeight: FontWeight.normal),
          //         ),
          //       ),
          //     ],
          //   ),
          //   subtitle: Text(
          //     'เมื่อวานนี้เวลา 19:26 น.',
          //     textAlign: TextAlign.justify,
          //     style: TextStyle(
          //       fontWeight: FontWeight.normal,
          //       fontFamily: 'OpenSans',
          //       fontSize: 12,
          //       color: Colors.black,
          //       decoration: TextDecoration.none,
          //     ),
          //   ),
          //   trailing: Icon(Icons.more_vert),
          //   isThreeLine: true,
          //   dense: true,
          //   onTap: () {},
          // ),
          Card(
            margin: EdgeInsets.all(1),
            child: ListTile(
              // leading: FlutterLogo(size: 72.0),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://static.wikia.nocookie.net/characters/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20171118221229"),
              ),
              title: Text('Three-line ListTile'),
              subtitle:
                  Text('A sufficiently long subtitle warrants three lines.'),
              trailing: Icon(Icons.more_horiz),
              isThreeLine: true,
              onTap: () {},
            ),
          ),
          Card(
            margin: EdgeInsets.all(1),
            child: ListTile(
              // leading: FlutterLogo(size: 72.0),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://static.wikia.nocookie.net/characters/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20171118221229"),
              ),
              title: Text('Three-line ListTile'),
              subtitle:
                  Text('A sufficiently long subtitle warrants three lines.'),
              trailing: Icon(Icons.more_horiz),
              isThreeLine: true,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
