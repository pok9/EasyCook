import 'package:easy_cook/models/feed/newfeedsglobal/newfeedsglobal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class Feed2Page extends StatefulWidget {
  // const Feed2Page({ Key? key }) : super(key: key);

  @override
  _Feed2PageState createState() => _Feed2PageState();
}

class _Feed2PageState extends State<Feed2Page> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewfeedsglobal();
  }

  List<Newfeedsglobal> dataNewfeedsglobal;
  Future<Null> getNewfeedsglobal() async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/newfeedsglobal";

    final response = await http.get(Uri.parse(apiUrl));
    // print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        dataNewfeedsglobal = newfeedsglobalFromJson(responseString);
      });
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: (dataNewfeedsglobal == null)
          ? Container()
          : GridView.builder(
              // scrollDirection: Axis.vertical,
              // shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                // maxCrossAxisExtent: 200,
                mainAxisExtent: 290,

                maxCrossAxisExtent: (deviceSize.width > 400) ? 250 : 200,
              ),
              itemCount: dataNewfeedsglobal.length,
              itemBuilder: (BuildContext ctx, index) {
                return InkWell(
                  onTap: () {
                    print(deviceSize.width);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => ShowFood(
                    //           dataNewfeedsglobal[index]
                    //               .rid)),
                    // );
                  },
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  new Container(
                                    height: 30.0,
                                    width: 30.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new NetworkImage(
                                                dataNewfeedsglobal[index]
                                                    .profileImage))),
                                  ),
                                  new SizedBox(
                                    width: 10.0,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        new Text(
                                          dataNewfeedsglobal[index].aliasName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        new Text(
                                          "1 นาทีที่แล้ว",
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              IconButton(
                                  icon: Icon(Icons.more_vert),
                                  onPressed: () {
                                    // print("more_vert" + index.toString());
                                  })
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 0, 0, 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  dataNewfeedsglobal[index].recipeName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // SizedBox(height: 19,),

                        Container(
                          height: 161,
                          // width: 500,
                          decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(50),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      dataNewfeedsglobal[index].image),
                                  fit: BoxFit.cover)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RatingBarIndicator(
                                rating: 3,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.blue,
                                ),
                                itemCount: 5,
                                itemSize: 16,
                              ),
                              Text("ฟรี"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
