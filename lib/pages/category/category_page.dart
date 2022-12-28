//------/dart and flutter packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

//------/packages
import 'package:ionicons/ionicons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:kaz_reader/pages/category/category_controller.dart';
import 'package:kaz_reader/pages/category/subcategories/subcategories_controller.dart';
import 'package:kaz_reader/pages/category/subcategories/subcategories_page.dart';
import 'package:kaz_reader/pages/category/subcategory/subcategory_page.dart';

//------/controller
import 'subcategory/subcategory_model.dart';
import '/controller/custom_dio.dart';
import '/controller/custom_response.dart';
import '/controller/internet_connection.dart';
import '/controller/load_data_from_api.dart';

//------/model
import 'category_model.dart';

//------/view/pages/category_page

//------/view/view_models
import '../../widgets/category_name.dart';
import '../../widgets/custom_circular_progress_indicator.dart';
import '/widgets/no_internet_connection.dart';

//------/main
import '/main.dart';

class CategoryPage extends GetView<CategoryController> {
  const CategoryPage({Key? key}) : super(key: key);

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

  Widget _body() {
    return RefreshIndicator(
      onRefresh: () => controller.fetch(),
      child: controller.obx(
        (state) => _innerBody(),
        onError: (e) => const Text('onError'),
        onLoading: const Center(
          child: CustomCircularProgressIndicator(),
        ),
        onEmpty: const Text('onEmpty'),
      ),
    );
  }

  RefreshIndicator _innerBody() {
    return RefreshIndicator(
      onRefresh: controller.fetch,
      child: ListView(
        children: List<CategoryName>.generate(
          controller.state!.length,
          (index) => CategoryName(
            iconData: controller.state![index].icon,
            title: controller.state![index].title,
            lastCategory: false,
            page: SubcategoriesPage(
              controller: SubcategoriesController(
                subcategories: controller.state![index].subcategories,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
