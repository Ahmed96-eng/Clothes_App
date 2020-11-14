import 'dart:ui';
import 'package:Clothes_App/Models/order.dart';
import 'package:Clothes_App/Screens/Admin/order_details.dart';
import 'package:Clothes_App/Screens/home_screen.dart';
import 'package:Clothes_App/Services/DataServices.dart';
import 'package:Clothes_App/Widgets/appBar_widget.dart';
import 'package:Clothes_App/Widgets/app_localizations.dart';
import 'package:Clothes_App/Widgets/shared_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class OrderScreen extends StatefulWidget {
  static const route = 'order_screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _dataServices = DataServices();
  final _auth = FirebaseAuth.instance;
  Future<bool> _willPopScope() async {
    Navigator.of(context).pushNamed(HomeScreen.route);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Product product = ModalRoute.of(context).settings.arguments;
    // List<Product> products = Provider.of<Favorite>(context).products;
    return WillPopScope(
      onWillPop: _willPopScope,
      child: Scaffold(
        appBar: appBarWidgit(
          context,
          AppLocalizations.of(context).translate("My Order"),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _dataServices.loadedOrders(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text('No Orders'),
                );
              } else {
                List<Order> orders = [];
                for (var doc in snapshot.data.docs) {
                  orders.add(Order(
                    id: doc.id,
                    totalPrice: doc.data()[kTotalPrice],
                    // address: doc.data()[kAddress],
                    // userName: doc.data()[kUserNameKey],
                    userEmail: doc.data()[kUserEmailKey],
                    // userPhoneNumber: doc.data()[kUserPhoneNumberKey],
                    dateTime: doc.data()[kDateTime].toString(),
                  ));
                }
                return Stack(
                  children: [
                    Container(
                      decoration: SharedWidget.dialogDecoration(),
                    ),
                    orders.length == 0
                        ? Center(
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate("No Product Found"),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          )
                        : ListView.builder(
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              return (orders[index].userEmail ==
                                      _auth.currentUser.email)
                                  ? Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Card(
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                                "# ${orders[index].id.toString()}"),
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 10, bottom: 10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Text(
                                                //     "My Email:  ${orders[index].userEmail.toString()}"),
                                                Text(
                                                  "Total Price: ${orders[index].totalPrice.toString()} EGP",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  "$kDateTime : ${orders[index].dateTime.toString()}",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          trailing: FlatButton(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.13,
                                              child: Text(
                                                'Details',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.blue[300],
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, OrderDetails.route,
                                                  arguments: orders[index].id);
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container();
                            },
                          ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
