class Product {
  String name;
  String category;
  String id;
  String description;
  String image;
  double price;
  int stockQuantity;
  int quantity;

  bool isFavorite;

  Product({
    this.id,
    this.name,
    this.category,
    this.description,
    this.image,
    this.price,
    this.stockQuantity,
    this.quantity = 1,
    this.isFavorite = false,
  });
}
