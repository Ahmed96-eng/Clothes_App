import 'package:Clothes_App/Models/product_model.dart';
import 'package:Clothes_App/Services/DataServices.dart';
import 'package:Clothes_App/Widgets/cachedImageWidget.dart';
import 'package:Clothes_App/Widgets/shared_widget.dart';
import 'package:Clothes_App/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  static const route = 'order_details';

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final _dataServices = DataServices();
  Future<bool> _willPopScope() async {
    Navigator.of(context).pop();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _willPopScope,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Orders Details',
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _dataServices.loadedOrderDetails(id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Product> products = [];

              for (var doc in snapshot.data.docs) {
                var data = doc.data();
                products.add(Product(
                  image: data[kProductImage],
                  category: data[kProductCategory],
                  name: data[kProductName],
                  price: double.parse(data[kProductPrice]),
                  quantity: int.parse(data[kProductQuantity]),
                ));
              }
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: SharedWidget.dialogDecoration(),
                    child: Row(
                      children: [
                        Container(
                            width: screenWidth * 0.25,
                            height: screenHeight * 0.2,
                            child: CachedImageWidget(
                                imageUrl: products[index].image)),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("$kProductName: ${products[index].name}"),
                              SizedBox(height: screenHeight * 0.015),
                              Text("$kProductPrice: ${products[index].price}"),
                              SizedBox(height: screenHeight * 0.015),
                              Text(
                                  "$kProductCategory: ${products[index].category}"),
                              SizedBox(height: screenHeight * 0.015),
                              Text(
                                  "$kProductQuantity: ${products[index].quantity}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
