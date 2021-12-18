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

class HomeState extends State<Home> {
  String def =
      "https://purepng.com/public/uploads/large/purepng.com-mariomariofictional-charactervideo-gamefranchisenintendodesigner-1701528634653vywuz.png";
  List<Product> _newAudio = [];
  List<Product> _saleAudio = [];
  List<Product> _newLetter = [];
  List<Product> _saleLetter = [];
  List<Product> _newChild = [];
  List<Product> _saleChild = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newBooks();
  }

  void newBooks() async {
    var response = await Products.home();
    setState(() {
      _newAudio.addAll(response['newAudio']);
      _saleAudio.addAll(response['saleAudio']);
      _newLetter.addAll(response['newLetter']);
      _saleLetter.addAll(response['saleLetter']);
      _newChild.addAll(response['newChild']);
      _saleChild.addAll(response['saleChild']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, children: [
      Image(
        image: AssetImage("assets/images/head.png"),
      ),
      TitleWidget("تازه ترین کتاب های صوتی"),
      bookSection(_newAudio),

      TitleWidget("پرفروش‌‌‌‌ ترین کتاب های صوتی"),
      bookSection(_saleAudio),

      Image(
        image: AssetImage("assets/images/head.png"),
      ),
      TitleWidget("تازه ترین کتاب های کودکانه"),
      bookSection(_newChild),

      TitleWidget("پرفروش‌‌‌‌ ترین کتاب های کودکانه"),
      bookSection(_saleChild),

      Image(
        image: AssetImage("assets/images/head.png"),
      ),
      TitleWidget("تازه ترین نامه های صوتی"),
      bookSection(_newLetter),

      TitleWidget("پرفروش ترین نامه های صوتی"),
      bookSection(_saleLetter),
    ]);

    throw UnimplementedError();
  }

  Container bookSection(books) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(left: 8, right: 8),
      height: 170,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: books.length,
          itemBuilder: (context, index) {
            return ProductCard(product: books[index]);
          }),
    );
  }

  Padding TitleWidget(title) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
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
    );
  }
}
