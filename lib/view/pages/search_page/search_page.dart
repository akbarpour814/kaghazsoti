import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import '/model/book_introduction.dart';

import '../../../controller/custom_response.dart';
import '../../../controller/custom_dio.dart';
import '../../../main.dart';
import '../../view_models/custom_circular_progress_indicator.dart';
import '/model/book.dart';
import '/view/view_models/book_short_introduction.dart';
import '/view/view_models/player_bottom_navigation_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late  bool _internetConnectionChecker;
  late Response<dynamic> _customDio;
  late CustomResponse _customResponse;
  late bool _dataIsLoading;

  final TextEditingController _textEditingController = TextEditingController();
  late SearchTopic _searchTopic;
  late List<BookIntroduction> _booksTemp;
  late List<BookIntroduction> _books;

  late String _searchKey = '';
  late int _lastPage;
  late int _currentPage;

  @override
  void initState() {
    _dataIsLoading = true;
    _searchTopic = SearchTopic.name;

    _books = [];
    _booksTemp = [];

    _currentPage = 1;

    super.initState();
  }

  Future _initBooks(int currentPage) async {

    _customDio = await CustomDio.dio.post(
      'books',
      queryParameters: {'page': currentPage},
    );

    if (_customDio.statusCode == 200) {

      _customResponse = CustomResponse.fromJson(_customDio.data);

      _lastPage = _customResponse.data['last_page'];


      for (Map<String, dynamic> book in _customResponse.data['data']) {
        BookIntroduction _book = BookIntroduction.fromJson(book);

        _booksTemp.add(_book);
        _books.add(_book);
      }

      _dataIsLoading = false;
    }

    return _customDio;
  }

  @override
  Widget build(BuildContext context) {
    _refreshController = RefreshController(initialRefresh: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: PlayerBottomNavigationBar(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('جست و جو'),
      leading: const Icon(
        Ionicons.search_outline,
      ),
    );
  }

  Widget _body() {
    return _dataIsLoading
        ? FutureBuilder(
      builder:
          (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? _innerBody()
            : const Center(child: CustomCircularProgressIndicator());
      },
      future: _initBooks(_currentPage),
    )
        : _innerBody();
  }

  Widget _innerBody() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 5.0.w,
          ),
          child: Column(
            children: [
             /* _selectASearchTopic(),
              const Divider(
                height: 32.0,
              ),*/
              _searchTextField(),
            ],
          ),
        ),
        const Divider(
          height: 0.0,
        ),
        _searchResults(),
      ],
    );
  }

  Row _selectASearchTopic() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'جست و جو بر اساس: ${_searchTopic.title}',
        ),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return WillPopScope(
                  onWillPop: () async => true,
                  child: SimpleDialog(
                    children: List<InkWell>.generate(
                      SearchTopic.values.length,
                      (index) => InkWell(
                        onTap: () {
                          setState(() {
                            _searchTopic = SearchTopic.values[index];

                            _booksUpdate();

                            Navigator.of(context).pop();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(SearchTopic.values[index].title!),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: Icon(
            Ionicons.ellipsis_vertical_outline,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Padding _searchTextField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: TextField(
        readOnly: false,
        controller: _textEditingController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          helperText: '${_searchTopic.title} مورد نظر',
          hintText: 'لطفاً ${_searchTopic.title} مورد نظر را وارد کنید.',
          errorText: false ? '' : null,
          suffixIcon: const Icon(Ionicons.search_outline),
        ),
        onChanged: (String text) {
          _booksUpdate();
        },
      ),
    );
  }

  late RefreshController _refreshController;
  Expanded _searchResults() {
    if ((_booksTemp.isEmpty) && (_searchKey != '')) {
      return Expanded(
        child: Center(
          child: Text('کتابی با ${_searchTopic.title} «$_searchKey» یافت نشد.'),
        ),
      );
    } else {
      return Expanded(
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: MaterialClassicHeader(),
          footer: CustomFooter(
            builder: (BuildContext? context,LoadStatus? mode){
              Widget body ;
              if(mode==LoadStatus.idle){
                body =  Text("pull up load");
              }
              else if(mode==LoadStatus.loading){
                body =  Center(child: CustomCircularProgressIndicator());
              }
              else if(mode == LoadStatus.failed){
                body = Text("Load Failed!Click retry!");
              }
              else if(mode == LoadStatus.canLoading){
                body = Text("release to load more");
              }
              else{
                body = Text("No more Data");
              }
              return Container(
                height: 55.0,
                child: Center(child:body),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) => BookShortIntroduction(
              book: _booksTemp[index],
              searchTopic: _searchTopic,
              searchKey: _searchKey,
            ),
            itemCount: _books.length,
            itemExtent: 15.8.h,
          ),
        ),
      );
    }

    /*if ((_booksTemp.isEmpty) && (_searchKey != '')) {
      return Expanded(
        child: Center(
          child: Text('کتابی با ${_searchTopic.title} «$_searchKey» یافت نشد.'),
        ),
      );
    } else {
      return Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              _booksTemp.length,
              (index) => BookShortIntroduction(
                book: _booksTemp[index],
                searchTopic: _searchTopic,
                searchKey: _searchKey,
              ),
            ),
          ),
        ),
      );
    }*/
  }

  void _onRefresh() async{
    try {
      // monitor network fetch
      setState(() {
        _books.clear();
        _currentPage = 0;

        _initBooks(_currentPage);
      });
      await Future.delayed(Duration(milliseconds: 1000));
      // if failed,use refreshFailed()

      _refreshController.refreshCompleted();
    } catch(e) {
      _refreshController.refreshFailed();
    }
  }

  void _onLoading() async{
    try {
      if(_currentPage+1 <= _lastPage) {
        setState(() {
          _currentPage++;

          _initBooks(_currentPage);
        });
      }
      await Future.delayed(Duration(milliseconds: 1000));
      // if failed,use loadFailed(),if no data return,use LoadNodata()

      // if(mounted)
      //   setState(() {
      //
      //   });
      _refreshController.loadComplete();
    } catch(e) {
      _refreshController.loadFailed();
    }
  }

  void _booksUpdate() {
    setState(() {
      _searchKey = _textEditingController.text;

      if (_searchKey == '') {
        _booksTemp.clear();

        _booksTemp.addAll(_books);
      } else {
        switch (_searchTopic) {
          case SearchTopic.name:
            {
              _booksTemp.clear();

              _booksTemp.addAll(
                  _books.where((element) => element.name.contains(_searchKey)));

              break;
            }
          case SearchTopic.author:
            {
              _booksTemp.clear();

              _booksTemp.addAll(_books
                  .where((element) => element.author.contains(_searchKey)));

              break;
            }
          case SearchTopic.publisherOfPrintedVersion:
            {
              _booksTemp.clear();

              _booksTemp.addAll(_books.where((element) =>
                  element.publisherOfPrintedVersion.contains(_searchKey)));

              break;
            }
        }
      }
    });
  }
}

enum SearchTopic {
  name,
  author,
  publisherOfPrintedVersion,
}

extension SearchTopicExtension on SearchTopic {
  static const Map<SearchTopic, String> searchTopics = {
    SearchTopic.name: 'نام کتاب',
    SearchTopic.author: 'نام نویسنده',
    SearchTopic.publisherOfPrintedVersion: 'نام ناشر',
  };

  String? get title => searchTopics[this];
}
