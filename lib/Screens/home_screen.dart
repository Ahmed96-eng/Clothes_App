import 'dart:io';

import 'package:Clothes_App/Models/product_model.dart';
import 'package:Clothes_App/Providers/cart.dart';
import 'package:Clothes_App/Providers/favorite.dart';
import 'package:Clothes_App/Screens/cart_screen.dart';
import 'package:Clothes_App/Screens/favorite_screen.dart';
import 'package:Clothes_App/Screens/productDetails.dart';
import 'package:Clothes_App/Screens/profile_screen.dart';
import 'package:Clothes_App/Services/DataServices.dart';
import 'package:Clothes_App/Widgets/AllProductWidgwt.dart';
import 'package:Clothes_App/Widgets/TabsProductWidget.dart';
import 'package:Clothes_App/Widgets/badge.dart';
import 'package:Clothes_App/Widgets/custom_tabs.dart';
import 'package:Clothes_App/Widgets/shared_widget.dart';
import 'package:Clothes_App/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const route = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _dataServices = DataServices();
  List<Product> _products;
  final _tabBarInde = 0;

  TextEditingController searchCont;
  String _searchValue = "";
  @override
  void initState() {
    searchCont = TextEditingController();
    // Future.delayed(Duration.zero).then((value) => );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    searchCont.dispose();
  }

  Future<bool> _onWillPop1() async {
    return await SharedWidget.showAlertDailog(
          context: context,
          titlle: "Exit Application",
          message: "Are You Sure?",
          labelNo: "No",
          labelYes: "Yes",
          onPressNo: () => Navigator.of(context).pop(),
          onPressYes: () => exit(0),
          isConfirm: true,
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    // final cartItemProvider = Provider.of<Cart>(context, listen: false);
    // final favoriteItemProvider = Provider.of<Favorite>(context, listen: false);
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onWillPop1,
      child: DefaultTabController(
        initialIndex: _tabBarInde,
        length: 5,
        child: Scaffold(
          appBar: AppBar(
              leading: Container(
                padding: EdgeInsets.all(5),
                child: FloatingActionButton(
                  backgroundColor: Colors.blue[300],
                  child: Icon(Icons.person),
                  onPressed: () {
                    Navigator.pushNamed(context, ProfileScreen.route);
                  },
                ),
              ),
              actions: [
                Consumer<Favorite>(
                  builder: (context, favoriteItemProvider, child) => Badge(
                    color: Colors.blueGrey[300],
                    child: IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.blue[300],
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, FavoriteScreen.route);
                      },
                    ),
                    value: favoriteItemProvider.favoriteCount.toString(),
                  ),
                ),
                Consumer<Cart>(
                  builder: (context, cartItemProvider, child) => Badge(
                    color: Colors.blueGrey[300],
                    child: IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Colors.blue[300],
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, CartScreen.route);
                      },
                    ),
                    value: cartItemProvider.cartCount.toString(),
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(125),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16, left: 10, right: 10, bottom: 10),
                      child: Container(
                          height: height * 0.07,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              border: Border.all(
                                color: Colors.redAccent.withOpacity(0.4),
                              ),
                              borderRadius: BorderRadius.circular(20)),
                          child: TextField(
                            controller: searchCont,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.close),
                                color: Colors.black54,
                                onPressed: () {
                                  searchCont.clear();
                                  setState(() {
                                    _searchValue = "";
                                  });
                                },
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                _searchValue = value;
                              });
                            },
                          )),
                    ),
                    // SizedBox(height: 10),
                    Container(
                      height: height * 0.09,
                      child: TabBar(
                          isScrollable: true,
                          indicatorColor: Colors.red,
                          indicatorPadding: EdgeInsets.only(
                              bottom: 0, top: 10, right: 5, left: 5),
                          tabs: [
                            customTabs(title: kAll),
                            customTabs(title: kShirts),
                            customTabs(title: kTShirts),
                            customTabs(title: kTrousers),
                            customTabs(title: kJackets),
                          ]),
                    )
                  ],
                ),
              )),
          body: Stack(
            children: [
              Container(
                decoration: SharedWidget.dialogDecoration(),
              ),
              TabBarView(children: [
                AllProductWidget(
                  searchValue: searchCont.text,
                ),
                // productsView(kShirts),
                productsView(kShirts),
                productsView(kTShirts),
                productsView(kTrousers),
                productsView(kJackets),
                // TabsProductWidget(
                //   category: kTShirts,
                //   allproducts: _products,
                //   searchValue: searchCont.text,
                // ),
                // TabsProductWidget(
                //   category: kTrousers,
                //   allproducts: _products,
                //   searchValue: searchCont.text,
                // ),
                // TabsProductWidget(
                //   category: kJackets,
                //   allproducts: _products,
                //   searchValue: searchCont.text,
                // ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget productsView(String category) {
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

            _products = [...products];
            products.clear();

            products = _dataServices.getProductByCategory(category, _products);

            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 2 / 3),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return products[index]
                          .name
                          .toLowerCase()
                          .trim()
                          .contains(_searchValue)
                      ? Align(
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
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            products[index].name ?? "",
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
                        )
                      : Container(
                          width: 0,
                          height: 0,
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
