import 'package:Clothes_App/Providers/language_provider.dart';
import 'package:Clothes_App/Screens/auth_screen.dart';
import 'package:Clothes_App/Screens/cart_screen.dart';
import 'package:Clothes_App/Screens/favorite_screen.dart';
import 'package:Clothes_App/Screens/order_screen.dart';
import 'package:Clothes_App/Screens/profile_screen.dart';
import 'package:Clothes_App/Services/Auth.dart';
import 'package:Clothes_App/Widgets/app_localizations.dart';
import 'package:Clothes_App/Widgets/shared_widget.dart';
import 'package:Clothes_App/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawerWidget extends StatelessWidget {
  final _auth = Auth();
  @override
  Widget build(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    return Drawer(
      child: Stack(
        children: [
          Container(
            decoration: SharedWidget.dialogDecoration(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Row(
                  children: [
                    Container(
                      width: 200,
                      child: ExpansionTile(
                        expandedAlignment: Alignment.center,
                        children: <Widget>[
                          ListTile(
                              contentPadding: EdgeInsets.only(
                                  left: 30, right: 30, top: 0, bottom: 0),
                              onTap: () {
                                languageProvider.updateLanguage('en');
                              },
                              title: Text(
                                AppLocalizations.of(context)
                                    .translate("English Language"),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff005670)),
                              )),
                          ListTile(
                              onTap: () {
                                languageProvider.updateLanguage('ar');
                              },
                              contentPadding: EdgeInsets.only(
                                  left: 30, right: 30, top: 0, bottom: 0),
                              title: Text(
                                AppLocalizations.of(context)
                                    .translate("Arabic Language"),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff005670)),
                              ))
                        ],
                        title: Text(
                          AppLocalizations.of(context).translate("Language"),
                          style: TextStyle(
                            color: Color(0xff005670),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: Icon(
                          Icons.language,
                          color: Colors.blue[300],
                          size: 35,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 8),
                      child: Container(
                        // padding: EdgeInsets.all(5),
                        child: FloatingActionButton(
                          backgroundColor: Colors.blue[300],
                          child: Icon(Icons.person),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, ProfileScreen.route);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                  child: Text(
                    "Clothes Store",
                    style: kProfileStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Divider(height: 3, thickness: 2),
                DrawerListTile(
                  title: AppLocalizations.of(context).translate("My Favorite"),
                  icon: Icons.favorite,
                  pageRoute: FavoriteScreen.route,
                ),
                DrawerListTile(
                  title: AppLocalizations.of(context).translate("My Cart"),
                  icon: Icons.shopping_cart,
                  pageRoute: CartScreen.route,
                ),
                DrawerListTile(
                  title: AppLocalizations.of(context).translate("My Order"),
                  icon: Icons.shopping_basket,
                  pageRoute: OrderScreen.route,
                ),
                // ListTile(
                //   title: Container(
                //     child: IconButton(
                //       icon: Icon(Icons.exit_to_app),
                //       onPressed: () {
                //         print('////////////////////');
                //         _auth.singOut();
                //         Navigator.pop(context);
                //         Navigator.pushReplacementNamed(
                //             context, AuthScreen.route);
                //       },
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  IconData icon;
  String title;
  String pageRoute;
  DrawerListTile({this.title, this.icon, this.pageRoute});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(
          icon,
          size: 30,
          color: Colors.blue[300],
        ),
        title: Text(
          title,
          style: kProfileStyle,
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, pageRoute);
        },
      ),
    );
  }
}
