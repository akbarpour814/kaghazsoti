import 'package:dio/dio.dart';

import '/controller/custom_response.dart';
import '/controller/https.dart';
import 'book.dart';

class HomePageCategoryData {
  late String bookCategoryName;
  late List<String> banners = [];
  late List<Book> latestBooks = [];
  late List<Book> bestSellingBooks = [];

  HomePageCategoryData.fromJson(this.bookCategoryName, Map<String, dynamic> json) {
    banners.add(json['banner']);

    _initLatestBooks(json);

    _initBestSellingBooks(json);
  }

  void _initLatestBooks(Map<String, dynamic> json) async {
    for(Map<String, dynamic> book in json['new']) {
      Response<dynamic> httpsResponse = await Https.dio.post('books/${book['slug']}');

      CustomResponse customResponse = CustomResponse.fromJson(httpsResponse.data);

      latestBooks.add(Book.fromJson(book: customResponse.data, existingInUserMarkedBooks: false,));
    }
  }

  void _initBestSellingBooks(Map<String, dynamic> json) async {
    for(Map<String, dynamic> book in json['new']) {
      Response<dynamic> httpsResponse = await Https.dio.post('books/${book['slug']}');

      CustomResponse customResponse = CustomResponse.fromJson(httpsResponse.data);

      bestSellingBooks.add(Book.fromJson(book: customResponse.data, existingInUserMarkedBooks: false,));
    }
  }
}