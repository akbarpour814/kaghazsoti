import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
                onTap : () => Navigator.pop(context),
                child: Icon(Icons.arrow_back),
              ),
              SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 10,
              ),
              Text(product.title , style: TextStyle(fontSize: 17),)
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
                    width: 200,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        Text("آلن دوباتن"),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
    throw UnimplementedError();
  }
}
