import 'package:flutter/material.dart';
import 'package:kaghazsoti/models/category.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kaghazsoti/services/product_services.dart';

import 'category_children.dart';

class SearchByCategory extends StatefulWidget {
  final int id;

  const SearchByCategory({Key? key, required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SearchByCategoryState();
    throw UnimplementedError();
  }
}

class SearchByCategoryState extends State<SearchByCategory> {
  var items = [];

  void initState() {
    // TODO: implement initState
    super.initState();
    newBooks();
  }

  void _printLatestValue() {
    setState(() {
      newBooks();
    });
  }

  void newBooks() async {
    var response = await Products.getBySearch(id: widget.id);
    setState(() {
      items = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // Let the ListView know how many items it needs to build.
      itemCount: items.length,
      // Provide a builder function. This is where the magic happens.
      // Convert each item into a widget based on the type of item it is.
      itemBuilder: (context, index) {
        final item = items[index];

        return GestureDetector(
          onTap: (() => _getChildren(context, items[index])),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(items[index]['title']),
                  Icon(Icons.keyboard_arrow_left),
                ]),
          ),
        );
      },
    );
    throw UnimplementedError();
  }
}

_getChildren(context, item) async {
  await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CategoryChildren(children: item)));
}
