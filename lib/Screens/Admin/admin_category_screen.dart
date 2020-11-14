import 'dart:io';

import 'package:Clothes_App/Models/adminCategory.dart';
import 'package:Clothes_App/Providers/language_provider.dart';
import 'package:Clothes_App/Screens/Admin/dashBoard_screen.dart';
import 'package:Clothes_App/Screens/Admin/all_orders.dart';
import 'package:Clothes_App/Screens/Admin/all_users.dart';
import 'package:Clothes_App/Screens/Admin/all_products.dart';
import 'package:Clothes_App/Screens/auth_screen.dart';
import 'package:Clothes_App/Screens/home_screen.dart';
import 'package:Clothes_App/Services/Auth.dart';
import 'package:Clothes_App/Widgets/admin_category_widget.dart';
import 'package:Clothes_App/Widgets/app_localizations.dart';
import 'package:Clothes_App/Widgets/shared_widget.dart';
import 'package:Clothes_App/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminCategoryScreen extends StatefulWidget {
  static const route = 'admin_category_screen';

  @override
  _AdminCategoryScreenState createState() => _AdminCategoryScreenState();
}

class _AdminCategoryScreenState extends State<AdminCategoryScreen> {
  final _auth = Auth();

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

  List<AdminCategory> category = [
    AdminCategory(
      id: '1',
      title: 'Add Product',
      icon: Icons.add,
    ),
    AdminCategory(
      id: '2',
      title: 'All Products',
      icon: Icons.edit,
    ),
    AdminCategory(
      id: '3',
      title: 'All Orders',
      icon: Icons.shopping_basket,
    ),
    AdminCategory(
      id: '4',
      title: 'All Users',
      icon: Icons.person,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onWillPop1,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: SharedWidget.dialogDecoration(),
            ),
            Container(
              height: screenHeight,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Container(
                    //   decoration: SharedWidget.dialogDecoration(),
                    // ),
                    // Padding(
                    //   padding:
                    //       const EdgeInsets.only(top: 50, left: 15, right: 15),
                    //   child: Container(
                    //     width: screenWidth * 0.6,
                    //     decoration: SharedWidget.adminDecoration(),
                    //     child: ExpansionTile(
                    //       expandedAlignment: Alignment.center,
                    //       children: <Widget>[
                    //         ListTile(
                    //             contentPadding:
                    //                 EdgeInsets.symmetric(horizontal: 30),
                    //             onTap: () {
                    //               languageProvider.updateLanguage('en');
                    //             },
                    //             title: Text(
                    //               AppLocalizations.of(context)
                    //                   .translate("English Language"),
                    //               style: TextStyle(
                    //                   fontSize: 16,
                    //                   fontWeight: FontWeight.bold,
                    //                   color: Colors.black),
                    //             )),
                    //         ListTile(
                    //             onTap: () {
                    //               languageProvider.updateLanguage('ar');
                    //             },
                    //             contentPadding:
                    //                 EdgeInsets.symmetric(horizontal: 30),
                    //             title: Text(
                    //               AppLocalizations.of(context)
                    //                   .translate("Arabic Language"),
                    //               style: TextStyle(
                    //                   fontSize: 16,
                    //                   fontWeight: FontWeight.bold,
                    //                   color: Colors.black),
                    //             ))
                    //       ],
                    //       title: Text(
                    //           AppLocalizations.of(context)
                    //               .translate("Language"),
                    //           style: kProfileStyle),
                    //       leading: Icon(
                    //         Icons.language,
                    //         color: Theme.of(context).iconTheme.color,
                    //         size: 40,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 80),
                      child: Container(
                        height: screenHeight * 0.6,
                        child: GridView.builder(
                          itemCount: category.length,
                          itemBuilder: (context, index) {
                            return CategoryWidget(
                              icon: category[index].icon,
                              title: category[index].title,
                              onPressed: () {
                                switch (category[index].id) {
                                  case '1':
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DashBoardScreen()));
                                    break;
                                  case '2':
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AllProductScreen()));
                                    break;
                                  case '3':
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AllordersScreen()));
                                    break;
                                  case '4':
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AllsersScreen()));
                                    break;
                                }
                              },
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        width: screenWidth * 0.5,
                        decoration: SharedWidget.adminDecoration(),
                        child: FlatButton.icon(
                          icon: Icon(Icons.exit_to_app),
                          label: Text(
                            'Log Out',
                            style: kProfileStyle,
                          ),
                          onPressed: () {
                            _auth.singOut();
                            Navigator.popAndPushNamed(
                                context, AuthScreen.route);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
