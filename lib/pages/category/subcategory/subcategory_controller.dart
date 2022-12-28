import 'package:get/get.dart';

import 'package:kaz_reader/pages/category/subcategory/subcategory_model.dart';

import '../../../widgets/book_introduction/book_introduction_model.dart';
import '../category_config.dart';
import '/services/custom_http/custom_request.dart';
import '/services/custom_http/custom_response.dart';

class SubcategoryController extends GetxController with StateMixin<SubcategoryModel?> {
  late CustomResponse _response;
  late SubcategoryModel subcategory;
  late RxInt currentPage;

  SubcategoryController({required this.subcategory}) {
    currentPage = 1.obs;
  }

  @override
  void onInit() {
    print('111111111111111');
    fetch();
    print('222222222222222');

    super.onInit();
  }

  Future<void> fetch() async {
    try {
      change(null, status: RxStatus.loading());

      _response = await CustomRequest.post(
        path: '${CategoryConfig.config.apis.category}/${subcategory.slug}',
        body: {'page': currentPage.value.toString()},
      );

      print(_response.statusCode);
      print(_response.body);

      if (_response.statusCode == 200) {
        List<BookIntroductionModel> books = [];

        for (Map<String, dynamic> book in _response.body['data']['data']) {
          books.add(BookIntroductionModel.fromJson(book));
        }

        subcategory.books.addAll(books);

        change(subcategory, status: RxStatus.success());
      } else {
        throw Exception();
      }
    } catch (e) {
      e.printError();

      change(null, status: RxStatus.error());
    }
  }
}

mixin X {}
