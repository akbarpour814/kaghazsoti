import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import '../../../controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
import '../../../main.dart';
import '../../../model/book.dart';
import '../../../model/book_introduction.dart';
import '../../view_models/custom_circular_progress_indicator.dart';
import '/view/view_models/book_short_introduction.dart';
import '/view/view_models/player_bottom_navigation_bar.dart';

List<BookIntroduction> markedBooks = [];

class MarkedPage extends StatefulWidget {
  const MarkedPage({Key? key}) : super(key: key);

  @override
  _MarkedPageState createState() => _MarkedPageState();
}

class _MarkedPageState extends State<MarkedPage> {
  late bool _internetConnectionChecker;
  late Response<dynamic> _customDio;
  late CustomResponse _customResponse;
  late bool _dataIsLoading;
  late int _lastPage;
  late int _currentPage;

  @override
  void initState() {
    _dataIsLoading = true;
    _currentPage = 1;

    super.initState();
  }

  Future _initMarkedBooks() async {
    _customDio = await CustomDio.dio.get('dashboard/users/wish', queryParameters: {'page': _currentPage}, options: Options(headers: {'Authorization': 'Bearer 106|aF8aWGhal8EDHk9sBBdW2tMo8DcaV13vJKfqG5Lj'}));


    if (_customDio.statusCode == 200) {
      _customResponse = CustomResponse.fromJson(_customDio.data);

      _lastPage = _customResponse.data['last_page'];

      if (_currentPage == 1) {
        markedBooks.clear();
      }

      for (Map<String, dynamic> bookIntroduction in _customResponse.data['data']) {
        markedBooks.add(BookIntroduction.fromJson(bookIntroduction));
        // markedBooks.add(BookIntroduction.fromJson(bookIntroduction));
        // markedBooks.add(BookIntroduction.fromJson(bookIntroduction));
        // markedBooks.add(BookIntroduction.fromJson(bookIntroduction));
        // markedBooks.add(BookIntroduction.fromJson(bookIntroduction));
        // markedBooks.add(BookIntroduction.fromJson(bookIntroduction));
        // markedBooks.add(BookIntroduction.fromJson(bookIntroduction));
        // markedBooks.add(BookIntroduction.fromJson(bookIntroduction));
        // markedBooks.add(BookIntroduction.fromJson(bookIntroduction));
        // markedBooks.add(BookIntroduction.fromJson(bookIntroduction));
        // markedBooks.add(BookIntroduction.fromJson(bookIntroduction));
        // markedBooks.add(BookIntroduction.fromJson(bookIntroduction));
        // markedBooks.add(BookIntroduction.fromJson(bookIntroduction));
        // markedBooks.add(BookIntroduction.fromJson(bookIntroduction));
        // markedBooks.add(BookIntroduction.fromJson(bookIntroduction));
        // markedBooks.add(BookIntroduction.fromJson(bookIntroduction));
        // markedBooks.add(BookIntroduction.fromJson(bookIntroduction));
        // markedBooks.add(BookIntroduction.fromJson(bookIntroduction));
        // markedBooks.add(BookIntroduction.fromJson(bookIntroduction));
        // markedBooks.add(BookIntroduction.fromJson(bookIntroduction));
        // markedBooks.add(BookIntroduction.fromJson(bookIntroduction));
      }

      setState(() {
        _dataIsLoading = false;
        refresh = false;
        loading = false;
      });
    }

    return _customDio;
  }



  @override
  Widget build(BuildContext context) {
    _refreshController = RefreshController(initialRefresh: false);

    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: playerBottomNavigationBar,
    );
  }

  AppBar _appBar() {
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

  Widget _body() {
    return _dataIsLoading ? FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? _innerBody()
            : Center(
            child: CustomCircularProgressIndicator(
                message: 'لطفاً شکیبا باشید.'));
      },
      future: _initMarkedBooks(),
    ) : _innerBody();
  }

  Widget _innerBody() {
    if (markedBooks.isEmpty) {
      return const Center(
        child: Text('شما تا کنون کتابی را نشان نکرده اید.'),
      );
    } else {
      return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const MaterialClassicHeader(),
        footer: CustomFooter(
          builder: (BuildContext? context, LoadStatus? mode) {
            Widget bar;

            if ((mode == LoadStatus.idle) && (_currentPage == _lastPage)) {
              bar = Text(
                'کتاب دیگری یافت نشد.',
                style: TextStyle(
                  color: Theme.of(context!).primaryColor,
                ),
              );
            } else if (mode == LoadStatus.idle) {
              bar = Text('لطفاً صفحه را بالا بکشید.',
                  style: TextStyle(color: Theme.of(context!).primaryColor));
            } else if (mode == LoadStatus.loading) {
              bar = CustomCircularProgressIndicator(
                  message: 'لطفاً شکیبا باشید.');
            } else if (mode == LoadStatus.failed) {
              bar = CustomCircularProgressIndicator(
                  message: 'لطفاً دوباره امتحان کنید.');
            } else if (mode == LoadStatus.canLoading) {
              bar = CustomCircularProgressIndicator(
                  message: 'لطفاً صفحه را پایین بکشید.');
            } else {
              bar = Text(
                'کتاب دیگری یافت نشد.',
                style: TextStyle(color: Theme.of(context!).primaryColor),
              );
            }

            return SizedBox(
              height: 55.0,
              child: Center(child: bar),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: loading ? null : _onRefresh,
        onLoading: refresh ? null : _onLoading,
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
              BookShortIntroduction(
                book: markedBooks[index],
              ),
          itemCount: markedBooks.length,
          itemExtent: 15.8.h,
        ),
      );
    }
  }

  late RefreshController _refreshController;


  bool refresh = false;
  bool loading = false;

  void _onRefresh() async {
    try {
      setState(() {
        // refresh = loading ? false : true;
        // if (refresh) {
        //
        //   _currentPage = 1;
        //
        //    _initMarkedBooks();
        // }
      });

      await Future.delayed(const Duration(milliseconds: 1000));

      _refreshController.refreshCompleted();
    } catch (e) {

      _refreshController.refreshFailed();
    }
  }

  void _onLoading() async {
    try {
      if (_currentPage < _lastPage) {
        setState(() {
          loading = refresh ? false : true;

          if (loading) {
            _currentPage++;

            _initMarkedBooks();
          }
        });
      }

      await Future.delayed(const Duration(milliseconds: 1000));

      _refreshController.loadComplete();
    } catch (e) {
      _refreshController.loadFailed();
    }
  }
}
