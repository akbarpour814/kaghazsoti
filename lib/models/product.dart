
class Product{
  late int id;
  // late int authorId;
  late String title;
  late String description;
  late String price;
  late String image;
  late DateTime? createdAt;
  late DateTime? updatedAt;

  Product.fromJson(Map<String , dynamic> parsedJson){
    id = parsedJson['id'];
    // authorId = parsedJson['author_id'];
    title = parsedJson['title'];
    description = parsedJson['clear_description'];
    price = parsedJson['price'];
    image = parsedJson['full_image'];
    createdAt = parsedJson['created_at'];
    updatedAt = parsedJson['updated_at'];
  }
}