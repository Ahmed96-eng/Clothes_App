import 'package:Clothes_App/Models/product_model.dart';
import 'package:Clothes_App/Providers/cart.dart';
import 'package:Clothes_App/Providers/favorite.dart';
import 'package:Clothes_App/Screens/favorite_screen.dart';
import 'package:Clothes_App/Screens/profile_screen.dart';
import 'package:Clothes_App/Widgets/badge.dart';
import 'package:Clothes_App/Widgets/shared_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_screen.dart';
import 'home_screen.dart';

class ProductDetails extends StatefulWidget {
  static const route = 'product_details';

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int fixedQuantity = 1;
  // Product product;
  // @override
  // void didChangeDependencies() {
  //   product = ModalRoute.of(context).settings.arguments;
  //   super.didChangeDependencies();
  // }
  Future<bool> _willPopScope() async {
    Navigator.of(context).pop();
    // Navigator.of(context).pushNamed(HomeScreen.route);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context).settings.arguments;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _willPopScope,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: SharedWidget.dialogDecoration(),
            ),
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  snap: false,
                  stretch: true,
                  floating: true,
                  excludeHeaderSemantics: true,
                  automaticallyImplyLeading: true,
                  backgroundColor: Colors.redAccent.withOpacity(0.4),
                  pinned: true,
                  expandedHeight: height * 0.45,
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
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      product.image,
                      fit: BoxFit.cover,
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
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  ListTile(
                    title: Text(
                      product.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    trailing: Consumer<Favorite>(
                      builder: (context, favoriteProvider, child) => Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(
                          width: width * 0.13,
                          height: height * 0.12,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.blue[300],
                              border: Border.all(
                                  color: Colors.redAccent.withOpacity(0.4))),
                          child: Center(
                            child: IconButton(
                                icon: Icon(
                                  product.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: product.isFavorite
                                      ? Colors.red[500]
                                      : Colors.white,
                                  size: 26,
                                ),
                                onPressed: () {
                                  print(
                                      ',,,,,,,,,,,,,,,,,,,,,,,,${favoriteProvider.isFavorite}');

                                  if (product.isFavorite == false) {
                                    favoriteProvider
                                        .addProductToFavorite(product);
                                    favoriteProvider.changeFavorite(
                                        product.isFavorite = true);
                                    // setState(() {
                                    //   product.isFavorite = true;
                                    // });
                                    SharedWidget.showToastMsg(
                                        'Add To Favorite Success ',
                                        time: 2);
                                    print(
                                        ',,,,,,,,,,,,000000000,,,,,,,,,,,,${favoriteProvider.isFavorite}');
                                  } else {
                                    favoriteProvider
                                        .removeProductFromFavorite(product);
                                    favoriteProvider.changeFavorite(
                                        product.isFavorite = false);
                                    // setState(() {
                                    //   product.isFavorite = false;
                                    // });
                                    SharedWidget.showToastMsg(
                                        'Delete From Favorite Success ',
                                        time: 2);
                                    print(
                                        ',,,,,,,,,222222222222,,,,,,,,,,,,,,,${favoriteProvider.isFavorite}');
                                  }
                                }),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Text(
                      "Category: ${product.category.toString()}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "StockQuantity: x${product.stockQuantity.toString()}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    title: Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment:
                      //     CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.remove_circle,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                if (product.quantity > 1) product.quantity--;
                              });
                            }),
                        Text(
                          // product.product.quantity > 1
                          //     ? fixedQuantity.toString()
                          //     :
                          product.quantity.toString(),
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.add_circle,
                              size: 30,
                            ),
                            onPressed: () {
                              print(product.quantity);
                              print(product.stockQuantity);
                              if (product.quantity >
                                  product.stockQuantity - 1) {
                                return SharedWidget.showToastMsg(
                                    'Out of Stock ',
                                    time: 4);
                              }
                              setState(() {
                                product.quantity++;
                              });
                            }),
                      ],
                    ),
                    trailing: Text(
                      "\$ ${product.price}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Consumer<Cart>(
                    builder: (context, cartProvider, child) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          // color: Colors.blueGrey[300],
                          border: Border.all(
                              color: Colors.redAccent.withOpacity(0.4)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: RaisedButton.icon(
                            icon: Icon(Icons.shopping_cart),
                            label: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'Add To Cart',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            onPressed: () {
                              bool exist = false;
                              var allCartProducts = cartProvider.products;
                              for (var cartProduct in allCartProducts) {
                                if (cartProduct.id == product.id) {
                                  exist = true;
                                  print('@@@@@@@@@@@@@@@ -> ${cartProduct.id}');
                                  print('############### ->${product.id}');
                                }
                              }
                              if (exist) {
                                SharedWidget.showToastMsg('Product Exsit',
                                    time: 2);
                              } else {
                                cartProvider.addProductToCart(product);
                                SharedWidget.showToastMsg(
                                    'Add To Cart Success ',
                                    time: 2);
                              }
                            },
                            color: Colors.blue[300],
                            // highlightColor: Colors.black.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Description',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      product.description,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: height - 350,
                    // color: Colors.amberAccent,
                  ),
                ])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
