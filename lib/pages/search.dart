import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kaghazsoti/models/product.dart';
import 'package:kaghazsoti/services/product_services.dart';

class Search extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchState();
    throw UnimplementedError();
  }
}

class SearchState extends State<Search> {
  List<Product> _books = [];
  String _query = '';
  final _searchController = TextEditingController();


  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener(_printLatestValue);
    newBooks();
  }

  void _printLatestValue() {
    setState(() {
      _query = _searchController.text;
      newBooks();
    });
  }

  void newBooks() async {
    var response = await Products.search(query: _query);
    setState(() {
      _books = response;
    });
  }

   _searchBox(){
     return TextField(
       controller: _searchController,
     );
  }

  @override
  Widget build(BuildContext context) {
    if(_books.isEmpty){
      return _searchBox();
    }
    return ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: _books.length,
        itemBuilder: (context, index) {
          String bookTitle = _books[index].title;
          if (index == 0) {
            return _searchBox();
          }
          return Padding(
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
                        imageUrl:
                            _books[index].image,
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
                                 bookTitle.substring(0,(bookTitle.length > 30) ? 30 : bookTitle.length ),
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
          );
        });
    throw UnimplementedError();
  }
}
