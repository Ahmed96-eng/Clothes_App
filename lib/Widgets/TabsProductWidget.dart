import 'package:Clothes_App/Models/product_model.dart';
import 'package:Clothes_App/Services/DataServices.dart';
import 'package:flutter/material.dart';

class TabsProductWidget extends StatelessWidget {
  String category;
  String searchValue;
  List<Product> allproducts;
  TabsProductWidget({this.category, this.allproducts, this.searchValue});

  final _dataServices = DataServices();
  @override
  Widget build(BuildContext context) {
    List<Product> products = [];
    products = _dataServices.getProductByCategory(category, allproducts);
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 2 / 3),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return products[index].name.toLowerCase().trim().contains(searchValue)
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                      child: Container(
                        child: Image.network(
                          products[index].image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      footer: Container(
                        height: 60,
                        color: Colors.blueGrey.withOpacity(0.5),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                "\$ ${products[index].price.toString()}",
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
                )
              : Container();
        });
  }
}
