import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kaz_reader/pages/category/subcategories/subcategories_controller.dart';
import 'package:kaz_reader/pages/category/subcategory/subcategory_controller.dart';
import 'package:kaz_reader/pages/category/subcategory/subcategory_model.dart';
import 'package:kaz_reader/pages/category/subcategory/subcategory_page.dart';

import '../../../main.dart';
import '../../../widgets/category_name.dart';

class SubcategoriesPage extends StatelessWidget {
  final SubcategoriesController controller;

  const SubcategoriesPage({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _body(),
      bottomNavigationBar: playerBottomNavigationBar,
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Text(controller.state!.title),
      automaticallyImplyLeading: false,
      leading: Icon(controller.state!.icon),
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

  Widget _body() {
    return ListView.builder(
      itemCount: controller.state!.subcategories.length,
      itemBuilder: (BuildContext context, int index) {
        return CategoryName(
          iconData: null,
          title: controller.state!.subcategories[index].title,
          lastCategory: false,
          page: SubcategoryPage(
            controller: SubcategoryController(
              subcategory: controller.state!.subcategories[index],
            ),
          ),
        );
      },
    );
  }
}
