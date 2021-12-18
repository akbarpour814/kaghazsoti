import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaghazsoti/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    var pageSize = MediaQuery.of(context).size;
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CachedNetworkImage(
              imageUrl: product.image,
              fit: BoxFit.cover,
              // width: 120,
            ),
            Container(
                // width: 120,
                // alignment: Alignment.centerRight,
                height: 40,
                width: 120,
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: RichText(
                          maxLines: 1,
                          text: TextSpan(
                              text: product.title,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontFamily: 'Vazir')
                          )
                      )
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
