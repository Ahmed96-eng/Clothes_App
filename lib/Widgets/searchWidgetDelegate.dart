import 'package:Clothes_App/Models/product_model.dart';
import 'package:Clothes_App/Screens/productDetails.dart';
import 'package:Clothes_App/Services/DataServices.dart';
import 'package:Clothes_App/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchWidgetDelegate extends SearchDelegate<String> {
  final _dataServices = DataServices();

  @override
  List<Widget> buildActions(BuildContext context) {
    // clear the data
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // back to last screen
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // show the products
    return StreamBuilder<QuerySnapshot>(
      stream: _dataServices.loadedProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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

          var searchData = query.isEmpty
              ? products
              : products
                  .where((element) => element.name.contains(query))
                  .toList();
          return ListView.builder(
            itemCount: searchData.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Container(
                    width: 80,
                    height: 100,
                    child: Image.network(
                      searchData[index].image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  trailing:
                      Text("x ${searchData[index].stockQuantity.toString()}"),
                  title: Text(searchData[index].name),
                  subtitle: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text("Price: ${searchData[index].price.toString()}"),
                        SizedBox(height: 5),
                        Text(
                          "Description: ${searchData[index].description}",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, ProductDetails.route,
                        arguments: searchData[index]);
                  },
                ),
              );
            },
          );
        } else {
          return Center(child: Text("Loading Data"));
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show the suggest products
    return StreamBuilder<QuerySnapshot>(
      stream: _dataServices.loadedProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Product> products = [];
          for (var doc in snapshot.data.docs) {
            var data = doc.data();
            products.add(Product(
              id: doc.id ?? "",
              name: data[kProductName] ?? "",
              image: data[kProductImage] ?? "",
              price: data[kProductPrice] ?? 0.0,
            ));
          }
          var searchData = query.isEmpty
              ? products
              : products
                  .where((element) => element.name.contains(query))
                  .toList();
          return ListView.builder(
            itemCount: searchData.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Container(
                    width: 80,
                    height: 100,
                    child: Image.network(
                      searchData[index].image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(searchData[index].name),
                  onTap: () {
                    query = searchData[index].name;
                    showResults(context);
                  },
                ),
              );
            },
          );
        } else {
          return Center(child: Text("Loading Data"));
        }
      },
    );
  }
}
