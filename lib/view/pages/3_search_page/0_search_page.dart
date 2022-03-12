import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:takfood_seller/main.dart';
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

  @override
  void initState() {
    _searchTopic = SearchTopic.name;
    _books = database.books;

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
            if(_textEditingController.text == '') {
              _books.clear();

              _books = database.books;
            } else {
              switch (_searchTopic) {
                case SearchTopic.name: {
                  _books.clear();

                  _books.addAll(database.books.where((element) => element.name.contains(_textEditingController.text)));

                  break;
                }
                case SearchTopic.author: {
                  _books.clear();

                  _books.addAll(database.books.where((element) => element.author.contains(_textEditingController.text)));

                  break;
                }
                case SearchTopic.publisherOfPrintedVersion: {
                  _books.clear();

                  _books.addAll(database.books.where((element) => element.publisherOfPrintedVersion.contains(_textEditingController.text)));

                  break;
                }
                case SearchTopic.category: {
                  _books.clear();

                  _books.addAll(database.books.where((element) => element.category.contains(_textEditingController.text)));

                  break;
                }
              }
            }

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
