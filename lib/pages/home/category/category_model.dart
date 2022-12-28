import '../../../widgets/book_introduction/book_introduction_model.dart';

class CategoryModel {
  late String title;
  late String banner;
  late List<BookIntroductionModel> latestBooks;
  late List<BookIntroductionModel> bestSellingBooks;

  CategoryModel.fromJson(this.title, Map<String, dynamic> json) {
    banner = json['banner'];

    latestBooks = [];
    for (Map<String, dynamic> bookIntroduction in json['new']) {
      latestBooks.add(BookIntroductionModel.fromJson(bookIntroduction));
    }

    bestSellingBooks = [];
    for (Map<String, dynamic> bookIntroduction in json['sell']) {
      bestSellingBooks.add(BookIntroductionModel.fromJson(bookIntroduction));
    }
  }
}
