import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sizer/sizer.dart';
//import '/controller/database.dart';
import '../../view_models/no_internet_connection.dart';
import '/controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
import '../../../main.dart';
import '../../../model/category.dart';
import '../../view_models/custom_circular_progress_indicator.dart';
import '/view/pages/category_page/subcategories_page.dart';
import '/view/view_models/category_name.dart';
import '/view/view_models/player_bottom_navigation_bar.dart';
import '/main.dart';






class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late Response<dynamic> _customDio;
  late CustomResponse _customResponse;
  late List<Category> _categories;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    _categories = [];

    super.initState();

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future _initCategories() async {

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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CustomCircularProgressIndicator(message: 'لطفاً شکیبا باشید.'));
        } else {
          return (_connectionStatus == ConnectivityResult.none)
              ? const Center(child: NoInternetConnection(),)
              : _innerBody();
        }
      },
      future: _initCategories(),
    );
  }

  RefreshIndicator _innerBody() {
    return RefreshIndicator(
      onRefresh: () {
        return _initCategories(); },
      child: ListView.builder(itemBuilder: (BuildContext context, int index) { return CategoryName(
        iconData: _categories[index].iconData,
        title: _categories[index].name,
        lastCategory: false,
        page: SubcategoriesPage(
          iconData: _categories[index].iconData,
          title: _categories[index].name,
          subcategories: _categories[index].subcategories,
        ),
      ); }, itemCount: _categories.length,
      ),
    );
  }
}
