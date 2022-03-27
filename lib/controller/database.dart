import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:takfood_seller/model/purchase.dart';
import '/controller/custom_response.dart';
import '/controller/custom_dio.dart';
import '/model/HomePageCategoryData.dart';

import '/model/book.dart';
import '/model/category.dart';
import '/model/comment.dart';
import '/model/user.dart';

late Database database;
Map<String, String> headers =
{
  'Authorization' : 'Bearer 50|IEyWoGaAYripoLugW6mcaVN69n2gpjjNv0vNPYmA',
  'Accept': 'application/json',
  'client': 'api'};

class Database {
  late Response<dynamic> httpsResponse;
  late CustomResponse customResponse;

  late User user;
  List<Category> categories = [];
  List<HomePageCategoryData> homePageCategories = [];
  List<Book> books = [];

  bool downloadDone = false;

  Database() {
    _initUser();
    _initCategories();
    _initHomePageCategories();
    _initBooks();

    downloadDone = true;
  }

  Future<void> _initUser() async {
    httpsResponse = await CustomDio.dio.get('user', options: Options(headers: headers));

    customResponse = CustomResponse.fromJson(httpsResponse.data);

    user = User(
      token: '50|IEyWoGaAYripoLugW6mcaVN69n2gpjjNv0vNPYmA',
      firstAndLastName: "customResponse.data['name']",
      email: "customResponse.data['email']",
      phoneNumber: 0/*""customResponse.data['mobile']""*/,
      walletBalance: 0,
      cart: [],
      purchaseHistory: [],
      markedBooks: [],
      comments: [],
      library: [],
    );


    //initialize cart

    //initialize purchaseHistory

    //initialize markedBooks
    httpsResponse = await CustomDio.dio.get('dashboard/users/wish', options: Options(headers: headers));
    customResponse = CustomResponse.fromJson(httpsResponse.data);

    for(Map<String, dynamic> book in customResponse.data['data']) {
      Response<dynamic> httpsResponse = await CustomDio.dio.post('books/${book['slug']}');

      CustomResponse customResponse = CustomResponse.fromJson(httpsResponse.data);

      user.markedBooks.add(Book.fromJson(customResponse.data));
    }

    //initialize comments
    httpsResponse = await CustomDio.dio.get('dashboard/tickets', options: Options(headers: headers));
    customResponse = CustomResponse.fromJson(httpsResponse.data);

    for(Map<String, dynamic> comment in customResponse.data['data']) {
      user.comments.add(Comment.fromJson(comment));
    }


    //initialize library
    httpsResponse = await CustomDio.dio.get('dashboard/my_books', options: Options(headers: headers));

    Map<String, dynamic> data = httpsResponse.data;

    for(Map<String, dynamic> book in data['data']) {
      Response<dynamic> httpsResponse = await CustomDio.dio.post('books/${book['slug']}');

      CustomResponse customResponse = CustomResponse.fromJson(httpsResponse.data);

      user.library.add(Book.fromJson(customResponse.data));







      user.cart.add(Book.fromJson(customResponse.data));
    }

    user.purchaseHistory.add(Purchase(number: 1, type: 'type', prices: 200, date: DateTime.now(), status: PurchaseStatus.bought));
  }

  Future<void> _initCategories() async {
    httpsResponse = await CustomDio.dio.post('categories');

    customResponse = CustomResponse.fromJson(httpsResponse.data);

    Map<String, IconData> categoriesIcon = {
      'کتاب صوتی': Ionicons.musical_notes_outline,
      'نامه صوتی': Ionicons.mail_open_outline,
      'کتاب الکترونیکی': Ionicons.laptop_outline,
      'پادکست': Ionicons.volume_medium_outline,
      'کتاب کودک و نوجوان': Ionicons.happy_outline,
    };

    for(Map<String, dynamic> category in customResponse.data) {
      categories.add(Category.fromJson(categoriesIcon[category['name']] ?? Ionicons.albums_outline, category));
    }
  }

  Future<void> _initHomePageCategories() async {
    httpsResponse = await CustomDio.dio.post('home');

    customResponse = CustomResponse.fromJson(httpsResponse.data);

    HomePageCategoryData audioBooks = HomePageCategoryData.fromJson('کتاب های صوتی', (customResponse.data['books'])['کتاب-صوتی']);
    homePageCategories.add(audioBooks);

    HomePageCategoryData audioLetters = HomePageCategoryData.fromJson('نامه های صوتی', (customResponse.data['books'])['نامه-صوتی']);
    homePageCategories.add(audioLetters);

    HomePageCategoryData eBooks = HomePageCategoryData.fromJson('کتاب های الکترونیکی', (customResponse.data['books'])['کتاب-الکترونیکی']);
    homePageCategories.add(eBooks);

    HomePageCategoryData podcasts = HomePageCategoryData.fromJson('پادکست ها', (customResponse.data['books'])['پادکست']);
    homePageCategories.add(podcasts);

    HomePageCategoryData childrenAndAdolescentBooks = HomePageCategoryData.fromJson('کتاب های کودک و نوجوان', (customResponse.data['books'])['کتاب-کودک-و-نوجوان']);
    homePageCategories.add(childrenAndAdolescentBooks);
  }

  Future<void> _initBooks() async {
    httpsResponse = await CustomDio.dio.post('books');

    customResponse = CustomResponse.fromJson(httpsResponse.data);

    int lastPage = customResponse.data['last_page'] ?? 0;

    for(int i = 1; i <= lastPage; ++i) {
      httpsResponse = await CustomDio.dio.post('books', queryParameters: {'page': i},);

      customResponse = CustomResponse.fromJson(httpsResponse.data);

      for(Map<String, dynamic> book in customResponse.data['data']) {
        // print(book['slug']);
        Response<dynamic> httpsResponse = await CustomDio.dio.post('books/${book['slug']}');

        CustomResponse customResponse = CustomResponse.fromJson(httpsResponse.data);

        books.add(Book.fromJson(customResponse.data));
      }
    }
  }
}