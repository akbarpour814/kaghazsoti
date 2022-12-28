//------/dart and flutter packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//------/packages
import 'package:ionicons/ionicons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

//------/controller
import '../../widgets/book_introduction/book_introduction_controller.dart';
import '/controller/custom_dio.dart';
import '/controller/custom_response.dart';
import '/controller/internet_connection.dart';
import '/controller/load_data_from_api.dart';

//------/model
import '../../widgets/book_introduction/book_introduction_model.dart';

//------/view/view_models
import '../../widgets/book_introduction/book_introduction_widget.dart';
import '../../widgets/custom_circular_progress_indicator.dart';
import '../../widgets/custom_smart_refresher.dart';
import '/widgets/no_internet_connection.dart';

//------/main
import '/main.dart';
import 'marked_controller.dart';

class MarkedPage extends GetView<MarkedController> {
  const MarkedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _body(context),
      bottomNavigationBar: playerBottomNavigationBar,
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text('نشان شده ها'),
      automaticallyImplyLeading: false,
      leading: const Icon(
        Ionicons.bookmark_outline,
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

  Widget _body(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.fetch(),
      child: controller.obx(
        (state) => _innerBody(context),
        onError: (e) => const Text('onError'),
        onLoading: const Center(
          child: CustomCircularProgressIndicator(),
        ),
        onEmpty: const Text('onEmpty'),
      ),
    );
  }

  Widget _innerBody(BuildContext context) {
    return ListView.builder(
      itemCount: controller.state!.length,
      itemBuilder: (BuildContext context, int index) {
        return BookIntroductionWidget(
          controller: BookIntroductionController(book: controller.state![index]),
        );
      },
    );
    /*   if (connectionStatus == ConnectivityResult.none) {
      setState(() {
        dataIsLoading = true;
      });

      return const Center(
        child: NoInternetConnection(),
      );
    } else {
      if (_markedBooks.isEmpty) {
        return const Center(
          child: Text('شما تا کنون کتابی را نشان نکرده اید.'),
        );
      } else {
        return CustomSmartRefresher(
          refreshController: refreshController,
          onRefresh: () => onRefresh(() => _initMarkedBooks()),
          onLoading: () => onLoading(() => _initMarkedBooks()),
          list: List<BookShortIntroduction>.generate(
            _markedBooks.length,
                (index) => BookShortIntroduction(
              book: _markedBooks[index],
            ),
          ),
          listType: 'کتاب',
          refresh: refresh,
          loading: loading,
          lastPage: lastPage,
          currentPage: currentPage,
          dataIsLoading: dataIsLoading,
        );
      }
    }*/
  }
}
