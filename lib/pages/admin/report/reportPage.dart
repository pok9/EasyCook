import 'package:easy_cook/models/report/getReport_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReportPage extends StatefulWidget {
  String report_ID;
  ReportPage({this.report_ID});
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
      if (token != "" && token != null) {
        // getMyAccounts();
        getReport();
      }
    });
  }

  GetReportModel dataGetReport;
  DataTarget dataTarget;
  DataUserReport dataUserReport;
  DataRecipe dataRecipe;
  Future<Null> getReport() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjPost/getReport/" +
        this.widget.report_ID;

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});

    print("dataGetReportresponse.statusCode = ${response.statusCode}");
    print("dataGetReportresponse.body = ${response.body}");
    if (response.statusCode == 200) {
      final String responseString = response.body;

      dataGetReport = getReportModelFromJson(responseString);
      dataTarget = dataGetReport.dataTarget;
      dataUserReport = dataGetReport.dataUserReport;
      dataRecipe = dataGetReport.dataRecipe;
      setState(() {});
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((dataGetReport == null) ? "" : dataGetReport.title),
      ),
      body: (dataGetReport == null)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Card(
                    color: Colors.grey.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  "บัญชีผู้ใช้ที่โดนแจ้งรายงาน",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage: NetworkImage(
                                          dataTarget.profileUserTarget),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          dataTarget.aliasUserTarget,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          dataTarget.nameUserTarget,
                                          style: TextStyle(fontSize: 15),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                (dataRecipe == null)
                    ? Container()
                    : (dataRecipe.recipeId == null &&
                            dataRecipe.recipeImage == null &&
                            dataRecipe.recipeName == null)
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Card(
                              color: Colors.grey.shade100,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "สูตรอาหารที่โดนแจ้งรายงาน",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                    (dataRecipe == null)
                                        ? Container()
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Text.rich(
                                                        TextSpan(children: <
                                                            InlineSpan>[
                                                  TextSpan(
                                                    text: "ชื่อสูตรอาหาร : ",
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                    text: dataRecipe.recipeName,
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                    ),
                                                  )
                                                ])))
                                              ],
                                            ),
                                          ),
                                    (dataRecipe == null)
                                        ? Container()
                                        : (dataRecipe.recipeImage == null)
                                            ? Container()
                                            : FadeInImage.assetNetwork(
                                                placeholder:
                                                    'assets/logos/loadding.gif',
                                                image: dataRecipe.recipeImage,
                                              ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Card(
                    color: Colors.grey.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  dataGetReport.title,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    dataGetReport.description,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                )
                              ],
                            ),
                          ),
                          (dataGetReport.image == "")
                              ? Container()
                              : FadeInImage.assetNetwork(
                                  placeholder: 'assets/logos/loadding.gif',
                                  image: dataGetReport.image,
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Card(
                    color: Colors.grey.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  "บัญชีผู้ใช้ที่แจ้งรายงาน",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                NetworkImage(dataUserReport.profileUserReport),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                dataUserReport.aliasUserReport,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                dataUserReport.nameUserReport,
                                style: TextStyle(fontSize: 15),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
