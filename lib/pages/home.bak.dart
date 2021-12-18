import 'package:flutter/material.dart';

class Home extends StatelessWidget{

  final audioBooks = Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    width: 100.0,
                    height: 130.0,
                    decoration: BoxDecoration(
                        border: Border.all(color: Color.fromRGBO(0, 160, 227, .5))
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image(
                          image: NetworkImage(
                              "https://fenix.ir/storage/users/meta/5/image_75_photo-2019-05-20-21-59-11-1558510763_1559902388.jpg"),
                          fit: BoxFit.fitWidth,
                          width: 100.0,
                        ),
                        Center(child: Text("شازده کوچولو",style: TextStyle(color: Color.fromRGBO(0, 160, 227, 1)),),)
                      ],
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                  ),
                ],
              );
            }
        ),
      )
  );


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Image(image: AssetImage("assets/images/head.png"),),
          Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("تازه ترین کتاب های صوتی",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 15)),
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
                    child: Text("مشاهده همه",
                        style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
          audioBooks,
          Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("پر فروش ترین ها",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 15)),
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
                    child: Text("مشاهده همه",
                        style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
          audioBooks,
        ],
      ),
    );
    throw UnimplementedError();
  }

}