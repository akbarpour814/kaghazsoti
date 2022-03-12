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

  Book.fromJson(Map<String, dynamic> book) {
    Map<String, dynamic> product = book['product'];

    id = product['id'] ?? -1;
    name = product['title'] ?? 'name';
    category = (product['category'])['name'] ?? 'category';

    subcategory = 'subcategory';

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

    marked = true;
    numberOfVotes = 0;
    numberOfStars = 0;

    aboutBook = product['clear_description'] ?? 'aboutBook';

    partOfTheBook = 'partOfTheBook';
    comments = [];
    audioPaths = [];
    demo = 'https://kaghazsoti.uage.ir/storage/books/${product['demo']}';
    bookCoverPath = 'https://kaghazsoti.uage.ir/storage/books/${product['image']}';
    otherBooksByThePublisher = [];

    //test shavad
    //List similar = customResponse.data['similar'];
    relatedBooks = []/*List<Book>.generate(similar.length, (index) => Book(slug: similar[index]['slug']))*/;
  }
}
