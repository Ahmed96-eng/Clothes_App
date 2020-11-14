import 'package:Clothes_App/Models/product_model.dart';
import 'package:flutter/foundation.dart';

class Favorite extends ChangeNotifier {
  List<Product> products = [];
  // bool isFavorite = false;

  // changeFavorite(var value) {
  //   isFavorite = value;
  //   notifyListeners();
  // }

  toggelfavorite(String id) {
    return products.any((product) => product.id == id);
  }

  int get favoriteCount {
    int count = products.length;
    return count;
  }

  addProductToFavorite(Product product) {
    products.add(product);
    notifyListeners();
  }

  removeProductFromFavorite(Product product) {
    products.remove(product);
    notifyListeners();
  }
}
