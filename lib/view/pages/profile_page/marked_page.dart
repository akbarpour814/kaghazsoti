import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../../controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
import '../../../controller/database.dart';
import '../../../model/book.dart';
import '../../view_models/custom_circular_progress_indicator.dart';
import '/view/view_models/book_short_introduction.dart';
import '/view/view_models/player_bottom_navigation_bar.dart';

List<Book> markedBooks = [];

class MarkedPage extends StatefulWidget {
  const MarkedPage({
    Key? key
  }) : super(key: key);

  @override
  _MarkedPageState createState() => _MarkedPageState();
}

class _MarkedPageState extends State<MarkedPage> {

  @override
  void initState() {

    super.initState();
  }

  Future _initMarkedBooks() async {
    Response<dynamic> _customDio = await CustomDio.dio.get('dashboard/users/wish');

    if(_customDio.statusCode == 200) {
      markedBooks.clear();

      CustomResponse _customResponse = CustomResponse.fromJson(_customDio.data);

      for(Map<String, dynamic> book in _customResponse.data['data']) {
        _customDio = await CustomDio.dio.post('books/${book['slug']}');

        if(_customDio.statusCode == 200) {
          _customResponse = CustomResponse.fromJson(_customDio.data);

          markedBooks.add(Book.fromJson(_customResponse.data));
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
      bottomNavigationBar: const PlayerBottomNavigationBar(),
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
            : const Center(child: CustomCircularProgressIndicator());
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
