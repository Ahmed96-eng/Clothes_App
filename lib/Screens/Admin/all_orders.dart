import 'package:Clothes_App/Models/order.dart';
import 'package:Clothes_App/Screens/Admin/order_details.dart';
import 'package:Clothes_App/Services/DataServices.dart';
import 'package:Clothes_App/Widgets/shared_widget.dart';
import 'package:Clothes_App/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllordersScreen extends StatefulWidget {
  static const route = 'all_orders_screen';

  @override
  _AllordersScreenState createState() => _AllordersScreenState();
}

class _AllordersScreenState extends State<AllordersScreen> {
  final _dataServices = DataServices();

  Future<bool> _willPopScope() async {
    Navigator.of(context).pop();
    // Navigator.of(context).pushNamed(HomeScreen.route);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopScope,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Orders',
          ),
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
                  address: doc.data()[kAddress],
                  userName: doc.data()[kUserNameKey],
                  userEmail: doc.data()[kUserEmailKey],
                  userPhoneNumber: doc.data()[kUserPhoneNumberKey],
                ));
              }
              return Stack(
                children: [
                  Container(
                    decoration: SharedWidget.dialogDecoration(),
                  ),
                  ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, OrderDetails.route,
                              arguments: orders[index].id);
                        },
                        child: Container(
                          decoration: SharedWidget.dialogDecoration(),
                          // height: 50,
                          // width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("# ${orders[index].id.toString()}"),
                                SizedBox(height: 15),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 5, bottom: 5),
                                  child: Text(
                                      "$kUserNameKey : ${orders[index].userName.toString()}"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 5, bottom: 5),
                                  child: Text(
                                      "$kUserPhoneNumberKey : ${orders[index].userPhoneNumber.toString()}"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 5, bottom: 5),
                                  child: Text(
                                      "$kUserEmailKey : ${orders[index].userEmail.toString()}"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 5, bottom: 5),
                                  child: Text(
                                      "Total Order Price: ${orders[index].totalPrice.toString()}"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 5, bottom: 5),
                                  child: Text(
                                      "$kAddress : ${orders[index].address.toString()}"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
