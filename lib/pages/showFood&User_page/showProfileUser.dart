import 'package:flutter/material.dart';
import 'dart:math';

class ProfileUser extends StatefulWidget {
  String aliasName;
  String nameSurname;
  String profileImage;
  ProfileUser(this.aliasName, this.nameSurname, this.profileImage);

  @override
  _ProfileUserState createState() =>
      _ProfileUserState(this.aliasName, this.nameSurname, this.profileImage);
}

class _ProfileUserState extends State<ProfileUser> {
  String _aliasName;
  String _nameSurname;
  String _profileImage;

  _ProfileUserState(this._aliasName, this._nameSurname, this._profileImage);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var rng = new Random();
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: size.height * 0.40,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://source.unsplash.com/400x255/?food&sig' +
                                rng.nextInt(100).toString()),
                        fit: BoxFit.cover),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 36,
                      ),
                      CircleAvatar(
                        radius: 48,
                        backgroundImage: NetworkImage(_profileImage),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        _aliasName,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        _nameSurname,
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      MaterialButton(
                        splashColor: Colors.grey,
                        color: Colors.red[400],
                        onPressed: () {
                          print("ติดตามแล้ว");
                        },
                        child: Text(
                          'ติดตาม',
                          style: TextStyle(color: Colors.white),
                        ),
                        shape: StadiumBorder(),
                      ),
                      Expanded(child: Container()),
                      Container(
                        height: 64,
                        color: Colors.black.withOpacity(0.4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 110,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'โพสต์',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "2307",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 110,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ติดตาม',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "2307",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 110,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'กำลังติดตาม',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "2307",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Material(
                  elevation: 1,
                  child: Container(
                    height: 56,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.web,
                          color: Colors.black,
                          size: 28,
                        ),
                        Icon(
                          Icons.image,
                          color: Colors.black,
                          size: 28,
                        ),
                        Icon(
                          Icons.play_circle_outline,
                          color: Colors.black,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: size.height * 0.60 - 56,
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 24),
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    physics: BouncingScrollPhysics(),
                    children: List.generate(12, (index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://source.unsplash.com/400x255/?cat&sig' +
                                      rng.nextInt(100).toString()),
                              fit: BoxFit.cover),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 32,
              left: 16,
              child: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.white,
                size: 32,
              ),
            )
          ],
        ),
      ),
    );
  }
}
