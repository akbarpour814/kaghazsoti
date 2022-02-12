class Category {
  late int id;
  late String title;

  Category.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    title = parsedJson['title'];
  }
}
