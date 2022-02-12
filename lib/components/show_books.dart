import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaghazsoti/models/product.dart';

class ShowBook extends StatelessWidget {
  final Product product;

  ShowBook({required this.product});

  @override
  Widget build(BuildContext context) {
    String bookTitle = product.title;
    var pageSize = MediaQuery.of(context).size;
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        null;
      },
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(children: <Widget>[
          Divider(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: product.image,
                    httpHeaders: {"Host": "kaghazsoti.develop"},
                    fit: BoxFit.cover,
                    width: 70,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bookTitle.substring(
                                  0,
                                  (bookTitle.length > 30)
                                      ? 30
                                      : bookTitle.length),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            Text("آلن دوباتن"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text("جامی"),
                      )
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("5 رای"),
                    Text("۴ ستاره"),
                    Text("۲۵،۰۰۰ هزار تومان"),
                  ],
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}
