import 'package:easy_cook/pages/profile_page/topup&withdraw/topup/topupPage.dart';
import 'package:flutter/material.dart';

class PaymentChannelPage extends StatefulWidget {
  // const PaymentChannelPage({ Key? key }) : super(key: key);
  double amount_to_fill;

  PaymentChannelPage({this.amount_to_fill});

  @override
  _PaymentChannelPageState createState() => _PaymentChannelPageState();
}

class _PaymentChannelPageState extends State<PaymentChannelPage> {

  

  int _selection = 0;

  selectTime(int timeSelected) {
    setState(() {
      _selection = timeSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    var sizeScreen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('เติมเงิน'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'เติมเงิน',
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
                  child: Row(
                    children: [
                      Text('เลือกช่องทางการเติมเงิน',
                          style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selection = 1;
                      });
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent),
                            borderRadius: BorderRadius.all(Radius.circular(
                                    5.0) //                 <--- border radius here
                                ),
                            color: _selection == 1
                                ? Colors.grey.shade400
                                : Colors.white,
                          ),
                          height: 50,
                          width: sizeScreen.width,
                          // color: _selection == 1 ? Colors.grey.shade400 : Colors.white,
                        ),
                        Row(
                          children: <Widget>[
                            Radio(
                              focusColor: Colors.white,
                              groupValue: _selection,
                              onChanged: selectTime,
                              value: 1,
                            ),
                            Text(
                              "บัตรเครดิต / บัตรเดบิต",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Padding(
                //   padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                //   child: InkWell(
                //     onTap: () {
                //       setState(() {
                //         _selection = 2;
                //       });
                //     },
                //     child: Stack(
                //       children: <Widget>[
                //         Container(
                //           height: 50,
                //           width: sizeScreen.width,
                //           color: _selection == 2 ? Colors.green : Colors.white,
                //         ),
                //         Row(
                //           children: <Widget>[
                //             Radio(
                //               focusColor: Colors.white,
                //               groupValue: _selection,
                //               onChanged: selectTime,
                //               value: 2,
                //             ),
                //             Text(
                //               "ff",
                //               style: TextStyle(fontWeight: FontWeight.bold),
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // )
              ],
            ),
          ),
          Container(
            height: 120,
            padding: EdgeInsets.all(5),
            color: Colors.grey.shade200,
            child: Padding(
              padding: const EdgeInsets.only(left: 18, right: 18),
              child: Row(
                children: [
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'ยอดเติมเงิน  ฿${widget.amount_to_fill}',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      OutlinedButton(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text("เติมเงิน"),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          primary: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(18),
                            ),
                          ),
                        ),
                        onPressed: (_selection != 0) ? () {
                          if(_selection == 1){
                            Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TopupPage(amount_to_fill: this.widget.amount_to_fill,)),
                                      );
                          }
                        } : null,
                      ),
                    ],
                  )),
                  // TextButton(onPressed: () async {}, child: Text("เติมเงิน"))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
