import 'package:persian_number_utility/persian_number_utility.dart';

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

  BookIntroduction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    name = json['title'];
    author = (json['author'])['name'];
    publisherOfPrintedVersion = (json['publisher'])['name'];

    //////////////////////////
    duration = 'duration';
    //////////////////////


    price = json['price'];
    price = price == '0' ? 'رایگان' : '${price.seRagham()} تومان';

    /////////////////////////
    numberOfVotes = 0;
    ////////////////////////

    numberOfStars = double.parse(json['rating']).toInt();
    bookCoverPath = 'https://kaghazsoti.uage.ir/storage/books/${json['image']}';
  }
}