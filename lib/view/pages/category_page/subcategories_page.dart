import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '/view/pages/category_page/subcategory_books_page.dart';
import '../../../main.dart';
import '/model/category.dart';
import '../../view_models/books_page.dart';
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
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: playerBottomNavigationBar,
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
            title: widget.subcategories[index].name,
            lastCategory: false,
            page: SubcategoryBooksPage(subcategory: widget.subcategories[index],),
          ),
        ),
      ),
    );
  }
}
