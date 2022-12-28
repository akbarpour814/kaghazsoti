import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kaz_reader/pages/home/category/category_widget.dart';
import 'package:kaz_reader/pages/home/category/category_controller.dart';


import '../../widgets/custom_circular_progress_indicator.dart';
import '/main.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: body(),
      bottomNavigationBar: playerBottomNavigationBar,
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('خانه'),
      leading: const Icon(
        Ionicons.home_outline,
      ),
    );
  }

  Widget body() {
    return RefreshIndicator(
      onRefresh: () => controller.fetch(),
      child: controller.obx(
        (state) => innerBody(),
        onError: (e) => const Text('onError'),
        onLoading: const Center(
          child: CustomCircularProgressIndicator(),
        ),
        onEmpty: const Text('onEmpty'),
      ),
    );
  }

  RefreshIndicator innerBody() {
    return RefreshIndicator(
      onRefresh: () => controller.fetch(),
      child: ListView.builder(
        itemCount: controller.state!.length,
        itemBuilder: (BuildContext context, int index) {
          return CategoryWidget(
            controller: CategoryController(
              category: controller.state![index],
            ),
          );
        },
      ),
    );
  }
}
