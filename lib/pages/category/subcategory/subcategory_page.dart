//------/dart and flutter packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//------/packages
import 'package:ionicons/ionicons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:kaz_reader/pages/category/subcategory/subcategory_controller.dart';
import 'package:kaz_reader/pages/category/subcategory/subcategory_model.dart';

//------/controller
import '../../../widgets/book_introduction/book_introduction_controller.dart';
import '/controller/custom_dio.dart';
import '/controller/custom_response.dart';
import '/controller/internet_connection.dart';
import '/controller/load_data_from_api.dart';

//------/model
import '../../../widgets/book_introduction/book_introduction_model.dart';
import '../category_model.dart';

//------/view/view_models
import '../../../widgets/book_introduction/book_introduction_widget.dart';
import '../../../widgets/custom_circular_progress_indicator.dart';
import '../../../widgets/custom_smart_refresher.dart';
import '/widgets/no_internet_connection.dart';

//------/main
import '/main.dart';

class SubcategoryPage extends StatelessWidget {
  final SubcategoryController controller;

  SubcategoryPage({
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
      title: Text(controller.subcategory.title),
      centerTitle: false,
      automaticallyImplyLeading: false,
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

  Widget _innerBody() {
    return Text('_innerBody');
    // if (connectionStatus == ConnectivityResult.none) {
    //   setState(() {
    //     dataIsLoading = true;
    //   });
    //
    //   return const Center(
    //     child: NoInternetConnection(),
    //   );
    // } else {
    //   if (_subcategoryBooks.isEmpty) {
    //     return const Center(
    //       child: Text('کتابی یافت نشد.'),
    //     );
    //   } else {
    //     return CustomSmartRefresher(
    //       refreshController: refreshController,
    //       onRefresh: () => onRefresh(() => _initSubcategoryBooks()),
    //       onLoading: () => onLoading(() => _initSubcategoryBooks()),
    //       list: List<BookIntroductionWidget>.generate(
    //         _subcategoryBooks.length,
    //         (index) => BookIntroductionWidget(
    //           controller:
    //               BookIntroductionController(book: _subcategoryBooks[index]),
    //         ),
    //       ),
    //       listType: 'کتاب',
    //       refresh: refresh,
    //       loading: loading,
    //       lastPage: lastPage,
    //       currentPage: currentPage,
    //       dataIsLoading: dataIsLoading,
    //     );
    //   }
    // }
  }
}
