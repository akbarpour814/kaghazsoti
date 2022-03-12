import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:takfood_seller/main.dart';
import 'package:takfood_seller/view/pages/4_profile_page/0_profile_page.dart';
import 'package:takfood_seller/view/view_models/custom_text_field.dart';
import 'package:takfood_seller/view/view_models/player_bottom_navigation_bar.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/database.dart';
import '../../../model/book.dart';
import '../../view_models/book_short_introduction.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    Key? key
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _textEditingController = TextEditingController();
  late SearchTopic _searchTopic;
  late List<Book> _books;

  late String _search = '';

  @override
  void initState() {
    _searchTopic = SearchTopic.name;

    _books = [];
    _books.addAll(database.books);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: const PlayerBottomNavigationBar(),
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
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 5.0.w,
          ),
          child: Column(
            children: [
              _selectASearchTopic(),
              const Divider(
                height: 32.0,
                thickness: 1.0,
              ),
              _searchTextField(),
            ],
          ),
        ),
        const Divider(
          height: 0.0,
          thickness: 1.0,
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
                          });

                          Navigator.of(context).pop();
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
        autofocus: true,
        readOnly: false,
        controller: _textEditingController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          helperText: '${_searchTopic.title} مورد نظر',
          errorText: false ? '' : null,
          suffixIcon: const Icon(
              Ionicons.search_outline
          ),
        ),
        onChanged: (String text) {
          setState(() {
            _search = _textEditingController.text;

            print(_search);

            if(_search == '/') {
              _books.clear();

              _books.addAll(database.books);
            } else {
              switch (_searchTopic) {
                case SearchTopic.name: {
                  print(database.books.length);
                  _books.clear();

                  //print(database.books.first.name.contains(_search));
                  _books.addAll(database.books.where((element)
                  {

                    return element.name.contains(_search);
                  }));

                  break;
                }
                case SearchTopic.author: {
                  _books.clear();

                  _books.addAll(database.books.where((element) => element.author.contains(_search)));

                  break;
                }
                case SearchTopic.publisherOfPrintedVersion: {
                  _books.clear();

                  _books.addAll(database.books.where((element) => element.publisherOfPrintedVersion.contains(_search)));

                  break;
                }
                case SearchTopic.category: {
                  _books.clear();

                  _books.addAll(database.books.where((element) => element.category.contains(_search)));

                  break;
                }
              }
            }

            print(_books.length);
            print(_searchTopic.title);

          });
        },
      ),
    );
  }

  Expanded _searchResults() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(
            _books.length,
            (index) => BookShortIntroduction(book: _books[index]),
          ),
        ),
      ),
    );
  }
}

enum SearchTopic {
  name,
  author,
  publisherOfPrintedVersion,
  category,
}

extension SearchTopicExtension on SearchTopic {
  static const Map<SearchTopic, String> searchTopics = {
    SearchTopic.name: 'نام کتاب',
    SearchTopic.author: 'نام نویسنده',
    SearchTopic.publisherOfPrintedVersion: 'نام ناشر',
    SearchTopic.category: 'نام دسته بندی',
  };

  String? get title => searchTopics[this];
}
