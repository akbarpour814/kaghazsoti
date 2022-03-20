import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '/controller/database.dart';
import '/view/pages/category_page/subcategories_page.dart';
import '/view/view_models/category_name.dart';
import '/view/view_models/player_bottom_navigation_bar.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: const PlayerBottomNavigationBar(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('دسته بندی'),
      leading: const Icon(
        Ionicons.albums_outline,
      ),
    );
  }

  SingleChildScrollView _body() {
    return SingleChildScrollView(
      child: Column(
        children: List<CategoryName>.generate(
          database.categories.length,
          (index) => CategoryName(
            iconData: database.categories[index].iconData,
            title: database.categories[index].title,
            lastCategory: false,
            page: SubcategoriesPage(
              iconData: database.categories[index].iconData,
              title: database.categories[index].title,
              subcategories: database.categories[index].subcategories,
            ),
          ),
        ),
      ),
    );
  }
}
