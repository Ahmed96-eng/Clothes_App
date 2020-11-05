import 'package:Clothes_App/Models/product_model.dart';
import 'package:flutter/foundation.dart';

class Cart extends ChangeNotifier {
  List<Product> products = [];

  int get cartCount {
    int count = products.length;

    return count;
  }

  addProductToCart(Product product) {
    products.add(product);
    notifyListeners();
  }

  removeProductFromCart(Product product) {
    products.remove(product);
    notifyListeners();
  }

  double get totalPrice {
    double totalPrice = 0;
    for (var product in products) {
      totalPrice += (product.price * product.quantity);
    }
    return totalPrice;
  }
}
