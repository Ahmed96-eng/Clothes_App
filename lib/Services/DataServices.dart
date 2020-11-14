import 'package:Clothes_App/Models/http_exception.dart';
import 'package:Clothes_App/Models/product_model.dart';
import 'package:Clothes_App/Widgets/shared_widget.dart';
import 'package:Clothes_App/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataServices {
  final _productRef = FirebaseFirestore.instance.collection(kProductCollection);
  final _orderRef = FirebaseFirestore.instance.collection(kOrderCollection);
  final _usersRef = FirebaseFirestore.instance.collection(kUserCollection);
  // final _userDocID = FirebaseFirestore.instance.collection(kUserCollection).id;

  void addProduct(
      {String name,
      String description,
      String image,
      int stockQuantity,
      int quantity,
      double price,
      String category}) {
    _productRef.add({
      kProductName: name,
      kProductDescription: description,
      kProductImage: image,
      kProductPrice: price,
      kProductStockQuantity: stockQuantity,
      kProductCategory: category,
    }).catchError((error) {
      throw HttpException(error);
    });
    SharedWidget.showToastMsg('Add Success ', time: 3);
  }

  deleteProduct(id) {
    _productRef.doc(id).delete();
    SharedWidget.showToastMsg('Delete Success ', time: 3);
  }

  updateProduct({data, id}) {
    _productRef.doc(id).update(data);
    SharedWidget.showToastMsg('Update Success ', time: 3);
  }

  List<Product> getProductByCategory(
      String category, List<Product> allproducts) {
    List<Product> products = [];
    try {
      for (var product in allproducts) {
        if (product.category == category) {
          products.add(product);
        }
      }
    } on Error catch (ex) {
      print(ex);
    }

    return products;
  }

  Stream<QuerySnapshot> loadedProducts() {
    return _productRef.snapshots();
  }

  Stream<QuerySnapshot> loadedOrders() {
    return _orderRef.snapshots();
  }

  Stream<QuerySnapshot> loadedOrderDetails(id) {
    return _orderRef.doc(id).collection(kOrderDetailsCollection).snapshots();
  }

  Stream<QuerySnapshot> loadedUsers() {
    return _usersRef.snapshots();
  }

  Stream loadedSingleUser(id) {
    return _usersRef.doc(id).snapshots();
  }

  void addOrder(data, List<Product> products) {
    final docRef = _orderRef.doc();
    docRef.set(data);
    for (var product in products) {
      docRef.collection(kOrderDetailsCollection).doc().set({
        kProductImage: product.image,
        kProductName: product.name,
        kProductPrice: product.price.toString(),
        kProductQuantity: product.quantity.toString(),
        kProductCategory: product.category,
      });
    }
    SharedWidget.showToastMsg('Add Success ', time: 3);
  }

  // List<Product> get _products {
  //   _productRef.collection(kProductCollection).get();
  // }

  // List<String> categories() {
  //   List<String> _categories = [];
  //   for (int i = 0; i < _products.length; i++) {
  //     _categories.add(_products[i].category);
  //   }
  //   for (int i = 0; i < _categories.length; i++) {
  //     var category = _categories[i];
  //     for (int j = i + 1; j < _categories.length; j++) {
  //       if (_categories[j] == category) {
  //         _categories.removeAt(j);

  //         j--;
  //       }
  //     }
  //   }
  //   return _categories.toList();
  // }

  // List<Product> productCategory(String category) {
  //   List<Product> _products =
  //       _productRef.collection(kProductCollection).doc() as List<Product>;
  //   return _products.where((element) => element.category == category).toList();
  // }
}
