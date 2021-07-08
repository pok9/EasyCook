import 'package:flutter/material.dart';

class RecipeArchivePage extends StatefulWidget {
  // RecipeArchivePage({Key? key}) : super(key: key);

  @override
  _RecipeArchivePageState createState() => _RecipeArchivePageState();
}

class _RecipeArchivePageState extends State<RecipeArchivePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(),
      body: SafeArea(
        minimum: EdgeInsets.zero,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Row(
                children: [
                  Text(
                    "ล่าสุด",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Container(
                height: 220,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return _foodCard_1(context);
                    })),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              leading: Icon(
                Icons.restore_outlined,
                color: Colors.black,
                size: 30,
              ),
              title: Text('ประวัติการเข้าชม',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.black)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.food_bank_outlined,
                color: Colors.black,
                size: 30,
              ),
              title: Text('สูตรของคุณ',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.black)),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _foodCard_1(context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 140,
              width: 150,
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://apifood.comsciproject.com/uploadPost/2021-06-19T144016088Z-image_cropper_1624113521886.jpg"),
                      fit: BoxFit.cover)),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "ผัดกะเพราพิเศษใส่ไข่สูตรผีบอก ณ.ขอนแก่น",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      new Text(
                        "เซฟปก",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.grey.shade700),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
