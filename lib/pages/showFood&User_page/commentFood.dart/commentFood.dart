import 'package:flutter/material.dart';

class CommentFood extends StatefulWidget {
  @override
  _CommentFoodState createState() => _CommentFoodState();
}

class _CommentFoodState extends State<CommentFood> {
  TextEditingController commentController = TextEditingController();
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
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  // scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ListTile(
                      isThreeLine: true,
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://static.wikia.nocookie.net/characters/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20171118221229"),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text(
                          '1Horseqwerw',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Text(
                        '05-11-20\n\nthe logo to lay out, and then asks the icon to lay out. The Icon, like the logo, is happy to take on a reasonable size (also 24 pixels, not coincidentally, since both FlutterLogo and Icon honor the ambient IconTheme). This leaves some room left over, and now the row tells the text exactly how wide to be: the exact width of the remaining space. The text, now happy to comply to a reasonable request, wraps the text within that width, and you end up with a paragraph split over several lines.',
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
                      autofocus: true,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      // contentPadding: const EdgeInsets.symmetric(vertical: 1.0,horizontal: 20),
                      hintText: "แสดงความคิดเห็น...",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40))),
                )),
                TextButton(onPressed: () {}, child: Text("โพสต์"))
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
