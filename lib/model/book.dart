import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:takfood_seller/main.dart';
import 'package:takfood_seller/model/book_introduction.dart';

class Book {
  late int id;
  late String slug;
  late String name;
  late String category;
  late String subcategory;
  late String author;
  late String announcer;
  late String fileSize;
  late String publisherOfPrintedVersion;
  late int printedVersionYear;
  late String publisherOfAudioVersion;
  late int audioVersionYear;
  late int numberOfChapters;
  late String numberOfPages;
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
  late List<BookIntroduction> otherBooksByThePublisher;
  late List<BookIntroduction> relatedBooks;

  Book.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> product = json['product'];

    id = product['id'] ?? -1;
    slug = product['slug'] ?? '';
    name = product['title'] ?? '';
    category = product['category'] == null ? '' : (product['category'])['name']  ?? '';
    subcategory = product['parent_category'] == null ? '' : (product['parent_category'])['name']  ?? '';
    author = product['author'] == null ? '' : (product['author'])['name']  ?? '';
    announcer = product['narrator'] == null ? '' : (product['narrator'])['name']  ?? '';

    /////////////////////
    fileSize = (product['download_volume'] ?? 0.0).toString();
    ////////////////////////

    publisherOfPrintedVersion = product['publisher'] == null ? '' : (product['publisher'])['name']  ?? '';
    printedVersionYear = product['publish_year'] ?? 0;
    publisherOfAudioVersion = product['audio_publisher'] == null ? '' : (product['audio_publisher'])['name']  ?? '';
    audioVersionYear = product['audio_publish_year'] ?? 0;

    ///////////////////
    numberOfChapters = product['orders_count'] ?? 0;
    numberOfPages = (product['page_count'] ?? 0).toString();
    duration = product['duration'] ?? '';
    //////////////////////


    price = product['price'] ?? '0';
    price = price == '0' ? 'رایگان' : '${price.seRagham()} تومان';

    //////////////////////////
    marked = markedBooksId.contains(product['id']);
    numberOfVotes = product['vote'] ?? 0;
    numberOfStars = double.parse(product['rating'] ?? 0.0).toInt();
    aboutBook = 'aboutBook';
    partOfTheBook = 'partOfTheBook';
    /////////////////////////


    reviews = [];
    setReviews(json['reviews'] ?? []);

    parts = [];
    demo = 'https://kaghazsoti.uage.ir/storage/books/${product['demo']}';
    bookCoverPath = product['image'] == null ? defaultBookCover : 'https://kaghazsoti.uage.ir/storage/books/${product['image']}';

    /////////////////////////////////////////////////////////
    otherBooksByThePublisher = [];
    /////////////////////////////////////////////////////////

    relatedBooks = [];
    setRelatedBooks(json['similar'] ?? []);

    //_toString();
  }

  void _toString() {
    print(id);
    print(slug);
    print(name);
    print(category);
    print(subcategory);
    print(author);
    print(announcer);
    print(fileSize);
    print(publisherOfPrintedVersion);
    print(printedVersionYear);
    print(publisherOfAudioVersion);
    print(audioVersionYear);
    print(numberOfChapters);
    print(numberOfPages);
    print( duration);
    print(price);
    print(marked);
    print(numberOfVotes);
    print(numberOfStars);
    print(aboutBook);
    print(partOfTheBook);
    print(reviews);
    print(parts);
    print(demo);
    print(bookCoverPath);
    print(otherBooksByThePublisher);
    print(relatedBooks);
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

  void setRelatedBooks(List<dynamic> relatedBooksAsMap) {
    for(Map<String, dynamic> bookIntroduction in relatedBooksAsMap) {
      relatedBooks.add(BookIntroduction.fromJson(bookIntroduction));
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
