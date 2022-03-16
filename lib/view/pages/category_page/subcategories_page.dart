import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '/model/category.dart';
import '/view/pages/category_page/books_page.dart';
import '/view/view_models/category_name.dart';
import '/view/view_models/player_bottom_navigation_bar.dart';

class SubcategoriesPage extends StatefulWidget {
  late IconData iconData;
  late String title;
  late List<Subcategory> subcategories;

  SubcategoriesPage({
    Key? key,
    required this.iconData,
    required this.title,
    required this.subcategories,
  }) : super(key: key);

  @override
  _SubcategoriesPageState createState() => _SubcategoriesPageState();
}

class _SubcategoriesPageState extends State<SubcategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: const PlayerBottomNavigationBar(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(widget.title),
      automaticallyImplyLeading: false,
      leading: Icon(
        widget.iconData,
      ),
      actions: [
        InkWell(
          child: const Padding(
            padding: EdgeInsets.all(18.0),
            child: Icon(
              Ionicons.chevron_back_outline,
            ),
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  SingleChildScrollView _body() {
    return SingleChildScrollView(
      child: Column(
        children: List<CategoryName>.generate(
          widget.subcategories.length,
          (index) => CategoryName(
            iconData: null,
            title: widget.subcategories[index].title,
            lastCategory: false,
            page: BooksPage(
              title:
              '${widget.title} - ${widget.subcategories[index].title}',
              books: widget.subcategories[index].books,
            ),
          ),
        ),
      ),
    );
  }
}
