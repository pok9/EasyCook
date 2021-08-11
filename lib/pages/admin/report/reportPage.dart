import 'package:easy_cook/models/report/getAllReport_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReportPage extends StatefulWidget {
  // const ReportPage({ Key? key }) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
  }

  String token = ""; //โทเคน
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");
      print("Token >>> $token");
      if (token != "" || !token.isEmpty) {
        getAllReport();
      }
    });
  }

  List<GetAllReportModel> dateGetAllReport;
  Future<Null> getAllReport() async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/getAllReport";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer ${token}"});
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;
        dateGetAllReport = getAllReportModelFromJson(responseString);
      });
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('การรายงานเข้ามา'),
      ),
      body: (dateGetAllReport == null)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              reverse: true,
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              // scrollDirection: Axis.v,
              itemCount: dateGetAllReport.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.all(1),
                  child: ListTile(
                    // leading: FlutterLogo(size: 72.0),
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              dateGetAllReport[index].profileUserReport),
                        ),
                      ],
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(dateGetAllReport[index].title),
                    ),
                    subtitle: Text("${dateGetAllReport[index].datetime}"),
                    trailing: Icon(Icons.more_horiz),
                    isThreeLine: true,
                    onTap: () {},
                  ),
                );
              }),
    );
  }
}
