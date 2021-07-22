import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RecipePurchasePage extends StatefulWidget {
  // const RecipePurchasePage({ Key? key }) : super(key: key);
  int rigCtgy;
  String imageFoodCtgy;
  
  RecipePurchasePage({this.rigCtgy,this.imageFoodCtgy});


  @override
  _RecipePurchasePageState createState() => _RecipePurchasePageState();
}

class _RecipePurchasePageState extends State<RecipePurchasePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('Test'),
      ),
      body: Column(
        children: [
          Hero(
            tag: this.widget.rigCtgy,
            child: Image.network(
              this.widget.imageFoodCtgy,
              height: size.height * 0.25,
              fit: BoxFit.fill,
              width: double.infinity,
            ),
          ),
          Expanded(
            child: ItemInfo(),
          )
        ],
      ),
    );
  }
}

class ItemInfo extends StatelessWidget {
  const ItemInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.grey,
              ),
              SizedBox(
                width: 10,
              ),
              Text("MacDonalds")
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cheese Burger',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: 3,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.blue,
                          ),
                          itemCount: 5,
                          itemSize: 20.5,
                          direction: Axis.horizontal,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("24 reviews")
                      ],
                    ),
                  ],
                )),
                ClipPath(
                  child: Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    height: 66,
                    width: 65,
                    color: Colors.yellow[600],
                    child: Text(
                      "\$15",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
          Text(
            "wqiriqwriqjwirjqwrjqwr q89wrh89qwh8r9hq8w9rh89 8qh89rhqw89rh89qhw89rh 98qh89whr 89qhwr 89qwhw89hq89rwh89qwhr89qhw8 9q89r 89qwhr 89qwh 89hqw89 rhq89hrw89hq89w 89qwhr89qwhr89hq89whr89qwh89rqhw89rqw90jqej09qw  qwje90qwje90qjw90ej90qwje90jq90wej90qwjwe90 qwe90jqw90ej9qwje9qw09e0q9wej90",
            style: TextStyle(height: 1.5),
          ),
          SizedBox(
            height: size.height * 0.1,
          ),
          Container(
            // padding: EdgeInsets.all(20),
            width: size.width * 0.8,
            decoration: BoxDecoration(
                color: Colors.yellow[600],
                borderRadius: BorderRadius.circular(10)),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.backpack_sharp,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Order Now',
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
        ],
      ),
    );
  }
}
