import 'package:get/get.dart';
import 'package:kaz_reader/pages/home/category/category_model.dart';

import '../../services/custom_http/custom_request.dart';
import '../../services/custom_http/custom_response.dart';
import '../about_us/about_us_config.dart';
import 'home_config.dart';
import 'home_enum.dart';

class HomeController extends GetxController
    with StateMixin<List<CategoryModel>?> {
  late CustomResponse _response;

  @override
  void onInit() {
    fetch();

    super.onInit();
  }

  Future<void> fetch() async {
    try {
      change(null, status: RxStatus.loading());

      _response = await CustomRequest.post(
        path: HomeConfig.config.apis.home,
      );

      if (_response.statusCode == 200) {
        List<CategoryModel> state = [];

        for (HomeEnum value in HomeEnum.values) {
          state.add(
            CategoryModel.fromJson(
              value.title,
              (_response.body['data']['books'])[value.slug],
            ),
          );
        }

        change(state, status: RxStatus.success());
      } else {
        throw Exception();
      }
    } catch (e) {
      e.printError();

      change(null, status: RxStatus.error());
    }
  }
}
