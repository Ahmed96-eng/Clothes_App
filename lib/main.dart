import 'package:Clothes_App/Providers/boolProvider.dart';
import 'package:Clothes_App/Providers/cart.dart';
import 'package:Clothes_App/Providers/favorite.dart';
import 'package:Clothes_App/Providers/language_provider.dart';
import 'package:Clothes_App/Screens/Admin/admin_category_screen.dart';
import 'package:Clothes_App/Screens/Admin/dashBoard_screen.dart';
import 'package:Clothes_App/Screens/Admin/edit_screen.dart';
import 'package:Clothes_App/Screens/Admin/order_details.dart';
import 'package:Clothes_App/Screens/auth_screen.dart';
import 'package:Clothes_App/Screens/cart_screen.dart';
import 'package:Clothes_App/Screens/favorite_screen.dart';
import 'package:Clothes_App/Screens/home_screen.dart';
import 'package:Clothes_App/Screens/order_screen.dart';
import 'package:Clothes_App/Screens/productDetails.dart';
import 'package:Clothes_App/Screens/profile_screen.dart';
import 'package:Clothes_App/Widgets/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
          snapshot.data.getString(kLocalStringSharedPreferences);
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
              ChangeNotifierProvider<LanguageProvider>(
                create: (context) => LanguageProvider(),
              ),
            ],
            child: Builder(
              builder: (context) => Consumer<LanguageProvider>(
                builder: (_, languageProviderRef, child) => MaterialApp(
                  title: 'Clothes Store',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    primaryColor: Colors.cyan[700],

                    // primarySwatch: Colors.,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  ),

                  ////////// FOR LANGUAGE

                  locale: languageProviderRef.appLocale,

                  //List of all supported locales
                  supportedLocales: [
                    Locale('en', 'US'),
                    Locale('ar', 'EG'),
                  ],
                  builder: (context, child) {
                    return Directionality(
                      textDirection:
                          languageProviderRef.appLocale == Locale('en')
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                      child: child,
                    );
                  },
                  //These delegates make sure that the localization data for the proper language is loaded
                  localizationsDelegates: [
                    //A class which loads the translations from JSON files
                    AppLocalizations.delegate,
                    //Built-in localization of basic text for Material widgets (means those default Material widget such as alert dialog icon text)
                    GlobalMaterialLocalizations.delegate,
                    //Built-in localization for text direction LTR/RTL
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  //return a locale which will be used by the app
                  localeResolutionCallback: (locale, supportedLocales) {
                    //check if the current device locale is supported or not
                    for (var supportedLocale in supportedLocales) {
                      if (supportedLocale.languageCode ==
                              locale?.languageCode ||
                          supportedLocale.countryCode == locale?.countryCode) {
                        return supportedLocale;
                      }
                    }
                    //if the locale from the mobile device is not supported yet,
                    //user the first one from the list (in our case, that will be English)
                    return supportedLocales.first;
                  },

                  // home: AdminCategoryScreen(),
                  initialRoute: rememberMe
                      ?
                      //  HomeScreen.route
                      (isAdmin ? AdminCategoryScreen.route : HomeScreen.route)
                      : AuthScreen.route,
                  routes: {
                    AuthScreen.route: (context) => AuthScreen(),
                    HomeScreen.route: (context) => HomeScreen(),
                    AdminCategoryScreen.route: (context) =>
                        AdminCategoryScreen(),
                    EditScreen.route: (context) => EditScreen(),
                    ProductDetails.route: (context) => ProductDetails(),
                    CartScreen.route: (context) => CartScreen(),
                    FavoriteScreen.route: (context) => FavoriteScreen(),
                    OrderDetails.route: (context) => OrderDetails(),
                    ProfileScreen.route: (context) => ProfileScreen(),
                    DashBoardScreen.route: (context) => DashBoardScreen(),
                    OrderScreen.route: (context) => OrderScreen(),
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
