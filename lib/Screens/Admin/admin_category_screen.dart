import 'dart:io';

import 'package:Clothes_App/Models/adminCategory.dart';
import 'package:Clothes_App/Providers/boolProvider.dart';
import 'package:Clothes_App/Screens/Admin/dashBoard_screen.dart';
import 'package:Clothes_App/Screens/Admin/all_orders.dart';
import 'package:Clothes_App/Screens/Admin/all_users.dart';
import 'package:Clothes_App/Screens/Admin/all_products.dart';
import 'package:Clothes_App/Screens/auth_screen.dart';
import 'package:Clothes_App/Services/Auth.dart';
import 'package:Clothes_App/Widgets/admin_category_widget.dart';
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

  List<AdminCategory> category = [
    AdminCategory(
      id: '1',
      title: 'Add',
      icon: Icons.add,
    ),
    AdminCategory(
      id: '2',
      title: 'AllProducts',
      icon: Icons.edit,
    ),
    AdminCategory(
      id: '3',
      title: 'All Orders',
      icon: Icons.shopping_basket,
    ),
    AdminCategory(
      id: '4',
      title: 'AllUsers',
      icon: Icons.person,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop1,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: SharedWidget.dialogDecoration(),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 100),
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
                                  builder: (context) => DashBoardScreen()));
                          break;
                        case '2':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllProductScreen()));
                          break;
                        case '3':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllordersScreen()));
                          break;
                        case '4':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllsersScreen()));
                          break;
                      }
                    },
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              heightFactor: 13,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.withOpacity(0.3),
                      Colors.blueAccent.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0, 1],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: FlatButton.icon(
                  icon: Icon(Icons.exit_to_app),
                  label: Text(
                    'Log Out',
                    style: kProfileStyle,
                  ),
                  onPressed: () {
                    _auth.singOut();
                    Navigator.popAndPushNamed(context, AuthScreen.route);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
