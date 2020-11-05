import 'package:Clothes_App/Models/product_model.dart';
import 'package:Clothes_App/Providers/cart.dart';
import 'package:Clothes_App/Providers/favorite.dart';
import 'package:Clothes_App/Screens/home_screen.dart';
import 'package:Clothes_App/Screens/productDetails.dart';
import 'package:Clothes_App/Screens/profile_screen.dart';
import 'package:Clothes_App/Widgets/shared_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  static const route = 'favorite_screen';

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  Future<bool> _willPopScope() async {
    // Navigator.of(context).pop();
    Navigator.of(context).pushNamed(HomeScreen.route);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Product product = ModalRoute.of(context).settings.arguments;
    List<Product> products = Provider.of<Favorite>(context).products;
    return WillPopScope(
      onWillPop: _willPopScope,
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
        ),
        body: Stack(
          children: [
            Container(
              decoration: SharedWidget.dialogDecoration(),
            ),
            ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ProductDetails.route,
                          arguments: products[index]);
                    },
                    child: Card(
                      child: ListTile(
                        leading: Container(
                          child: Image.network(
                            products[index].image ?? "",
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(products[index].name),
                        subtitle: Text(
                            "Item Price: \$ ${products[index].price.toString()}"),
                        // trailing: Consumer<Favorite>(
                        //   builder: (context, favoriteItemPrpvider, child) =>
                        //       Container(
                        //     width: 50,
                        //     child: IconButton(
                        //         icon: Icon(
                        //           Icons.delete,
                        //           color: Theme.of(context).errorColor,
                        //         ),
                        //         onPressed: () {
                        //           favoriteItemPrpvider
                        //               .removeProductFromFavorite(products[index]);

                        //           favoriteItemPrpvider.changeFavorite(
                        //               products[index].isFavorite = false);

                        //           SharedWidget.showToastMsg(
                        //               'Delete From Favorite Success ',
                        //               time: 2);
                        //         }),
                        //   ),
                        // ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
