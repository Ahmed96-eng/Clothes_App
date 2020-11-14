import 'package:Clothes_App/Models/product_model.dart';
import 'package:Clothes_App/Providers/favorite.dart';
import 'package:Clothes_App/Screens/home_screen.dart';
import 'package:Clothes_App/Widgets/appBar_widget.dart';
import 'package:Clothes_App/Widgets/appDrawerWidget.dart';
import 'package:Clothes_App/Widgets/app_localizations.dart';
import 'package:Clothes_App/Widgets/cachedImageWidget.dart';
import 'package:Clothes_App/Widgets/shared_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  static const route = 'favorite_screen';

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  Future<bool> _willPopScope() async {
    Navigator.of(context).pop();
    // Navigator.of(context).pushNamed(HomeScreen.route);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Product product = ModalRoute.of(context).settings.arguments;
    List<Product> products = Provider.of<Favorite>(context).products;
    return WillPopScope(
      onWillPop: _willPopScope,
      child: Scaffold(
        drawer: AppDrawerWidget(),
        appBar: appBarWidgit(
          context,
          AppLocalizations.of(context).translate("My Favorite"),
        ),
        body: Stack(
          children: [
            Container(
              decoration: SharedWidget.dialogDecoration(),
            ),
            products.length == 0
                ? Center(
                    child: Text(
                      AppLocalizations.of(context)
                          .translate("No Product Found"),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          child: ListTile(
                            leading: Container(
                              width: 70,
                              height: 100,
                              child: CachedImageWidget(
                                imageUrl: products[index].image,
                              ),
                            ),
                            title: Text(products[index].name),
                            subtitle: Text(
                                "Item Price: \$ ${products[index].price.toString()}"),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Theme.of(context).errorColor,
                              ),
                              onPressed: () {
                                Provider.of<Favorite>(context, listen: false)
                                    .removeProductFromFavorite(products[index]);
                              },
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
