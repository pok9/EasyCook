import 'dart:async';
import 'dart:convert';

import 'package:easy_cook/models/topup&withdraw/withdraw.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WithdrawPage extends StatefulWidget {
  // const WithdrawPage({ Key? key }) : super(key: key);

  double amount_to_fill;
  String name;
  String email;
  WithdrawPage({this.amount_to_fill, this.name, this.email});

  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
  }

  String token = ""; //โทเคน
  //ดึง token
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("tokens");
      // print("ProfilePage_token = " + token);
    });
  }

  String _selected;
  List<Map> _myJson = [
    {
      'code': 'scb',
      'name': 'ธนาคารไทยพาณิชย์',
      'image':
          'https://media-exp1.licdn.com/dms/image/C510BAQElNZUFumis3Q/company-logo_200_200/0/1519912092504?e=2159024400&v=beta&t=UXn2iHDhq4cwYLoRjYxo3FgGkjJR3ekhlnDo-dw5KB4'
    },
    {
      'code': 'tisco',
      'name': 'ธนาคารทิสโก้',
      'image':
          'https://upload.wikimedia.org/wikipedia/th/6/6a/%E0%B8%98%E0%B8%99%E0%B8%B2%E0%B8%84%E0%B8%B2%E0%B8%A3%E0%B8%97%E0%B8%B4%E0%B8%AA%E0%B9%82%E0%B8%81%E0%B9%89.png'
    },
    {
      'code': 'bbl',
      'name': 'ธนาคารกรุงเทพ',
      'image':
          'https://www.sequelonline.com/wp-content/uploads/2018/02/5_Bangkok_Bank1.jpg'
    },
    {
      'code': 'citi',
      'name': 'ธนาคารซิตี้แบงค์',
      'image': 'https://promotions.co.th/wp-content/uploads/citibank-logo-3.jpg'
    },
    {
      'code': 'gsb',
      'name': 'ธนาคารออมสิน',
      'image':
          'https://upload.wikimedia.org/wikipedia/en/thumb/4/4a/Logo_GSB_Thailand.svg/1200px-Logo_GSB_Thailand.svg.png'
    },
    {
      'code': 'kbank',
      'name': 'ธนาคารกสิกรไทย',
      'image':
          'https://www.kasikornbank.com/SiteCollectionDocuments/about/img/logo/logo.png'
    },
    {
      'code': 'ktb',
      'name': 'ธนาคารกรุงไทย',
      'image':
          'https://upload.wikimedia.org/wikipedia/th/2/29/%E0%B8%98%E0%B8%99%E0%B8%B2%E0%B8%84%E0%B8%B2%E0%B8%A3%E0%B8%81%E0%B8%A3%E0%B8%B8%E0%B8%87%E0%B9%84%E0%B8%97%E0%B8%A2.png'
    },
    {
      'code': 'tbank',
      'name': 'ธนาคารธนชาต',
      'image':
          'https://upload.wikimedia.org/wikipedia/th/9/9a/%E0%B8%98%E0%B8%99%E0%B8%B2%E0%B8%84%E0%B8%B2%E0%B8%A3%E0%B8%98%E0%B8%99%E0%B8%8A%E0%B8%B2%E0%B8%95-%E0%B8%88%E0%B8%B3%E0%B8%81%E0%B8%B1%E0%B8%94-%E0%B8%A1%E0%B8%AB%E0%B8%B2%E0%B8%8A%E0%B8%99.png'
    },
    {
      'code': 'tmb',
      'name': 'ธนาคารทหารไทยธนชาต',
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/8/80/TMB_Bank_Logo.svg/1200px-TMB_Bank_Logo.svg.png'
    },
  ];

  Future<Withdraw> Withdraw_fuc(
      String token,
      String name,
      String email,
      String bankBand,
      String banknumber,
      String bankname,
      double amount) async {
    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/withdraw";

    var data = {
      "token": token,
      "name": name,
      "email": email,
      "bankBand": bankBand,
      "banknumber": banknumber,
      "bankname": bankname,
      "amount": amount
    };
    print(jsonEncode(data));
    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });

    print("respon = ${response.statusCode}");
    if (response.statusCode == 200) {
      final String responseString = response.body;
      print("responseString = ${responseString}");

      return withdrawFromJson(responseString);
    } else {
      return null;
    }
  }

  int checkDropdown = 1;

  TextEditingController _ctrlBankname = TextEditingController();
  TextEditingController _ctrlBanknumber = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('ถอนเงิน'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: (checkDropdown == 0) ? Colors.red : Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton(
                        hint: Text('เลือกธนาคาร'),
                        value: _selected,
                        onChanged: (newValue) {
                          setState(() {
                            _selected = newValue;
                            checkDropdown = 1;
                          });
                        },
                        items: _myJson.map((bankItem) {
                          return DropdownMenuItem(
                            value: bankItem['code'].toString(),
                            child: Row(
                              children: [
                                Image.network(
                                  bankItem['image'].toString(),
                                  width: 25,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(bankItem['name']),
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    )))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: _ctrlBankname,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อบัญชี';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  labelText: 'ชื่อบัญชี',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _ctrlBanknumber,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาหมายเลขบัญชี';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  labelText: 'หมายเลขบัญชี',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: sizeScreen.width,
                padding: EdgeInsets.only(left: 10, right: 10),
                // margin: const EdgeInsets.all(10),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue,
                    padding: EdgeInsets.all(12),
                    textStyle: TextStyle(fontSize: 22),
                  ),
                  child: Text('ถอนเงิน ${this.widget.amount_to_fill} บาท'),
                  onPressed: () async {
                    if (_selected == null) {
                      setState(() {
                        checkDropdown = 0;
                      });
                    }
                    if (_formKey.currentState.validate()) {
                      if (_selected != null) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("กรุณารอสักครู่...   "),
                                CircularProgressIndicator()
                              ],
                            ));
                          },
                        );
                        print("token ===>>> $token");
                        print("name ===>>> ${this.widget.name}");
                        print("email ===>>> ${this.widget.email}");
                        print("bankBand ===>>> $_selected");
                        print("banknumber ===>>> ${_ctrlBanknumber.text}");
                        print("bankname ===>>> ${_ctrlBankname.text}");
                        print("amount ===>>> ${this.widget.amount_to_fill}");
                        Withdraw withdrawData = await Withdraw_fuc(
                            token,
                            this.widget.name,
                            this.widget.email,
                            _selected,
                            _ctrlBanknumber.text,
                            _ctrlBankname.text,
                            this.widget.amount_to_fill);

                        Navigator.pop(context);

                        print(withdrawData.success);
                        if (withdrawData.success == 1) {
                          print(withdrawData.message);
                          print("wwww");

                          showDialog(
                              context: context,
                              builder: (BuildContext builderContext) {
                                Timer(Duration(milliseconds: 2500 ), () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  
                                });
                                return CustomDialog(
                                  title: "คำขอการถอนเงินสำเร็จ",
                                  description:
                                      withdrawData.message,
                                  image:
                                      'https://i.pinimg.com/originals/06/ae/07/06ae072fb343a704ee80c2c55d2da80a.gif',
                                  colors: Colors.lightGreen,
                                  index: 1,
                                );
                              });
                        } else {
                          print("mmmm");

                          showDialog(
                              context: context,
                              builder: (context) => CustomDialog(
                                    title: "ถอนเงินไม่สำเร็จ",
                                    description: "โปรดทำรายการใหม่",
                                    image:
                                        'https://media2.giphy.com/media/JT7Td5xRqkvHQvTdEu/200w.gif?cid=82a1493b44ucr1schfqvrvs0ha03z0moh5l2746rdxxq8ebl&rid=200w.gif&ct=g',
                                    colors: Colors.redAccent,
                                    index: 0,
                                  ));
                        }
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText, image;
  final Color colors;
  final int index;
  final int rid;

  CustomDialog(
      {this.title,
      this.description,
      this.buttonText,
      this.image,
      this.colors,
      this.index,
      this.rid});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 100, bottom: 16, left: 16, right: 16),
          margin: EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                )
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                description,
                style: TextStyle(color: Colors.grey.shade800, fontSize: 16.0),
              ),
              SizedBox(
                height: 24.0,
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 16,
          right: 16,
          child: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: 50,
            backgroundImage: NetworkImage(this.image),
          ),
        )
      ],
    );
  }
}
