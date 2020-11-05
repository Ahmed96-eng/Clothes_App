import 'package:Clothes_App/Models/order.dart';
import 'package:Clothes_App/Models/user.dart';
import 'package:Clothes_App/Screens/Admin/order_details.dart';
import 'package:Clothes_App/Services/Auth.dart';
import 'package:Clothes_App/Services/DataServices.dart';
import 'package:Clothes_App/Widgets/shared_widget.dart';
import 'package:Clothes_App/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllsersScreen extends StatefulWidget {
  static const route = 'all_users_screen';

  @override
  _AllsersScreenState createState() => _AllsersScreenState();
}

class _AllsersScreenState extends State<AllsersScreen> {
  final _dataServices = DataServices();

  final _auth = FirebaseAuth.instance;
  Future<bool> _willPopScope() async {
    Navigator.of(context).pop();
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
            'Users',
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _dataServices.loadedUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<UserData> users = [];
              for (var doc in snapshot.data.docs) {
                users.add(UserData(
                  id: doc.id,
                  name: doc.data()[kUserNameKey],
                  email: doc.data()[kUserEmailKey],
                  phoneNumber: doc.data()[kUserPhoneNumberKey],
                  photo: doc.data()[kUserPhotoKey],
                ));
              }

              return Stack(
                children: [
                  Container(
                    decoration: SharedWidget.dialogDecoration(),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "NUMER OF USERS :${users.length.toString()}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(10),
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
                                    Text("# ${users[index].id.toString()}"),
                                    SizedBox(height: 10),
                                    Center(
                                        child: Column(
                                      children: [
                                        Text(
                                            "$kUserNameKey: ${users[index].name.toString()}"),
                                        Text(
                                            "$kUserEmailKey: ${users[index].email.toString()}"),
                                        Text(
                                            "$kUserPhoneNumberKey: ${users[index].phoneNumber.toString()}"),
                                        Text(
                                            "$kUserPhotoKey: ${users[index].photo.toString()}"),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Center(
                child: Text('No Orders'),
              );
            }
          },
        ),
      ),
    );
  }
}
