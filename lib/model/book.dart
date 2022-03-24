import '/controller/database.dart';

class Book {
  late int id;
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
  late List<String> comments;
  late List<String> audioPaths;
  late String demo;
  late String bookCoverPath;
  late List<Book> otherBooksByThePublisher;
  late List<Book> relatedBooks;

  Book.fromJson({required Map<String, dynamic> book, required bool existingInUserMarkedBooks}) {
    Map<String, dynamic> product = book['product'];

    id = product['id'] ?? -1;
    name = product['title'] ?? 'name';
    category = (product['parent_category'])['name'] ?? 'category';

    subcategory = (product['category'])['name'] ?? 'category';;

    author = (product['author'])['name'] ?? 'author';
    announcer = (product['narrator'])['name'] ?? 'announcer';

    fileSize = 0;

    publisherOfPrintedVersion = (product['publisher'])['name'] ?? 'publisherOfPrintedVersion';
    printedVersionYear = product['publish_year'] ?? -1;
    publisherOfAudioVersion = (product['audio_publisher'])['name'] ?? 'publisherOfAudioVersion';
    audioVersionYear = product['audio_publish_year'] ?? -1;

    numberOfChapters = 0;
    numberOfPages = 0;
    duration = 'duration';

    price = product['price'] ?? 'price';

    marked = existingInUserMarkedBooks ? true : mark(id, database.user.markedBooks);
    numberOfVotes = 0;
    numberOfStars = double.parse(product['rating']).toInt();

    aboutBook = product['clear_description'] ?? 'aboutBook';

    partOfTheBook = 'partOfTheBook';
    comments = [];
    audioPaths = List<String>.generate(2, (index) => 'https://kaghazsoti.uage.ir/storage/books/${product['demo']}');
    demo = 'https://kaghazsoti.uage.ir/storage/books/${product['demo']}';
    bookCoverPath = 'https://kaghazsoti.uage.ir/storage/books/${product['image']}';
    otherBooksByThePublisher = [];

    List similar = book['similar'];
    relatedBooks = []/*List<Book>.generate(similar.length, (index) => Book.fromJson(book: similar[index], existingInUserMarkedBooks: false))*/;
  }

  bool mark(int id, List<Book> userMarkedBooks) {
    int index = userMarkedBooks.indexWhere((element) => element.id == id);

    return index >= 0 ? true : false;
  }
}
