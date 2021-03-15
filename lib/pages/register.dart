import 'package:easy_cook/slidepage.dart';
import 'package:flutter/material.dart';
import '../style/utiltties.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'อีเมล์',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft, //ให้มาอยู่ตรงกลาง
          decoration: kBoxDecorationStyle, //กรอบ
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'ป้อนอีเมล์ของคุณ',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'รหัสผ่าน',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'ป้อนรหัสผ่านของคุณ',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTFconfirm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'ยืนยันรหัสผ่าน',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.verified_user,
                color: Colors.white,
              ),
              hintText: 'ยืนยันรหัสผ่านของคุณ',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildNameTF() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       Text(
  //         'ป้อนชื่อผู้ใช้',
  //         style: kLabelStyle,
  //       ),
  //       SizedBox(height: 10.0),
  //       Container(
  //         alignment: Alignment.centerLeft,
  //         decoration: kBoxDecorationStyle,
  //         height: 60.0,
  //         child: TextField(
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontFamily: 'OpenSans',
  //           ),
  //           decoration: InputDecoration(
  //             border: InputBorder.none,
  //             contentPadding: EdgeInsets.only(top: 14.0),
  //             prefixIcon: Icon(
  //               Icons.person,
  //               color: Colors.white,
  //             ),
  //             hintText: 'ชื่อผู้ใช้',
  //             hintStyle: kHintTextStyle,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildRegisterBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          // Navigator.pushReplacement(
          //   context,
          //   new MaterialPageRoute(
          //       /*check()*/
          //       builder: (context) =>
          //           new SlidePage()), /////////////////////////////////////////////////////////////////////////////////
          // ).then((value) {
          //   /* if (value == null) {
          //         } else {

          //           proList.add(value);
          //         }*/
          //   setState(() {});
          // });
          Navigator.pushNamed(context, '/register2-page');
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Color(0xFF73AEF5),
        child: Text(
          'สมัครสมาชิก',
          style: TextStyle(
            color: Colors.red[50],
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

   Widget _buildCancelBtn() {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
         print("ยกเลิก");
         Navigator.pop(context);
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.blueGrey[300],
        child: Text(
          'ยกเลิก',
          style: TextStyle(
            color: Colors.red[50],
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blueGrey,
                      Colors.blueAccent,
                      Colors.blueGrey,
                      Colors.blue,
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'สมัครสมาชิก',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      SizedBox(height: 30.0),
                      _buildEmailTF(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _buildPasswordTF(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _buildPasswordTFconfirm(),
                      SizedBox(
                        height: 30.0,
                      ),
                      
                      // _buildNameTF(),
                      // SizedBox(
                      //   height: 20.0,
                      // ),
                      _buildRegisterBtn(),
                      _buildCancelBtn()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
