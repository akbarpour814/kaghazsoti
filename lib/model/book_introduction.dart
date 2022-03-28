import 'package:persian_number_utility/persian_number_utility.dart';

import '../main.dart';

class BookIntroduction {
  late int id;
  late String slug;
  late String name;
  late String author;
  late String publisherOfPrintedVersion;
  late String duration;
  late String price;
  late int numberOfVotes;
  late int numberOfStars;
  late String bookCoverPath;


  BookIntroduction({
    required this.id,
    required this.slug,
    required this.name,
    required this.author,
    required this.publisherOfPrintedVersion,
    required this.duration,
    required this.price,
    required this.numberOfVotes,
    required this.numberOfStars,
    required this.bookCoverPath,
  });

  BookIntroduction.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? -1;
    slug = json['slug'] ?? '';
    name = json['title'] ?? '';
    author = json['author'] == null ? '' : (json['author'])['name']   ?? '';
    publisherOfPrintedVersion = json['publisher'] == null ? '' : (json['publisher'])['name']   ?? '';

    //////////////////////////
    duration = json['duration'] ?? '';
    //////////////////////


    price = json['price'] ?? '0';
    price = price == '0' ? 'رایگان' : '${price.seRagham()} تومان';

    /////////////////////////
    numberOfVotes = json['vote'] ?? 0;
    ////////////////////////

    numberOfStars = double.parse(json['rating'] ?? 0.0).toInt();
    bookCoverPath = json['image'] == null ? defaultBookCover : 'https://kaghazsoti.uage.ir/storage/books/${json['image']}';
  }
}