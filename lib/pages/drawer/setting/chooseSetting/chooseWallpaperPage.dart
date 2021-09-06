import 'package:flutter/material.dart';

class ChooseWallpaperPage extends StatefulWidget {
  @override
  _ChooseWallpaperPageState createState() => _ChooseWallpaperPageState();
}

class _ChooseWallpaperPageState extends State<ChooseWallpaperPage> {
  List<String> imgWallaper = [
    'https://img.freepik.com/free-vector/blue-copy-space-digital-background_23-2148821698.jpg?size=626&ext=jpg',
    'https://cdnb.artstation.com/p/assets/images/images/024/538/827/original/pixel-jeff-clipa-s.gif?1582740711',
    'https://images.unsplash.com/photo-1541701494587-cb58502866ab?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
    'https://cutewallpaper.org/21/gif-wallpaper-anime/Pin-by-Buu-Dang-on-iPhone-6S-Plus-Wallpapers-Must-to-Have-in-.gif',
    'https://wallpapercave.com/wp/wp2757954.gif',
    'https://wallpapercave.com/wp/wp2757967.gif'
  ];

  int id = 0;
  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('เลือกวอลล์เปเปอร์'),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: imgWallaper.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("เปลี่ยนรูป วอลล์เปเปอร์ ใหม่แล้ว"),
                  ));
                  id = index;
                });
              },
              child: Stack(
                children: [
                  Container(
                    height: 200,
                    width: sizeScreen.width,
                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.network(
                        imgWallaper[index],
                        fit: BoxFit.fill,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Radio(
                          value: index,
                          groupValue: id,
                          onChanged: (value) {
                            setState(() {
                              id = index;
                            });
                          },
                          activeColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
