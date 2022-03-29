import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ionicons/ionicons.dart';
//import '/controller/database.dart';
import '../../../controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
import '../../../main.dart';
import '../../../model/category.dart';
import '../../view_models/custom_circular_progress_indicator.dart';
import '/view/pages/category_page/subcategories_page.dart';
import '/view/view_models/category_name.dart';
import '/view/view_models/player_bottom_navigation_bar.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late  bool _internetConnectionChecker;
  late Response<dynamic> _customDio;
  late CustomResponse _customResponse;
  late List<Category> _categories;

  @override
  void initState() {
    _categories = [];

    super.initState();
  }

  Future _initCategories() async {
    _internetConnectionChecker = await InternetConnectionChecker().hasConnection;

    if(_internetConnectionChecker) {
      _customDio = await CustomDio.dio.post('categories');

      if(_customDio.statusCode == 200) {
        _categories.clear();

        _customResponse = CustomResponse.fromJson(_customDio.data);

        Map<String, IconData> categoriesIcon = {
          'کتاب صوتی': Ionicons.musical_notes_outline,
          'نامه صوتی': Ionicons.mail_open_outline,
          'کتاب الکترونیکی': Ionicons.laptop_outline,
          'پادکست': Ionicons.volume_medium_outline,
          'کتاب کودک و نوجوان': Ionicons.happy_outline,
        };

        for(Map<String, dynamic> category in _customResponse.data) {
          _categories.add(Category.fromJson(categoriesIcon[category['name']] ?? Ionicons.albums_outline, category));
        }
      }
    }

    return _customDio;
  }

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
      title: const Text('دسته بندی'),
      leading: const Icon(
        Ionicons.albums_outline,
      ),
    );
  }

  FutureBuilder _body() {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? _innerBody()
            : const Center(child: CustomCircularProgressIndicator());
      },
      future: _initCategories(),
    );
  }

  SingleChildScrollView _innerBody() {
    return SingleChildScrollView(
      child: Column(
        children: List<CategoryName>.generate(
          _categories.length,
          (index) => CategoryName(
            iconData: _categories[index].iconData,
            title: _categories[index].name,
            lastCategory: false,
            page: SubcategoriesPage(
              iconData: _categories[index].iconData,
              title: _categories[index].name,
              subcategories: _categories[index].subcategories,
            ),
          ),
        ),
      ),
    );
  }
}
