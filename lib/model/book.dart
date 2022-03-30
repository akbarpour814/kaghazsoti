import 'package:html/dom.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:takfood_seller/main.dart';
import 'package:takfood_seller/model/book_introduction.dart';
import 'package:takfood_seller/model/price_format.dart';
import 'package:html/parser.dart';


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
  late bool reviewed;
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

    price = PriceFormat.priceFormat(price: int.parse(product['price'] ?? '0'), isFree: true);

    //////////////////////////
    marked = markedBooksId.contains(product['id']);
    numberOfVotes = product['vote'] ?? 0;
    numberOfStars = double.parse(product['rating'] ?? 0.0).toInt();

    aboutBook = product['description'] ?? '';
    Document document = parse(aboutBook);

    aboutBook = parse(document.body!.text).documentElement!.text;
    aboutBook = aboutBook.replaceAll('  ', '');

    partOfTheBook = product['summery'] ?? '';
    document = parse(partOfTheBook);

    partOfTheBook = parse(document.body!.text).documentElement!.text;
    partOfTheBook = partOfTheBook.replaceAll('  ', '');
    /////////////////////////


    reviews = [];
    reviewed = false;
    setReviews(json['reviews'] ?? []);
    int myReviewIndex = reviews.indexWhere((element) => element.id == userId);

    if(myReviewIndex >= 0) {
      reviewed = true;

      Review myReview = reviews[myReviewIndex];

      reviews.removeAt(myReviewIndex);

      reviews.insert(0, myReview);
    }

    parts = [];
    demo = 'https://kaghazsoti.uage.ir/storage/books/${product['demo']}';
    bookCoverPath = product['image'] == null ? defaultBookCover : 'https://kaghazsoti.uage.ir/storage/books/${product['image']}';

    /////////////////////////////////////////////////////////
    otherBooksByThePublisher = [];
    /////////////////////////////////////////////////////////

    relatedBooks = [];
    setRelatedBooks(json['similar'] ?? []);
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
  late int id;
  late String name;
  late String review;
  late int numberOfStars;

  Review.fromJson(Map<String, dynamic> json) {
    id = (json['User'])['id'];
    name = (json['User'])['name'];
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
