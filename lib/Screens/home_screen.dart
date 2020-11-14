import 'dart:io';
import 'dart:ui';
import 'package:Clothes_App/Models/product_model.dart';
import 'package:Clothes_App/Providers/cart.dart';
import 'package:Clothes_App/Providers/favorite.dart';
import 'package:Clothes_App/Screens/cart_screen.dart';
import 'package:Clothes_App/Screens/favorite_screen.dart';
import 'package:Clothes_App/Screens/productDetails.dart';
import 'package:Clothes_App/Services/DataServices.dart';
import 'package:Clothes_App/Widgets/AllProductWidgwt.dart';
import 'package:Clothes_App/Widgets/appDrawerWidget.dart';
import 'package:Clothes_App/Widgets/app_localizations.dart';
import 'package:Clothes_App/Widgets/badge.dart';
import 'package:Clothes_App/Widgets/cachedImageWidget.dart';
import 'package:Clothes_App/Widgets/custom_tabs.dart';
import 'package:Clothes_App/Widgets/searchWidgetDelegate.dart';
import 'package:Clothes_App/Widgets/shared_widget.dart';
import 'package:Clothes_App/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'order_screen.dart';

class HomeScreen extends StatefulWidget {
  static const route = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _dataServices = DataServices();
  List<Product> _products;
  final _tabBarInde = 0;
  final _auth = FirebaseAuth.instance;

  TextEditingController searchCont;
  String _searchValue = "";
  @override
  void initState() {
    searchCont = TextEditingController();
    // Future.delayed(Duration.zero).then((value) => );
    localStringSP;

    super.initState();
  }

  Future get localStringSP async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(kLocalStringSharedPreferences);
  }

  @override
  void dispose() {
    super.dispose();
    searchCont.dispose();
  }

  Future<bool> _onWillPop1() async {
    return await SharedWidget.showAlertDailog(
          context: context,
          titlle: AppLocalizations.of(context).translate("Exit Application"),
          message:
              AppLocalizations.of(context).translate("Do You Want To Exit"),
          labelNo: AppLocalizations.of(context).translate("NO"),
          labelYes: AppLocalizations.of(context).translate("Yes"),
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
          drawer: AppDrawerWidget(),
          appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Clothes Store',
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              // leading: Padding(
              //   padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
              //   child: Container(
              //     // padding: EdgeInsets.all(5),
              //     child: FloatingActionButton(
              //       backgroundColor: Colors.blue[300],
              //       child: Icon(Icons.person),
              //       onPressed: () {
              //         Navigator.pushNamed(context, ProfileScreen.route);
              //       },
              //     ),
              //   ),
              // ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Consumer<Cart>(
                    builder: (context, cartItemProvider, child) => IconButton(
                      icon: Icon(
                        Icons.search,
                        size: 30,
                        color: Colors.blue[300],
                      ),
                      onPressed: () {
                        showSearch(
                            context: context, delegate: SearchWidgetDelegate());
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Consumer<Favorite>(
                    builder: (context, favoriteItemProvider, child) => Badge(
                      color: Colors.blueGrey[300],
                      child: IconButton(
                        icon: Icon(
                          Icons.favorite,
                          size: 30,
                          color: Colors.blue[300],
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, FavoriteScreen.route);
                        },
                      ),
                      value: favoriteItemProvider.favoriteCount.toString(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Consumer<Cart>(
                    builder: (context, cartItemProvider, child) => Badge(
                      color: Colors.blueGrey[300],
                      child: IconButton(
                        icon: Icon(
                          Icons.shopping_cart,
                          size: 30,
                          color: Colors.blue[300],
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, CartScreen.route);
                        },
                      ),
                      value: cartItemProvider.cartCount.toString(),
                    ),
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(height * 0.1),
                child: Container(
                  height: height * 0.08,
                  child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      isScrollable: true,
                      indicatorColor: Colors.white,
                      indicatorPadding: EdgeInsets.only(
                          bottom: 0, top: 10, right: 15, left: 15),
                      tabs: [
                        customTabs(
                            title:
                                AppLocalizations.of(context).translate("All")),
                        customTabs(
                            title: AppLocalizations.of(context)
                                .translate("Shirt")),
                        customTabs(
                            title: AppLocalizations.of(context)
                                .translate("TShirt")),
                        customTabs(
                            title: AppLocalizations.of(context)
                                .translate("Trouser")),
                        customTabs(
                            title: AppLocalizations.of(context)
                                .translate("Jacket")),
                      ]),
                ),
              )),
          body: Stack(
            children: [
              Container(
                decoration: SharedWidget.dialogDecoration(),
              ),
              TabBarView(children: [
                AllProductWidget(),

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
