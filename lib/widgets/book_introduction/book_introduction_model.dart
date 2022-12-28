//------/main
import '/main.dart';

class BookIntroductionModel {
  late int id;
  late int type;
  late String slug;
  late String name;
  late String author;
  late String publisherOfPrintedVersion;
  late String duration;
  late String price;
  late int votes;
  late int stars;
  late String bookCoverPath;

  BookIntroductionModel({
    required this.id,
    required this.type,
    required this.slug,
    required this.name,
    required this.author,
    required this.publisherOfPrintedVersion,
    required this.duration,
    required this.price,
    required this.votes,
    required this.stars,
    required this.bookCoverPath,
  });

  BookIntroductionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? -1;
    // print(json['id']);
    // print("json['id']");

    type = json['type'] ?? -1;

    slug = json['slug'] ?? '';
    // print(json['slug']);
    // print("json['slug']");

    name = json['title'] ?? '';
    // print(json['title']);
    // print("json['title']");

    author = json['author'] == null ? '' : (json['author'])['name'] ?? '';
    // print(json['author']);
    // print("json['author']");

    publisherOfPrintedVersion =
        json['publisher'] == null ? '' : (json['publisher'])['name'] ?? '';
    // print(json['publisher']);
    // print("json['publisher']");

    //////////////////////////
    duration = json['duration'] ?? '';
    // print(json['duration']);
    // print("json['duration']");

    //////////////////////

    price = json['cast_price'];
    //price = PriceFormat.priceFormat(price: int.parse(json['price'] ?? '0'), isFree: true);
    // print(json['price']);
    // print("json['price']");

    /////////////////////////
    votes = json['vote'] ?? 0;
    // print(json['vote']);
    // print("json['vote']");
    ////////////////////////

    stars = double.parse(json['rating'] ?? '0.0').toInt();
    // print(json['rating']);
    // print("json['rating']");

    bookCoverPath = json['image'] == null
        ? defaultBookCover
        : '${storage}books/${json['image']}';
    // print(json['image']);
    // print("json['image']");
  }
}
