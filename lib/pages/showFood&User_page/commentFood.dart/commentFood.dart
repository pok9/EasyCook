import 'dart:convert';

import 'package:easy_cook/models/showfood/commentFood_model.dart/commentPost_model.dart';
import 'package:easy_cook/models/showfood/commentFood_model.dart/getCommentPost_model.dart';
import 'package:easy_cook/pages/login&register_page/login_page/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CommentFood extends StatefulWidget {
  String recipe_ID;
  bool autoFocus;
  CommentFood({this.recipe_ID, this.autoFocus});

  @override
  _CommentFoodState createState() => _CommentFoodState();
}

class _CommentFoodState extends State<CommentFood> {
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    findUser();
    getCommentPosts();
  }

  String token = ""; //โทเคน
  //ดึง token
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");
    });
  }

  List<GetCommentPostModel> dataGetCommentPost;
  Future<Null> getCommentPosts() async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/getComment/" +
            this.widget.recipe_ID;

    final response = await http.get(Uri.parse(apiUrl));
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        dataGetCommentPost = getCommentPostModelFromJson(responseString);
      });
    } else {
      return null;
    }
  }

  Future<CommentPostModel> CommentPost(
      String recipe_ID, String commentDetail, String token) async {
    final String apiUrl = "http://apifood.comsciproject.com/pjPost/commentPost";

    var data = {
      "recipe_ID": recipe_ID,
      "commentDetail": commentDetail,
    };

    print(jsonEncode(data));
    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });

    if (response.statusCode == 200) {
      final String responseString = response.body;

      return commentPostModelFromJson(responseString);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("แสดงความคิดเห็น"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: ListView(
            children: [
              (dataGetCommentPost == null)
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      // scrollDirection: Axis.horizontal,
                      itemCount: (dataGetCommentPost == null)
                          ? 0
                          : dataGetCommentPost.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          isThreeLine: true,
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                dataGetCommentPost[index].profileImage),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text(
                              dataGetCommentPost[index].aliasName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          subtitle: Text(
                            '${dataGetCommentPost[index].datetime}\n\n${dataGetCommentPost[index].commentDetail}',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'OpenSans',
                              fontSize: 12,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          dense: true,
                          // trailing: Text('Horse'),
                        );
                      })
            ],
          )),
          Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  onTap: () {
                    if (token == "") {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return LoginPage();
                          }).then((value) {
                        if (value != null) {
                          this.findUser();
                        }

                        // Navigator.pop(context);
                      });
                    }
                  },
                  controller: commentController,
                  autofocus: this.widget.autoFocus,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      // contentPadding: const EdgeInsets.symmetric(vertical: 1.0,horizontal: 20),
                      hintText: "แสดงความคิดเห็น...",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40))),
                )),
                TextButton(
                    onPressed: () async {
                      if (token == "") {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return LoginPage();
                            }).then((value) {
                          if (value != null) {
                            this.findUser();
                          }

                          // Navigator.pop(context);
                        });
                      } else {
                        print("โพส");
                        print(commentController.text);
                        CommentPostModel commentPostModel = await CommentPost(
                            this.widget.recipe_ID,
                            commentController.text,
                            token);

                        if (commentPostModel.success == 1) {
                          getCommentPosts();
                          commentController.text = "";
                        }
                      }
                    },
                    child: Text("โพสต์"))
                // CircleAvatar(
                //     child: IconButton(onPressed: () {}, icon: Icon(Icons.send)))
              ],
            ),
          )
        ],
      ),
    );
  }
}
