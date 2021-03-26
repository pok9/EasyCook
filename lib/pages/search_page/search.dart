import 'package:easy_cook/models/search/searchRecipe_model.dart';
import 'package:easy_cook/pages/search_page/searchRecipeName.dart';
import 'package:easy_cook/pages/showfood_page/showFood.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:easy_cook/models/search/searchRecipe_model.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

String token = ""; //โทเคน
List<Datum> dataRecipe;
bool body = true;

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    findToken();
    // print("ttttt = "+token);
  }

  Future<Null> findToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");
    });
  }

  Future<Null> getSearchRecipeNames(String recipName) async {
    dataRecipe = [];
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/searchRecipeName/" + recipName;

    print("token = " + token);
    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        // dataRecipe = searchRecipeNameFromJson(responseString).data;
        dataRecipe = searchRecipeNameFromJson(responseString).data;
        // dataRecipe = searchRecipeNameFromJson(responseString).data;
        // print(dataRecipe[0].recipeName);
        // datas = myAccountFromJson(responseString);
        // dataUser = datas.data[0];
      });
    } else {
      flag = true;
      return null;
    }
  }

  TextEditingController _controller = TextEditingController();
  var menuFood = [
    'เมนูน้ำ',
    'เมนูต้ม',
    'เมนูสุขภาพ',
    'เมนูนึ่ง',
    'เมนูตุ๋น',
    'เมนูทอด'
  ];
  var iconFood = [
    'assets/logos/drink.png',
    'assets/logos/pot.png',
    'assets/logos/vegetables.png',
    'assets/logos/steam.png',
    'assets/logos/stew.png',
    'assets/logos/fried.png'
  ];
  // _search() {}
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('ค้นหา'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 12.0, bottom: 8.0), //กรอบ search
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: TextFormField(
                    onTap: (){
                      
                      body = false;
                      print(body);
                      setState(() {
                        
                      });
                    },
                    onChanged: (String text) {
                      setState(() {
                        if(text == ""){
                          body = true;
                        }
                        getSearchRecipeNames(text);
                      });
                    },
                    controller: _controller,
                    decoration: InputDecoration(
                        hintText: "ค้นหาสูตรอาหาร",
                        contentPadding: const EdgeInsets.only(left: 24.0),
                        border: InputBorder.none),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  // await getSearchRecipeNames();
                },
                // onPressed: () {
                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => SearchRecipeName(_controller.text)));
                //   Navigator.pushNamed(context, '/searchRecipeName',arguments: _controller.text);
                //   Navigator.pushNamedAndRemoveUntil(context, '/searchRecipeName', (route) => false);
                // },
              ),
            ],
          ),
        ),
      ),
      body: (_controller.text != "")
          ? ListView.builder(
              itemCount: dataRecipe.length,
              itemBuilder: (context, index) => (index < 0 && flag)
                  ? new SizedBox(
                      child: Container(),
                    )
                  : (dataRecipe == null)
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                            onTap: () {
                              print("index = " + index.toString());
                              print(dataRecipe[index]);
                              // Navigator.pushReplacement(context, newRoute)
                               Navigator.push(context,
                                        CupertinoPageRoute(builder: (context) {
                                      return ShowFood(dataRecipe[index]);
                                    }));
                            },
                            child: Container(
                              child: FittedBox(
                                child: Material(
                                  color: Colors.white,
                                  elevation: 14.0,
                                  borderRadius: BorderRadius.circular(24.0),
                                  shadowColor: Color(0x802196F3),
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: myDetailsContainer3(
                                              dataRecipe, index),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 50,
                                      ),
                                      Container(
                                        width: 250,
                                        height: 180,
                                        child: ClipRRect(
                                          borderRadius:
                                              new BorderRadius.circular(24.0),
                                          child: Image(
                                            fit: BoxFit.cover,
                                            alignment: Alignment.topRight,
                                            image: NetworkImage(
                                                dataRecipe[index].image),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ))
          : (body == false) ? Container() : GridView.count(
              crossAxisCount: 4,
              children: List.generate(6, (index) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.black,
                          backgroundImage: AssetImage(iconFood[index]),
                        ),
                      ),
                      Text(
                        menuFood[index],
                        // style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                );
              })),
    );
  }
}

Widget myDetailsContainer3(List<Datum> data, int index) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(
            child: Text(
          dataRecipe[index].recipeName,
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        )),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(
            child: Row(
          children: <Widget>[
            Container(
                child: Text(
              dataRecipe[index].score.toString(),
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            )),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStarHalf,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
                child: Text(
              "(50)",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            )),
          ],
        )),
      ),
      SizedBox(
        height: 50,
      ),
      Row(
        children: [
          new Container(
            height: 70.0,
            width: 70.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(dataRecipe[index].profileImage))),
          ),
          new SizedBox(
            width: 10.0,
          ),
          new Text(
            dataRecipe[index].aliasName,
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    ],
  );
}
