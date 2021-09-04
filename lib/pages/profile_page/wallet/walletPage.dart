import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/pages/profile_page/topup&withdraw/topup/payment_channel.dart';
import 'package:easy_cook/pages/profile_page/topup&withdraw/withdraw/withdrawPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  String token = ""; //โทเคน
  Future<String> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getString("tokens");
  }

  //ข้อมูลตัวเอง
  MyAccount data_MyAccount;
  DataMyAccount data_DataAc;

  Future<MyAccount> getMyAccounts() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/myAccount";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      // if (mounted)
      // setState(() {
      final String responseString = response.body;

      // data_MyAccount = myAccountFromJson(responseString);
      // data_DataAc = data_MyAccount.data[0];

      // getMyPost();
      // });
      return myAccountFromJson(responseString);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("กระเป๋าตัง"),
      ),
      body: FutureBuilder(
        future: findUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            token = snapshot.data;
            return FutureBuilder(
              future: getMyAccounts(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  data_MyAccount = snapshot.data;
                  data_DataAc = data_MyAccount.data[0];
                  return ListView(
                    children: [
                      (data_DataAc.userStatus == 0)
                          ? Container()
                          : Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 18, right: 18, top: 18, bottom: 18),
                                child: Container(
                                  // height: 150,
                                  padding: EdgeInsets.only(
                                      left: 18, right: 18, top: 22, bottom: 22),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "https://png.pngtree.com/thumb_back/fw800/back_our/20190628/ourmid/pngtree-blue-background-with-geometric-forms-image_280879.jpg"),
                                        fit: BoxFit.cover),
                                  ),

                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "กระเป๋าหลัก(\u0E3F)",
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.white
                                                    .withOpacity(.7),
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            '${NumberFormat("#,###.##").format(data_DataAc.balance)}',
                                            style: TextStyle(
                                                fontSize: 24,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          ConstrainedBox(
                                            constraints:
                                                BoxConstraints.tightFor(
                                                    width: 100, height: 35),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.white),
                                              child: Text(
                                                'เติมเงิน',
                                                style: TextStyle(
                                                    color: Colors.blueAccent,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              onPressed: () {
                                                _ctrlPrice.text = "";

                                                _displayBottomSheet(
                                                    context, "topup");
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ConstrainedBox(
                                            constraints:
                                                BoxConstraints.tightFor(
                                                    width: 100, height: 35),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.white),
                                              child: Text(
                                                'ถอนเงิน',
                                                style: TextStyle(
                                                    color: Colors.blueAccent,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              onPressed: () {
                                                _ctrlPrice.text = "";
                                                _displayBottomSheet(
                                                    context, "withdraw");
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ],
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  void _displayBottomSheet(context, String select) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => SingleChildScrollView(
              child: Container(
                color: Color(0xFF737373),
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: _buildBottomNavigationMenu(context, select),
              ),
            ));
  }

  TextEditingController _ctrlPrice = TextEditingController(); //ราคา
  final _formKey = GlobalKey<FormState>();
  Container _buildBottomNavigationMenu(context, String select) {
    return Container(

        // height: (MediaQuery.of(context).viewInsets.bottom != 0) ? MediaQuery.of(context).size.height * .60 : MediaQuery.of(context).size.height * .30,
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(30),
                topRight: const Radius.circular(30))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "ระบุจำนวนเงิน(บาท)",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.blue,
                          size: 25,
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(7),
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}')),
                    ],
                    controller: _ctrlPrice,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      labelText: 'จำนวนเงิน',
                      hintText: '0.00',
                    ),
                    autofocus: false,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'โปรดระบุยอดเงิน';
                      }

                      if (select == 'topup') {
                        if (double.parse(_ctrlPrice.text) < 20) {
                          return 'ขั้นต่ำ 20 บาท';
                        }
                      } else if (select == 'withdraw') {
                        if (double.parse(_ctrlPrice.text) < 100) {
                          return 'ขั้นต่ำ 100 บาท';
                        } else if (double.parse(_ctrlPrice.text) >
                            data_DataAc.balance) {
                          return 'เงินคุณที่สามาถอนเงินได้ ${data_DataAc.balance} บาท';
                        }
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          if (_formKey.currentState.validate()) {
                            if (select == 'topup') {
                              if (double.parse(_ctrlPrice.text) >= 20) {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PaymentChannelPage(
                                            amount_to_fill:
                                                double.parse(_ctrlPrice.text),
                                          )),
                                ).then((value) => {
                                      if (token != "" && token != null)
                                        {getMyAccounts()}
                                    });
                              }
                            } else if (select == 'withdraw') {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WithdrawPage(
                                          amount_to_fill:
                                              double.parse(_ctrlPrice.text),
                                          name: data_DataAc.aliasName,
                                          email: data_DataAc.email,
                                        )),
                              ).then((value) => {
                                    if (token != "" && token != null)
                                      {getMyAccounts()}
                                  });
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ตกลง',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

}
