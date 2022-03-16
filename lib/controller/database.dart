import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '/controller/custom_response.dart';
import '/controller/https.dart';
import '/model/HomePageCategoryData.dart';

import '/model/book.dart';
import '/model/category.dart';
import '/model/comment.dart';
import '/model/user.dart';

late Database database;
Map<String, String> headers = {'Authorization' : 'Bearer 50|IEyWoGaAYripoLugW6mcaVN69n2gpjjNv0vNPYmA', 'Accept': 'application/json', 'client': 'api'};

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
    //_initCategories();
    _initHomePageCategories();
    //_initBooks();

    downloadDone = true;
  }

  void _initUser() async {
    user = User(
      token: '50|IEyWoGaAYripoLugW6mcaVN69n2gpjjNv0vNPYmA',
      firstAndLastName: 'firstAndLastName',
      nationalCode: 0,
      email: 'email',
      phoneNumber: 0,
      address: 'address',
      password: 'password',
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
    httpsResponse = await Https.dio.get('dashboard/users/wish', options: Options(headers: headers));
    customResponse = CustomResponse.fromJson(httpsResponse.data);

    for(Map<String, dynamic> book in customResponse.data['data']) {
      Response<dynamic> httpsResponse = await Https.dio.post('books/${book['slug']}');

      CustomResponse customResponse = CustomResponse.fromJson(httpsResponse.data);

      user.markedBooks.add(Book.fromJson(book: customResponse.data, existingInUserMarkedBooks: true,));
    }

    //initialize comments
    httpsResponse = await Https.dio.get('dashboard/tickets', options: Options(headers: headers));
    customResponse = CustomResponse.fromJson(httpsResponse.data);

    for(Map<String, dynamic> comment in customResponse.data['data']) {
      user.comments.add(Comment.fromJson(comment));
    }


    //initialize library
    httpsResponse = await Https.dio.get('dashboard/my_books', options: Options(headers: headers));

    Map<String, dynamic> data = httpsResponse.data;

    for(Map<String, dynamic> book in data['data']) {
      Response<dynamic> httpsResponse = await Https.dio.post('books/${book['slug']}');

      CustomResponse customResponse = CustomResponse.fromJson(httpsResponse.data);

      user.library.add(Book.fromJson(book: customResponse.data, existingInUserMarkedBooks: false,));
    }
  }

  void _initCategories() async {
    httpsResponse = await Https.dio.post('categories');

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

  void _initHomePageCategories() async {
    httpsResponse = await Https.dio.post('home');

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

  void _initBooks() async {
    httpsResponse = await Https.dio.post('books');

    customResponse = CustomResponse.fromJson(httpsResponse.data);

    for(Map<String, dynamic> book in customResponse.data['data']) {
      Response<dynamic> httpsResponse = await Https.dio.post('books/${book['slug']}');

      CustomResponse customResponse = CustomResponse.fromJson(httpsResponse.data);

      books.add(Book.fromJson(book: customResponse.data, existingInUserMarkedBooks: false,));
    }
  }

  bool mark(int id) {
    int index = user.markedBooks.indexWhere((element) => element.id == id);

    return index >= 0 ? true : false;
  }


}