import 'package:Clothes_App/Providers/boolProvider.dart';
import 'package:Clothes_App/Providers/cart.dart';
import 'package:Clothes_App/Providers/favorite.dart';
import 'package:Clothes_App/Screens/Admin/admin_category_screen.dart';
import 'package:Clothes_App/Screens/Admin/dashBoard_screen.dart';
import 'package:Clothes_App/Screens/Admin/edit_screen.dart';
import 'package:Clothes_App/Screens/Admin/order_details.dart';
import 'package:Clothes_App/Screens/auth_screen.dart';
import 'package:Clothes_App/Screens/cart_screen.dart';
import 'package:Clothes_App/Screens/favorite_screen.dart';
import 'package:Clothes_App/Screens/home_screen.dart';
import 'package:Clothes_App/Screens/productDetails.dart';
import 'package:Clothes_App/Screens/profile_screen.dart';
import 'package:Clothes_App/Widgets/shared_widget.dart';
import 'package:Clothes_App/testOfGeolocator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool rememberMe = false;
  bool isAdmin = false;
  @override
  Widget build(BuildContext context) {
    // final boolProvider = Provider.of<BoolProvider>(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          rememberMe =
              snapshot.data.getBool(kRememberMeSharedPreferences) ?? false;
          isAdmin =
              snapshot.data.getBool(kUserIsAdminSharedPreferences) ?? false;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<BoolProvider>(
                create: (context) => BoolProvider(),
              ),
              ChangeNotifierProvider<Cart>(
                create: (context) => Cart(),
              ),
              ChangeNotifierProvider<Favorite>(
                create: (context) => Favorite(),
              ),
            ],
            child: Builder(
              builder: (context) => MaterialApp(
                title: 'Clothes_App',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primaryColor: Colors.indigo[300],
                  // primarySwatch: Colors.,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                // home: Test(),
                initialRoute: rememberMe
                    ?
                    //  HomeScreen.route
                    (isAdmin ? AdminCategoryScreen.route : HomeScreen.route)
                    : AuthScreen.route,
                routes: {
                  AuthScreen.route: (context) => AuthScreen(),
                  HomeScreen.route: (context) => HomeScreen(),
                  AdminCategoryScreen.route: (context) => AdminCategoryScreen(),
                  EditScreen.route: (context) => EditScreen(),
                  ProductDetails.route: (context) => ProductDetails(),
                  CartScreen.route: (context) => CartScreen(),
                  FavoriteScreen.route: (context) => FavoriteScreen(),
                  OrderDetails.route: (context) => OrderDetails(),
                  ProfileScreen.route: (context) => ProfileScreen(),
                  DashBoardScreen.route: (context) => DashBoardScreen(),
                },
              ),
            ),
          );
        }
      },
    );
  }
}
