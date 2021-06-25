import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewPage extends StatefulWidget {
  // ReviewPage({Key? key}) : super(key: key);
  double rating = 0.0;
  ReviewPage(this.rating);

  @override
  _ReviewPageState createState() => _ReviewPageState(this.rating);
}

class _ReviewPageState extends State<ReviewPage> {
  double _rating;

  _ReviewPageState(this._rating);
  @override
  Widget build(BuildContext context) {
    var sizeScreen = MediaQuery.of(context).size;
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Container(
        // width: 50,
        child: Column(
          mainAxisSize: MainAxisSize.min, //autoSize

          children: [
            // ignore: missing_required_param
            RatingBar.builder(
              initialRating: _rating,
              minRating: 0.5,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                // color: Colors.amber,
                color: Colors.blue,
              ),
              // onRatingUpdate: (rating) {
              //   print(rating);
              // },
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                // controller: _ctrlExplain,
                // maxLength: 60,
                minLines: 3,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFFAFAFA),
                  border: OutlineInputBorder(),
                  hintText: "เขียนรีวิว",
                  hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('ยกเลิก'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('โพสต์'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
