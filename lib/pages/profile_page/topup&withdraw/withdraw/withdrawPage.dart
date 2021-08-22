import 'package:flutter/material.dart';

class WithdrawPage extends StatefulWidget {
  // const WithdrawPage({ Key? key }) : super(key: key);

  double amount_to_fill;
  WithdrawPage({this.amount_to_fill});

  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
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

  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('ถอนเงิน'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton(
                      hint: Text('Selct Bank'),
                      value: _selected,
                      onChanged: (newValue) {
                        setState(() {
                          _selected = newValue;
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
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                labelText: 'ชื่อบัญชี',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                labelText: 'หมายเลขบัญชี',
                hintText: 'XXXX XXXX XXXX XXXX',
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
                child: Text('ถอนเงิน'),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
