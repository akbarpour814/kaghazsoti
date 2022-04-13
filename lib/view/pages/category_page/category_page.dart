import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';

import '../../view_models/no_internet_connection.dart';
import '/controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
import '../../../main.dart';
import '../../../model/category.dart';
import '../../view_models/custom_circular_progress_indicator.dart';
import '/view/pages/category_page/subcategories_page.dart';
import '/view/view_models/category_name.dart';
import '/main.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late ConnectivityResult _connectionStatus;
  late Connectivity _connectivity;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  late Response<dynamic> _customDio;
  late CustomResponse _customResponse;

  late List<Category> _categories;

  @override
  void initState() {
    super.initState();
    _connectionStatus = ConnectivityResult.none;
    _connectivity = Connectivity();
    _initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    _categories = [];
  }

  Future<void> _initConnectivity() async {
    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
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

    if (_customDio.statusCode == 200) {
      _categories.clear();

      _customResponse = CustomResponse.fromJson(_customDio.data);

      Map<String, IconData> categoriesIcon = {
        'کتاب صوتی': Ionicons.musical_notes_outline,
        'نامه صوتی': Ionicons.mail_open_outline,
        'کتاب الکترونیکی': Ionicons.laptop_outline,
        'پادکست': Ionicons.volume_medium_outline,
        'کتاب کودک و نوجوان': Ionicons.happy_outline,
      };

      for (Map<String, dynamic> category in _customResponse.data) {
        _categories.add(
          Category.fromJson(
            categoriesIcon[category['name']] ?? Ionicons.albums_outline,
            category,
          ),
        );
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
      future: _initCategories(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CustomCircularProgressIndicator(
              message: 'لطفاً شکیبا باشید.',
            ),
          );
        } else {
          if (_connectionStatus == ConnectivityResult.none) {
            return const Center(
              child: NoInternetConnection(),
            );
          } else {
            return _innerBody();
          }
        }
      },
    );
  }

  RefreshIndicator _innerBody() {
    return RefreshIndicator(
      onRefresh: _initCategories,
      child: ListView(
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
