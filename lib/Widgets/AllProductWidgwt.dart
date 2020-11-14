import 'package:Clothes_App/Models/product_model.dart';
import 'package:Clothes_App/Screens/productDetails.dart';
import 'package:Clothes_App/Services/DataServices.dart';
import 'package:Clothes_App/Widgets/cachedImageWidget.dart';
import 'package:Clothes_App/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AllProductWidget extends StatelessWidget {
  final _dataServices = DataServices();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _dataServices.loadedProducts(),
        // ignore: missing_return
        builder: (context, snapshot) {
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

            // products = _dataServices.getproductByCategory(category, allproducts)

            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 2 / 3),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, ProductDetails.route,
                            arguments: products[index]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: GridTile(
                            // header: Container(
                            //     height: 40,
                            //     color: Colors.blueGrey.withOpacity(0.5),
                            //     child: Center(
                            //     child: Text(
                            //   products[index].name,
                            //   style: TextStyle(
                            //       fontSize: 20,
                            //       fontWeight: FontWeight.bold,
                            //       color: Colors.white),
                            // ))),
                            child: CachedImageWidget(
                              imageUrl: products[index].image,
                            ),
                            footer: Container(
                              height: 60,
                              color: Colors.blueGrey.withOpacity(0.5),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      products[index].name,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      "Price: \$ ${products[index].price.toString()}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red[100]),
                                    )
                                  ],
                                ),
                              ),
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
        });
  }
}
