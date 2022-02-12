import 'package:flutter/material.dart';
import 'package:kaghazsoti/models/category.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kaghazsoti/services/category_services.dart';

class CategoryChildren extends StatefulWidget {
  final Map children;

  const CategoryChildren({Key? key, required this.children}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CategoryChildrenState();
    throw UnimplementedError();
  }
}

class CategoryChildrenState extends State<CategoryChildren> {
  Map items = {};
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
    setState(() {
      items = widget.children;
    });
  }

  @override
  Widget build(BuildContext context) {
    var results = [];
    results = items['children'];
    return ListView.builder(
      // Let the ListView know how many items it needs to build.
      itemCount: results.length,
      // Provide a builder function. This is where the magic happens.
      // Convert each item into a widget based on the type of item it is.
      itemBuilder: (context, index) {
        final item = results[index];

        return GestureDetector(
          onTap: (() => _getChildren(context, results[index]['id'])),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(results[index]['title']),
                  Icon(Icons.keyboard_arrow_left),
                ]),
          ),
        );
      },
    );
    throw UnimplementedError();
  }
}

_getChildren(context, id) async {
  await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CategoryChildren(children: item)));
}
