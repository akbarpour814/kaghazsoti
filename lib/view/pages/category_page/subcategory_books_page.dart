import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '/model/category.dart';
import '../../../controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
import '../../../main.dart';
import '../../../model/book_introduction.dart';
import '../../view_models/custom_circular_progress_indicator.dart';
import '/model/book.dart';
import '/view/view_models/book_short_introduction.dart';
import '/view/view_models/player_bottom_navigation_bar.dart';


class SubcategoryBooksPage extends StatefulWidget {
  late Subcategory subcategory;
  SubcategoryBooksPage({Key? key, required this.subcategory,}) : super(key: key);

  @override
  _SubcategoryBooksPageState createState() => _SubcategoryBooksPageState();
}

class _SubcategoryBooksPageState extends State<SubcategoryBooksPage> {
  late  bool _internetConnectionChecker;
  late Response<dynamic> _customDio;
  late CustomResponse _customResponse;

  Future _initSubcategoryBooks() async {
    _customDio = await CustomDio.dio.post('categories/${widget.subcategory.slug}');

    if(_customDio.statusCode == 200) {
      widget.subcategory.books.clear();

      _customResponse = CustomResponse.fromJson(_customDio.data);

      int lastPage = _customResponse.data['last_page'];

      for(Map<String, dynamic> bookIntroduction in _customResponse.data['data']) {
        widget.subcategory.books.add(BookIntroduction.fromJson(bookIntroduction));
      }

      for(int i = 2; i <= lastPage; ++i) {
        _customDio = await CustomDio.dio.post('categories/${widget.subcategory.slug}', queryParameters: {'page': i},);

        if(_customDio.statusCode == 200) {
          _customResponse = CustomResponse.fromJson(_customDio.data);

          for(Map<String, dynamic> bookIntroduction in _customResponse.data['data']) {
            widget.subcategory.books.add(BookIntroduction.fromJson(bookIntroduction));
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
      title: Text(widget.subcategory.name),
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

  FutureBuilder _body() {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? _innerBody()
            : Center(child: CustomCircularProgressIndicator(message: 'لطفاً شکیبا باشید.'));
      },
      future: _initSubcategoryBooks(),
    );
  }

  SingleChildScrollView _innerBody() {
    return SingleChildScrollView(
      child: Column(
        children: List<BookShortIntroduction>.generate(
          widget.subcategory.books.length,
              (index) => BookShortIntroduction(book: widget.subcategory.books[index],),
        ),
      ),
    );
  }
}
