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
    var screenWidth = MediaQuery.of(context).size.width;
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
        body: ListView(shrinkWrap: true, children: [Container(
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
                    padding: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
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
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
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
                                side: BorderSide(
                                    color: Color.fromRGBO(0, 160, 227, 1)),
                                primary: Color.fromRGBO(32, 151, 245, 1)),
                            onPressed: () {},
                            child: const Text(
                              'خرید',
                              style: TextStyle(fontSize: 15),
                            ),
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
                                side: BorderSide(
                                    color: Color.fromRGBO(32, 151, 245, 1)),
                                primary: Color.fromRGBO(32, 151, 245, 1)),
                            onPressed: () {},
                            child: const Text(
                              'خرید هدیه',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 300.0,
                    child: DefaultTabController(
                        initialIndex: 0,
                        length: 3,
                        child: Scaffold(
                          appBar: AppBar(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                 Radius.circular(5),
                              ),
                            ),
                            toolbarHeight: 10,
                            backgroundColor: Colors.black,
                            automaticallyImplyLeading: false,
                            elevation: 0,
                            bottom: const TabBar(
                                indicator: UnderlineTabIndicator(
                                  borderSide: BorderSide(
                                      width: 3.0,
                                      color: Color.fromRGBO(52, 167, 149, 1)),
                                ),
                                tabs: [
                                  Tab(
                                    text: "مشخصات",
                                  ),
                                  Tab(
                                    text: "درباره کتاب",
                                  ),
                                  Tab(
                                    text: "نظرات کاربران",
                                  ),
                                ]),
                          ),
                          body: TabBarView(children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.all(Radius.circular(5.0))
                              ),
                              child: Column(
                                children: [
                                  _book_detail("نام:",product.title,screenWidth),
                                  _book_detail("دسته:","کتاب صوتی - رمان",screenWidth),
                                  _book_detail("نویسنده:","آنتوان دو سنت اگزوپری",screenWidth),
                                  _book_detail("گوینده:","الهام ایرانیا",screenWidth),
                                  _book_detail("حجم دانلود:","۱۵۲ مگ",screenWidth),
                                  _book_detail("ناشر چاپی:","آسو",screenWidth),
                                ],
                              ),
                            ),
                            Icon(Icons.apps),
                            Icon(Icons.movie),
                          ]),
                        )
                    ),
                  )
                ],
              )),
        )]),
      ),
    );
    throw UnimplementedError();
  }

  _book_detail(title,detail,screenWidth){
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          width : screenWidth * .4,
          child: Text(title,style: TextStyle(color: Colors.white),),
        ),
        Text(detail,style: TextStyle(color: Colors.white),),
      ],
    );
  }
}
