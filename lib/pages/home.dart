import 'package:flutter/material.dart';
import 'package:kaghazsoti/components/product_card.dart';
import 'package:kaghazsoti/models/home.dart';
import 'package:kaghazsoti/models/product.dart';
import 'package:kaghazsoti/services/product_services.dart';

class Home extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return HomeState();
    throw UnimplementedError();
  }

}

class HomeState extends State<Home>{
  String def = "https://purepng.com/public/uploads/large/purepng.com-mariomariofictional-charactervideo-gamefranchisenintendodesigner-1701528634653vywuz.png";
  List<Product> _newBokks = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newBooks();
  }
  void newBooks() async {
    var response = await Products.home();
    setState(() {
      // print(response);
      _newBokks.addAll(response['products']);
      print(_newBokks);
    });

  }

  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, children: [
      Image(
        image: AssetImage("assets/images/head.png"),
      ),
      Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("تازه ترین کتاب های صوتی",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            Container(
              height: 40.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))),
                onPressed: () {},
                padding: EdgeInsets.all(5.0),
                color: Colors.white,
                textColor: Color.fromRGBO(0, 160, 227, 1),
                child: Text("مشاهده همه", style: TextStyle(fontSize: 13)),
              ),
            ),
          ],
        ),
      ),
      Container(
        color: Colors.white,
        margin: EdgeInsets.only(left: 8, right: 8),
        height: 170,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _newBokks.length,
            itemBuilder: (context, index) {
              return ProductCard(product: _newBokks[index]);
            }),
      ),
      Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("پرفروش ترین کتاب های صوتی",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            Container(
              height: 40.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))),
                onPressed: () {},
                padding: EdgeInsets.all(5.0),
                color: Colors.white,
                textColor: Color.fromRGBO(0, 160, 227, 1),
                child: Text("مشاهده همه", style: TextStyle(fontSize: 13)),
              ),
            ),
          ],
        ),
      ),
      Container(
        color: Colors.white,
        margin: EdgeInsets.only(left: 8, right: 8),
        height: 160,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: Card(
                  child: Column(
                    children: [
                      Image.network(
                        "https://purepng.com/public/uploads/large/purepng.com-mariomariofictional-charactervideo-gamefranchisenintendodesigner-1701528634653vywuz.png",
                        width: 100,
                        height: 100,
                      ),
                      Container(
                          width: 100,
                          color: Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Text(
                                  " شازده کوچولو $index ",
                                  style: TextStyle(fontSize: 12),
                                )),
                          ))
                    ],
                  ),
                ),
              );
            }),
      ),
    ]);

    throw UnimplementedError();
  }

}
