import 'package:Clothes_App/Models/product_model.dart';
import 'package:Clothes_App/Screens/Admin/dashBoard_screen.dart';
import 'package:Clothes_App/Screens/Admin/edit_screen.dart';
import 'package:Clothes_App/Services/DataServices.dart';
import 'package:Clothes_App/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllProductScreen extends StatefulWidget {
  static const route = 'edit_screen';

  @override
  _AllProductScreenState createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  final _dataServices = DataServices();
  Future<bool> _willPopScope() async {
    Navigator.of(context).pop();
    // Navigator.of(context).pushNamed(HomeScreen.route);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopScope,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.blueAccent.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, 1],
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: _dataServices.loadedProducts(),
                // ignore: missing_return
                builder: (context, snapshot) {
                  try {
                    if (snapshot.hasData) {
                      print("...................${snapshot.data}");
                      List<Product> products = [];
                      for (var doc in snapshot.data.docs) {
                        var data = doc.data();
                        products.add(Product(
                          id: doc.id ?? "",
                          name: data[kProductName] ?? "",
                          description: data[kProductDescription] ?? "",
                          image: data[kProductImage] ?? "",
                          price: data[kProductPrice] ?? 0.0,
                          stockQuantity: data[kProductStockQuantity] ?? 0,
                          quantity: 1,
                          category: data[kProductCategory] ?? "",
                        ));
                      }

                      return ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  height: 300,
                                  width: double.infinity,
                                  child: GridTile(
                                    header: Container(
                                        height: 60,
                                        color: Colors.blueGrey.withOpacity(0.5),
                                        child: Column(
                                          children: [
                                            Text(
                                              products[index].name,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "Category: " +
                                                  products[index].category,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        )),
                                    child: Container(
                                      child: Image.network(
                                        products[index].image,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    footer: Container(
                                      height: 40,
                                      color: Colors.blueGrey.withOpacity(0.5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          IconButton(
                                              icon: Icon(
                                                Icons.edit,
                                                size: 30,
                                                color: Colors.blueAccent,
                                              ),
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, EditScreen.route,
                                                    arguments: products[index]);
                                              }),
                                          IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                size: 30,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                _dataServices.deleteProduct(
                                                    products[index].id);
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  } catch (error) {
                    throw error;
                  }
                }),
          ],
        ),
      ),
    );
  }
}
