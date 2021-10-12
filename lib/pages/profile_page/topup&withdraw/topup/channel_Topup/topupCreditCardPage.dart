import 'dart:async';
import 'dart:convert';

import 'package:easy_cook/models/topup&withdraw/topup/topupCreditCardModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TopupCreditCardPage extends StatefulWidget {
  // const TopupPage({ Key? key }) : super(key: key);
  double amount_to_fill;

  TopupCreditCardPage({this.amount_to_fill});
  @override
  _TopupCreditCardPageState createState() => _TopupCreditCardPageState();
}

class _TopupCreditCardPageState extends State<TopupCreditCardPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
  }

  Future<TopupCreditCardModel> Topup_fuc(String token, String name,
      String number, int month, int year, double amount) async {
    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/topup";

    var data = {
      "token": token,
      "name": name,
      "number": number,
      "month": month,
      "year": year,
      "amount": amount
    };
    print(data);
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

      return topupCreditCardFromJson(responseString);
    } else {
      return null;
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("บัตรเครดิต/บัตรเดบิต"),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true,
              // this.labelCardHolder
              labelCardHolder: "ชื่อบนบัตร",
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CreditCardForm(
                      formKey: formKey,
                      obscureCvv: true,
                      obscureNumber: true,
                      cardNumber: cardNumber,
                      cvvCode: cvvCode,
                      cardHolderName: cardHolderName,
                      expiryDate: expiryDate,
                      themeColor: Colors.blue,
                      numberValidationMessage: 'กรุณากรอกหมายเลขบัตร',
                      dateValidationMessage: 'กรุณากรอกวันหมดอายุ',
                      cvvValidationMessage: 'กรุณากรอกหมายเลข CVV',
                      cardNumberDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'หมายเลขบัตร',
                        hintText: 'XXXX XXXX XXXX XXXX',
                      ),
                      expiryDateDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'วันหมดอายุ',
                        hintText: 'XX/XX',
                      ),
                      cvvCodeDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'CVV',
                        hintText: 'XXX',
                      ),
                      cardHolderDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'ชื่อบนบัตร',
                      ),
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        primary: const Color(0xff1b447b),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: Text(
                          'เติมเงิน ${NumberFormat("#,###.##").format(widget.amount_to_fill)} บาท', //'เติมเงิน ${widget.amount_to_fill} บาท'
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'halter',
                            fontSize: 14,
                            package: 'flutter_credit_card',
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (formKey.currentState.validate()) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Image.asset(
                                      'assets/loadGif/loadding3.gif',
                                    ),
                                    width: 50,
                                    height: 50,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("กรุณารอสักครู่...   "),
                                  CircularProgressIndicator()
                                ],
                              ));
                            },
                          );

                          print('valid!');
                          print(token); //token
                          print(cardHolderName); //name
                          print(cardNumber); //number
                          String cardNumberRp = cardNumber.replaceAll(" ", "");

                          List expiryDateSplit = expiryDate.split("/");
                          int month = int.parse(expiryDateSplit[0]);
                          int year = int.parse("20" + expiryDateSplit[1]);
                          double amount = this.widget.amount_to_fill;
                          print(month);
                          print(year);
                          print(this.widget.amount_to_fill);

                          print(cvvCode);

                          TopupCreditCardModel topupData = await Topup_fuc(
                              token,
                              cardHolderName,
                              cardNumberRp,
                              month,
                              year,
                              amount);
                          Navigator.pop(context);

                          if (topupData.success == 1) {
                            showDialog(
                                context: context,
                                builder: (BuildContext builderContext) {
                                  Timer(Duration(seconds: 2), () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  });
                                  return CustomDialog(
                                    title: "เติมเงินสำเร็จ",
                                    description:
                                        "เราได้ทำการเติมเงินให้คุณเรียบร้อยแล้ว",
                                    image: 'assets/logoNoti/correctGif.gif',
                                    colors: Colors.lightGreen,
                                    index: 1,
                                  );
                                });
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => CustomDialog(
                                      title: "เติมเงินไม่สำเร็จ",
                                      description: "โปรดทำรายการใหม่",
                                      image: 'assets/logoNoti/wrongGif.gif',
                                      colors: Colors.redAccent,
                                      index: 0,
                                    ));
                          }
                        } else {
                          print('invalid!');
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
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
            backgroundImage: AssetImage(this.image),
          ),
        )
      ],
    );
  }
}
