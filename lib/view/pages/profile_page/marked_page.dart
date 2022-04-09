import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
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
  const MarkedPage({
    Key? key
  }) : super(key: key);

  @override
  _MarkedPageState createState() => _MarkedPageState();
}

class _MarkedPageState extends State<MarkedPage> {
  late  bool _internetConnectionChecker;
  late Response<dynamic> _customDio;
  late CustomResponse _customResponse;

  Future _initMarkedBooks() async {
    _customDio = await CustomDio.dio.get('dashboard/users/wish');

    if(_customDio.statusCode == 200) {
      markedBooks.clear();

      _customResponse = CustomResponse.fromJson(_customDio.data);

      int lastPage = _customResponse.data['last_page'];

      for(Map<String, dynamic> bookIntroduction in _customResponse.data['data']) {
        markedBooks.add(BookIntroduction.fromJson(bookIntroduction));
      }

      for(int i = 2; i <= lastPage; ++i) {
        _customDio = await CustomDio.dio.get('dashboard/users/wish', queryParameters: {'page': i},);

        if(_customDio.statusCode == 200) {
          _customResponse = CustomResponse.fromJson(_customDio.data);

          for(Map<String, dynamic> bookIntroduction in _customResponse.data['data']) {
            markedBooks.add(BookIntroduction.fromJson(bookIntroduction));
          }
        }
      }
    }

    return _customDio;
  }

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

  FutureBuilder _body() {
    return FutureBuilder(
      builder:
          (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? _innerBody()
            : Center(child: CustomCircularProgressIndicator(message: 'لطفاً شکیبا باشید.'));
      },
      future: _initMarkedBooks(),
    );
  }

  Widget _innerBody() {
    if (markedBooks.isEmpty) {
      return const Center(
        child: Text('شما تا کنون کتابی را نشان نکرده اید.'),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: List.generate(
            markedBooks.length,
            (index) => BookShortIntroduction(
              book: markedBooks[index],
            ),
          ),
        ),
      );
    }
  }
}
