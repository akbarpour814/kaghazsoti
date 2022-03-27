import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:takfood_seller/main.dart';

class Book {
  late int id;
  late String slug;
  late String name;
  late String category;
  late String subcategory;
  late String author;
  late String announcer;
  late double fileSize;
  late String publisherOfPrintedVersion;
  late int printedVersionYear;
  late String publisherOfAudioVersion;
  late int audioVersionYear;
  late int numberOfChapters;
  late int numberOfPages;
  late String duration;
  late String price;
  late bool marked;
  late int numberOfVotes;
  late int numberOfStars;
  late String aboutBook;
  late String partOfTheBook;
  late List<Review> reviews;
  late List<Part> parts;
  late String demo;
  late String bookCoverPath;
  late List<Book> otherBooksByThePublisher;
  late List<String> relatedBooksSlug;
  late List<Book> relatedBooks;

  Book.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> product = json['product'];

    id = product['id'];
    slug = product['slug'];
    name = product['title'];
    category = (product['category'])['name'];
    subcategory = (product['parent_category'])['name'];
    author = (product['author'])['name'];
    announcer = (product['narrator'])['name'];

    /////////////////////
    fileSize = 0;
    ////////////////////////

    publisherOfPrintedVersion = (product['publisher'])['name'];
    printedVersionYear = product['publish_year'] ?? 0;
    publisherOfAudioVersion = (product['audio_publisher'])['name'];
    audioVersionYear = product['audio_publish_year'] ?? 0;

    ///////////////////
    numberOfChapters = 0;
    numberOfPages = 0;
    duration = 'duration';
    //////////////////////


    price = product['price'];
    price = price == '0' ? 'رایگان' : '${price.seRagham()} تومان';

    //////////////////////////
    marked = markedBooksId.contains(product['id']);
    numberOfVotes = 0;
    numberOfStars = double.parse(product['rating']).toInt();
    aboutBook = 'aboutBook';
    partOfTheBook = 'partOfTheBook';
    /////////////////////////


    reviews = [];
    setReviews(json['reviews']);

    parts = [];
    demo = 'https://kaghazsoti.uage.ir/storage/books/${product['demo']}';
    bookCoverPath = 'https://kaghazsoti.uage.ir/storage/books/${product['image']}';

    /////////////////////////////////////////////////////////
    otherBooksByThePublisher = [];
    /////////////////////////////////////////////////////////

    relatedBooksSlug = [];
    setRelatedBooksSlug(json['similar']);
    relatedBooks = [];
  }


  void setReviews(List<dynamic> reviewsAsMap) {
    for(Map<String, dynamic> review in reviewsAsMap) {
      reviews.add(Review.fromJson(review));
    }
  }

  void setParts(List<dynamic> partsAsMap) {
    for(Map<String, dynamic> part in partsAsMap) {
      parts.add(Part.fromJson(part));
    }
  }

  void setRelatedBooksSlug(List<dynamic> relatedBooksSlugAsMap) {
    for(Map<String, dynamic> relatedBookSlug in relatedBooksSlugAsMap) {
      relatedBooksSlug.add(relatedBookSlug['slug']);
    }
  }
}

class Review {
  late int userName;
  late String review;
  late int numberOfStars;

  Review.fromJson(Map<String, dynamic> json) {
    userName = json['user_id'];
    review = json['review'];
    numberOfStars = json['rating'];
  }
}

class Part {
  late String name;
  late String time;
  late String path;

  Part.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    time = json['timer'];
    path = 'https://kaghazsoti.uage.ir/storage/book-files/${json['url']}';
  }
}
/*
class RelatedBook {
  late int id;
  late String slug;
  late String name;
  late String bookCoverPath;

  RelatedBook.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['title'];
    slug = json['slug'];
    bookCoverPath = 'https://kaghazsoti.uage.ir/storage/books/${json['image']}';
  }
}*/
