import 'package:get/get.dart';
import 'package:kaz_reader/pages/search/search_core.dart';
import 'package:kaz_reader/services/custom_http/custom_request.dart';
import 'package:kaz_reader/services/custom_http/custom_response.dart';
import 'package:kaz_reader/widgets/book_introduction/book_introduction_model.dart';

class SearchController extends GetxController
    with StateMixin<List<BookIntroductionModel>?> {
  late CustomResponse _response;
  late List<BookIntroductionModel> _state;
  late int _lastPage;
  late int _currentPage;

  SearchController() {
    _state = [];
    _lastPage = 1;
    _currentPage = 1;
  }

  @override
  void onInit() {
    fetch();

    super.onInit();
  }

  Future<void> fetch() async {
    try {
      if(_currentPage <= _lastPage) {
        _currentPage =1;
        change(null, status: RxStatus.loading());

        _response = await CustomRequest.post(
          path: SearchCore.config.apis.books,
          body: {
            'page': _currentPage.toString(),
          },
        );

        if (_response.statusCode == 200) {
          _lastPage = _response.body['data']['last_page'];
          _currentPage++;

          for (Map<String, dynamic> book in _response.body['data']['data']) {
            _state.add(
              BookIntroductionModel.fromJson(
                book,
              ),
            );
          }

          change(_state, status: RxStatus.success());
        } else {
          throw Exception();
        }
      }
    } catch (e) {
      e.printError();

      change(null, status: RxStatus.error());
    }
  }

  Future<void> load() async {
    change(state, status: RxStatus.loadingMore());

    print('111111111111111111');

    _response = await CustomRequest.post(
      path: SearchCore.config.apis.books,
      body: {
        'page': _currentPage.toString(),
      },
    );

    if (_response.statusCode == 200) {
      _lastPage = _response.body['data']['last_page'];
      _currentPage++;

      print('222222222');


      for (Map<String, dynamic> book in _response.body['data']['data']) {
        _state.add(
          BookIntroductionModel.fromJson(
            book,
          ),
        );
      }

      change(_state, status: RxStatus.success());
    } else {
      throw Exception();
    }
    try {

    } catch (e) {
      e.printError();

      change(null, status: RxStatus.error());
    }
  }
}
