import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kaghazsoti/models/product.dart';
import 'package:kaghazsoti/services/product_services.dart';

class SingleBookScreen extends StatelessWidget {
  final Product product;

  SingleBookScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back),
              ),
              SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                product.title,
                style: TextStyle(fontSize: 17),
              )
            ],
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: product.image,
                    httpHeaders: {"Host": "kaghazsoti.develop"},
                    fit: BoxFit.cover,
                    width: 170,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10,bottom: 10,),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RatingBarIndicator(
                          rating: 2.75,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 30),
                          child: Text("از ۲ رای"),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      product.price,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10,),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 35.0,
                          width: 150,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1)),
                                primary: Color.fromRGBO(32, 151, 245, 1)
                            ),
                            onPressed: () {},
                            child: const Text('خرید',style: TextStyle(fontSize: 15),),
                          ),
                        ),
                        Container(
                          height: 35.0,
                          width: 150,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                side: BorderSide(color: Color.fromRGBO(32, 151, 245, 1)),
                                primary: Color.fromRGBO(32, 151, 245, 1)
                            ),
                            onPressed: () {},
                            child: const Text('خرید هدیه',style: TextStyle(fontSize: 15),),
                          ),
                        )
                      ],
                    ),
                  ),
                  DefaultTabController(
                    length: 3,
                    child: SizedBox(
                      height: 100.0,
                      child: Column(
                        children: <Widget>[
                          TabBar(
                            indicatorColor: Colors.lime,
                            tabs: <Widget>[
                              Tab(
                                text: "مشخصات",
                              ),
                              Tab(
                                text: "درباره کتاب",
                              ),
                              Tab(
                                text: "نظرات کاربران",
                              )
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: <Widget>[
                                Container(
                                  color: Colors.green,
                                ),
                                Container(
                                  color: Colors.yellow,
                                ),
                                Container(
                                  color: Colors.yellow,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
          ),
        ),
      ),
    );
    throw UnimplementedError();
  }
}
