//------/dart and flutter packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaz_reader/pages/faq/faq_controller.dart';

//------/packages
export 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

//------/controller
import '/controller/custom_dio.dart';
import '/controller/custom_response.dart';
import '/controller/internet_connection.dart';
import '/controller/load_data_from_api.dart';

//------/model
import '/model/text_format.dart';

//------/view/view_models
import '../../widgets/custom_circular_progress_indicator.dart';
import '/widgets/display_of_details.dart';
import '/widgets/no_internet_connection.dart';

//------/main
import '/main.dart';
import 'faq_model.dart';

class FAQPage extends GetView<FAQController> {
  const FAQPage({Key? key}) : super(key: key);

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
      title: const Text('سوالات متداول کاغذ صوتی'),
      automaticallyImplyLeading: false,
      leading: const Icon(
        Ionicons.help,
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
    return Obx(() => ListView(
      children: List<Card>.generate(
        controller.state!.length,
            (index) => _questionAndAnswer(context,
          controller.state![index],
          index,
        ),
      ),
    ),);
  }

  Card _questionAndAnswer(
  BuildContext context, FAQModel frequentlyAskedQuestion, int index) {
    return Card(
      color: Colors.transparent,
      elevation: 0.0,
      shape: Theme.of(context).cardTheme.shape,
      child: ListTile(
        title: Text(frequentlyAskedQuestion.question),
        subtitle: Visibility(
          visible: index == controller.currentIndex.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                height: 4.0.h,
              ),
              Text(
                frequentlyAskedQuestion.answer,
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 2.0.h,
              ),
            ],
          ),
        ),
        trailing: InkWell(
          onTap: () => controller.show(index),
          child: Icon(
            index == controller.currentIndex.value
                ? Ionicons.chevron_up_outline
                : Ionicons.chevron_down_outline,
          ),
        ),
      ),
    );
  }

}
