import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/models/profile/wallet/my_his_topup_model.dart';
import 'package:easy_cook/models/profile/wallet/my_his_withdraw_model.dart';
import 'package:easy_cook/pages/profile_page/topup&withdraw/topup/payment_channel.dart';
import 'package:easy_cook/pages/profile_page/topup&withdraw/withdraw/withdrawPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  ScrollController _scrollController = ScrollController();
  int _currentMax;

  List dummyList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // dummyList = List.generate(10, (index) => "Item : ${index + 1}");
    _scrollController.addListener(() {
      print(
          "_scrollController.position.pixels = ${_scrollController.position.pixels}");
      print(
          '_scrollController.position.maxScrollExtent = ${_scrollController.position.maxScrollExtent}');
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreList();
      }
    });

    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     _getMoreList();
    //   }
    // });
  }

  // _getMoreList() {
  //   _currentMax = dummyList.length;
  //   print("Get More List");
  //   for (int i = _currentMax; i < _currentMax + 10; i++) {
  //     dummyList.add("Item : ${i + 1}");
  //   }
  //   _currentMax = _currentMax + 10;
  //   setState(() {});
  // }

  _getMoreList() {
    print("Get More List");
    _currentMax = dummyListDataListWithdrawTopup.length;

    if ((dataListWithdrawTopup.length -
            dummyListDataListWithdrawTopup.length) >=
        4) {
      for (int i = dummyListDataListWithdrawTopup.length;
          i < _currentMax + 4;
          i++) {
        dummyListDataListWithdrawTopup.add(dataListWithdrawTopup[i]);
      }
    } else {
      for (int i = dummyListDataListWithdrawTopup.length;
          i < dataListWithdrawTopup.length;
          i++) {
        dummyListDataListWithdrawTopup.add(dataListWithdrawTopup[i]);
      }
    }

    setState(() {});
  }

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

  List<MyHisWithdrawModel> data_my_his_withdraw;
  Future<List<MyHisWithdrawModel>> getMy_his_withdraw() async {
    final String apiUrl =
        "https://apifood.comsciproject.com/pjUsers/my_his_withdraw";

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

      // print(responseString);

      return myHisWithdrawModelFromJson(responseString);
    } else {
      return null;
    }
  }

  List<MyHisTopupModel> data_my_his_topup;
  Future<List<MyHisTopupModel>> getMy_his_topup() async {
    final String apiUrl =
        "https://apifood.comsciproject.com/pjUsers/my_his_topup";

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

      // print(responseString);

      return myHisTopupModelFromJson(responseString);
    } else {
      return null;
    }
  }

  List dataListWithdrawTopup = [];
  List dummyListDataListWithdrawTopup = [];
  Future<List> getListWithdrawTopup() async {
   
    dataListWithdrawTopup = [];
    for (int i = 0; i < data_my_his_withdraw.length; i++) {
      dataListWithdrawTopup.add(data_my_his_withdraw[i]);
    }

    for (int i = 0; i < data_my_his_topup.length; i++) {
      dataListWithdrawTopup.add(data_my_his_topup[i]);
    }
 


   

    selectionSort(dataListWithdrawTopup);
   
   

     

  
    return dataListWithdrawTopup;
  }

  void selectionSort(List array) {

    for (int i = 0; i < array.length-1; i++) {
      Duration difference =
          DateTime.now().difference(DateTime.parse("${array[i].datetime}"));
       
      int min = difference.inSeconds;


      int minId = i;
      for (int j = i+1; j<array.length; j++) {
       
        Duration difference =
            DateTime.now().difference(DateTime.parse("${array[j].datetime}"));
          
         
        if (difference.inSeconds < min) {
          min = difference.inSeconds;
          minId = j;
        }
           
      }

       
      // // swapping

      var temp = array[minId];
      array[minId] = array[i];
      array[i] = temp;
    }

    // return array;
  }

  String dateEdit(String date) {
    //data
    Map<String, String> map = {
      '01': "ม.ค.",
      '02': "ก.พ.",
      '03': "มี.ค.",
      '04': "เม.ย.",
      '05': "พ.ค.",
      '06': "มิ.ย.",
      '07': "ก.ค.",
      '08': "ส.ค.",
      '09': "ก.ย.",
      '10': "ต.ค.",
      '11': "พ.ย.",
      '12': "ธ.ค."
    };
    List<String> dateTimeSp = date.split(" ");
    List<String> dateSp = dateTimeSp[0].split("-");

    //time
    List timeSp = dateTimeSp[1].split(".");
    List time = timeSp[0].split(":");

    String text = "${int.parse(dateSp[2])} ${map[dateSp[1]]} - ${time[0]}:${time[1]}";
    return text;
  }

  String checkStatus(String data) {
    Map<String, String> map = {
      'successful': "สำเร็จ",
      'request': "กำลังตรวจสอบ",
      'pending': "รอดำเนินการ",
      'Promptpay': "พร้อมเพย์",
      'Visa': "วีซ่า",
    };
    return map[data];
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
                  return FutureBuilder(
                    future: getMy_his_withdraw(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        data_my_his_withdraw = snapshot.data;
                        return FutureBuilder(
                          future: getMy_his_topup(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              data_my_his_topup = snapshot.data;
                              return FutureBuilder(
                                future: getListWithdrawTopup(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    dataListWithdrawTopup = snapshot.data;
                                    if (dummyListDataListWithdrawTopup.length <
                                        10) {
                                      _currentMax =
                                          dummyListDataListWithdrawTopup.length;

                                      if ((dataListWithdrawTopup.length -
                                              dummyListDataListWithdrawTopup
                                                  .length) >=
                                          10) {
                                        for (int i =
                                                dummyListDataListWithdrawTopup
                                                    .length;
                                            i < _currentMax + 10;
                                            i++) {
                                          dummyListDataListWithdrawTopup
                                              .add(dataListWithdrawTopup[i]);
                                        }
                                      } else {
                                        for (int i =
                                                dummyListDataListWithdrawTopup
                                                    .length;
                                            i < dataListWithdrawTopup.length;
                                            i++) {
                                          dummyListDataListWithdrawTopup
                                              .add(dataListWithdrawTopup[i]);
                                        }
                                      }
                                    }
                                    return ListView(
                                      controller: _scrollController,
                                      children: [
                                        (data_DataAc.userStatus == 0)
                                            ? Container()
                                            : Column(
                                                children: [
                                                  Container(
                                                    color: Colors.white,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 18,
                                                              right: 18,
                                                              top: 18,
                                                              bottom: 18),
                                                      child: Container(
                                                        // height: 150,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 18,
                                                                right: 18,
                                                                top: 22,
                                                                bottom: 22),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          image: DecorationImage(
                                                              image: (data_DataAc.wallpaper == null) ? AssetImage('assets/wallpapers/default.jpg')  :AssetImage('${data_DataAc.wallpaper}'),
                                                              fit:
                                                                  BoxFit.cover),
                                                        ),

                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "กระเป๋าหลัก(\u0E3F)",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              .7),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                SizedBox(
                                                                  height: 12,
                                                                ),
                                                                Text(
                                                                  '${NumberFormat("#,###.##").format(data_DataAc.balance)}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          24,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800),
                                                                ),
                                                              ],
                                                            ),
                                                            Column(
                                                              children: [
                                                                ConstrainedBox(
                                                                  constraints: BoxConstraints
                                                                      .tightFor(
                                                                          width:
                                                                              100,
                                                                          height:
                                                                              35),
                                                                  child:
                                                                      ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                        primary:
                                                                            Colors.white),
                                                                    child: Text(
                                                                      'เติมเงิน',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .blueAccent,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      _ctrlPrice
                                                                          .text = "";

                                                                      _displayBottomSheet(
                                                                          context,
                                                                          "topup","เติม");
                                                                    },
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                ConstrainedBox(
                                                                  constraints: BoxConstraints
                                                                      .tightFor(
                                                                          width:
                                                                              100,
                                                                          height:
                                                                              35),
                                                                  child:
                                                                      ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                        primary:
                                                                            Colors.white),
                                                                    child: Text(
                                                                      'ถอนเงิน',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .blueAccent,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      _ctrlPrice
                                                                          .text = "";
                                                                      _displayBottomSheet(
                                                                          context,
                                                                          "withdraw","ถอน");
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
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 18,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Text("รายการเดินบัญชี"),
                                                      ],
                                                    ),
                                                  ),
                                                  ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount:
                                                          dummyListDataListWithdrawTopup
                                                                  .length +
                                                              1,
                                                      itemBuilder:
                                                          (context, index) {
                                                        if (index ==
                                                            dataListWithdrawTopup
                                                                .length) {
                                                          return Container();
                                                        }
                                                        if (index ==
                                                            dummyListDataListWithdrawTopup
                                                                .length) {
                                                          return Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              CupertinoActivityIndicator(),
                                                            ],
                                                          );
                                                        }

                                                        try {
                                                        dummyListDataListWithdrawTopup[index].wid;
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: ListTile(
                                                            // title: Text(
                                                            //   "ถอนเงิน - ${checkStatus(snapshot
                                                            // .data[index].status)}",
                                                            //   style: TextStyle(
                                                            //       fontSize: 18),
                                                            // ),
                                                            title: RichText(
                                                              text: TextSpan(
                                                                text:
                                                                    'ถอนเงิน - ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    color: Colors
                                                                        .black),
                                                                children: <
                                                                    TextSpan>[
                                                                  TextSpan(
                                                                    text:
                                                                        '${checkStatus(dummyListDataListWithdrawTopup[index].status)}',
                                                                    style: TextStyle(

                                                                        fontSize:
                                                                            15,
                                                                        color: (dummyListDataListWithdrawTopup[index].status == "request" ||dummyListDataListWithdrawTopup[index].status == "pending") ? Colors
                                                                            .grey.shade600 : Colors
                                                                            .green),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            trailing: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                  //${NumberFormat("#,###.##").format(widget.amount_to_fill)}
                                                                Text(
                                                                  "-${NumberFormat("#,###.##").format(dummyListDataListWithdrawTopup[index].amount)}",
                                                                  style: TextStyle(
                                                                      color: (dummyListDataListWithdrawTopup[index].status == "request" ||dummyListDataListWithdrawTopup[index].status == "pending") ? Colors
                                                                            .grey.shade600 : Colors
                                                                            .red,
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                                Text(dateEdit(
                                                                    "${dummyListDataListWithdrawTopup[index].datetime}")),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      } catch (e) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: ListTile(
                                                            title: RichText(
                                                              text: TextSpan(
                                                                text:
                                                                    'ฝากเงิน(${checkStatus('${dummyListDataListWithdrawTopup[index].brand}')}) - ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    color: Colors
                                                                        .black),
                                                                children: <
                                                                    TextSpan>[
                                                                  TextSpan(
                                                                    text:
                                                                        '${checkStatus(dummyListDataListWithdrawTopup[index].status)}',
                                                                    style: TextStyle(

                                                                        fontSize:
                                                                            18,
                                                                        color: (dummyListDataListWithdrawTopup[index].status == "request" ||dummyListDataListWithdrawTopup[index].status == "pending") ? Colors
                                                                            .grey.shade600 : Colors
                                                                            .green),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            trailing: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                                      crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  //NumberFormat("#,###.##").format(
                                                                  "+${NumberFormat("#,###.##").format(dummyListDataListWithdrawTopup[index].amount)}",
                                                                  style: TextStyle(
                                                                      color: (dummyListDataListWithdrawTopup[index].status == "request" || dummyListDataListWithdrawTopup[index].status == "pending") ? Colors
                                                                            .grey.shade600 : Colors
                                                                            .green,
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                                Text(dateEdit(
                                                                    "${dummyListDataListWithdrawTopup[index].datetime}")),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      })
                                                 
                                                ],
                                              ),
                                      ],
                                    );
                                  }
                                  return Center(
                                    child: CupertinoActivityIndicator(),
                                  );
                                },
                              );
                            }
                            return Center(
                              child: CupertinoActivityIndicator(),
                            );
                          },
                        );
                      }
                      return Center(
                        child: CupertinoActivityIndicator(),
                      );
                    },
                  );
                }
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              },
            );
          }
          return Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
    );
  }

  void _displayBottomSheet(context, String select,String text) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => SingleChildScrollView(
              child: Container(
                color: Color(0xFF737373),
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: _buildBottomNavigationMenu(context, select,text),
              ),
            ));
  }

  TextEditingController _ctrlPrice = TextEditingController(); //ราคา
  final _formKey = GlobalKey<FormState>();
  Container _buildBottomNavigationMenu(context, String select,String text) {
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
                        "ระบุจำนวน$textเงิน(บาท)",
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
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      ThousandsFormatter(allowFraction: true),
                      FilteringTextInputFormatter.deny("-")
                      // LengthLimitingTextInputFormatter(7),
                      // FilteringTextInputFormatter.allow(
                      //     RegExp(r'^(\d+)?\.?\d{0,2}')),
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
                        return '*โปรดระบุยอดเงิน';
                      }

                      // if (select == 'topup') {
                      //   if (double.parse(_ctrlPrice.text) < 20) {
                      //     return '*ขั้นต่ำ 20 บาท';
                      //   }
                      // } else if (select == 'withdraw') {
                      //   if (double.parse(_ctrlPrice.text) < 100) {
                      //     return '*ขั้นต่ำ 100 บาท';
                      //   } else if (double.parse(_ctrlPrice.text) >
                      //       data_DataAc.balance) {
                      //     return (data_DataAc.balance < 100) ? "*ไม่สามารถถอนได้ ยอดเงินที่คุณมีคือ ${data_DataAc.balance} บาท" :'*เงินคุณที่สามาถอนเงินได้ ${data_DataAc.balance} บาท';
                      //   }
                      // }
                      try {
                        String textCtrlPrice =
                            _ctrlPrice.text.replaceAll(",", "");
                        double money = double.parse(textCtrlPrice);
                        if (select == 'topup') {
                          if (money < 20) {
                            return '*ขั้นต่ำ 20 บาท';
                          } else if (money > 100000) {
                            return '*เติมสูงสุด 100,000 บาท ในแต่ละครั้งเท่านั้น';
                          }
                        } else if (select == 'withdraw') {
                          if (money < 100) {
                            return '*ขั้นต่ำ 100 บาท';
                          } else if (money > data_DataAc.balance) {
                            return (data_DataAc.balance < 100)
                                ? "*ไม่สามารถถอนได้ ยอดเงินที่คุณมีคือ ${NumberFormat("#,###.##").format(data_DataAc.balance)} บาท"
                                : '*เงินคุณที่สามาถอนเงินได้ ${NumberFormat("#,###.##").format(data_DataAc.balance)} บาท';
                          }else if (money > 100000) {
                            return '*ถอนสูงสุด 100,000 บาท ในแต่ละครั้งเท่านั้น';
                          }
                        }
                      } catch (e) {
                        return 'โปรดกรอกข้อมูลให้ถูกต้อง';
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      select == 'topup'
                          ? Text("*20 - 100,000 (บาท)")
                          : Text("*100 - 100,000 (บาท)")
                    ],
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
                              if (double.parse(_ctrlPrice.text.replaceAll(",", "")) >= 20) {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PaymentChannelPage(
                                            amount_to_fill:
                                                double.parse(_ctrlPrice.text.replaceAll(",", "")),
                                          )),
                                ).then((value) => {
                                      if (token != "" && token != null)
                                        {setState(() {})}
                                    });
                              }
                            } else if (select == 'withdraw') {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WithdrawPage(
                                          amount_to_fill:
                                              double.parse(_ctrlPrice.text.replaceAll(",", "")),
                                          name: data_DataAc.aliasName,
                                          email: data_DataAc.email,
                                        )),
                              ).then((value) => {
                                    if (token != "" && token != null)
                                      {setState(() {})}
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
