import 'package:Clothes_App/Providers/cart.dart';
import 'package:Clothes_App/Providers/favorite.dart';
import 'package:Clothes_App/Screens/cart_screen.dart';
import 'package:Clothes_App/Screens/favorite_screen.dart';
import 'package:Clothes_App/Screens/profile_screen.dart';
import 'package:Clothes_App/Widgets/appDrawerWidget.dart';
import 'package:Clothes_App/Widgets/searchWidgetDelegate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'badge.dart';

PreferredSizeWidget appBarWidgit(
  BuildContext context,
  String title,
  //  String value, String value2
) {
  return PreferredSize(
    preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
    child: AppBar(
      title: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(title),
      ),
      actions: [
        // Padding(
        //   padding: const EdgeInsets.only(top: 8),
        //   child: Consumer<Cart>(
        //     builder: (context, cartItemProvider, child) => IconButton(
        //       icon: Icon(
        //         Icons.search,
        //         size: 30,
        //         color: Colors.blue[300],
        //       ),
        //       onPressed: () {
        //         showSearch(context: context, delegate: SearchWidgetDelegate());
        //       },
        //     ),
        //   ),
        // ),
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
          padding: const EdgeInsets.only(left: 3, right: 3, top: 8),
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

      // actions: [
      //   Badge(
      //     child: IconButton(
      //       icon: Icon(
      //         Icons.favorite,
      //       ),
      //       onPressed: () {
      //         Navigator.of(context).pushNamed(FavoriteScreen.route);
      //       },
      //     ),
      //     value: value,
      //   ),
      //   Badge(
      //     child: IconButton(
      //       icon: Icon(
      //         Icons.shopping_cart,
      //       ),
      //       onPressed: () {
      //         Navigator.of(context).pushNamed(CartScreen.route);
      //       },
      //     ),
      //     value: value2,
      //   ),
      // ],
    ),
  );
}
