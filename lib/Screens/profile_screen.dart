// import 'package:Clothes_App/Providers/boolProvider.dart';

import 'package:Clothes_App/Providers/language_provider.dart';
import 'package:Clothes_App/Screens/auth_screen.dart';
import 'package:Clothes_App/Services/Auth.dart';

import 'package:Clothes_App/Widgets/app_localizations.dart';
import 'package:Clothes_App/Widgets/shared_widget.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class ProfileScreen extends StatefulWidget {
  static const route = 'profile_screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userId = "4fOTqYV0sPk8IzxkeYDk";

  // final _dataServices = DataServices();

  final _auth = Auth();

  @override
  void initState() {
    super.initState();
    _getUserID();
  }

  String userID = '';
  _getUserID() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    print('****------**=>${_pref.getString(kUserEmailSharedPreferences)}');
    setState(() {
      userID = (_pref.getString(kUserIDSharedPreferences) ?? '');
    });
    print(',,,,,,,,,,,,,,,..........------> $userID');
  }

  Future<bool> _willPopScope() async {
    Navigator.of(context).pop();
    // Navigator.of(context).pushNamed(HomeScreen.route);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _willPopScope,
      child: Scaffold(
        body: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Stack(
                children: [
                  Container(
                    decoration: SharedWidget.dialogDecoration(),
                  ),
                  ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          // height: 50,
                          // width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: CircleAvatar(
                                  radius: 70,
                                  // child: Image.network(
                                  //       "",
                                  //       fit: BoxFit.cover,
                                  //     ) ??
                                  //     "",
                                )),
                                SizedBox(height: 5),
                                Container(
                                  width: 200,
                                  child: ExpansionTile(
                                    expandedAlignment: Alignment.center,
                                    children: <Widget>[
                                      ListTile(
                                          contentPadding: EdgeInsets.only(
                                              left: 30,
                                              right: 0,
                                              top: 0,
                                              bottom: 0),
                                          onTap: () {
                                            languageProvider
                                                .updateLanguage('en');
                                          },
                                          title: Text(
                                            AppLocalizations.of(context)
                                                .translate("English Language"),
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue[900]),
                                          )),
                                      ListTile(
                                          onTap: () {
                                            languageProvider
                                                .updateLanguage('ar');
                                          },
                                          contentPadding: EdgeInsets.only(
                                              left: 30,
                                              right: 0,
                                              top: 0,
                                              bottom: 0),
                                          title: Text(
                                            AppLocalizations.of(context)
                                                .translate("Arabic Language"),
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue[900]),
                                          ))
                                    ],
                                    title: Text(
                                      AppLocalizations.of(context)
                                          .translate("Language"),
                                      style: TextStyle(
                                        color: Colors.blue[900],
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    leading: Icon(
                                      Icons.language,
                                      color: Theme.of(context).iconTheme.color,
                                      size: 40,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: screenWidth * 0.35,
                                      child: FlatButton.icon(
                                          color: Colors.blue[300],
                                          onPressed: () {
                                            SharedWidget.showAlertDailog(
                                              context: context,
                                              labelYes:
                                                  AppLocalizations.of(context)
                                                      .translate("Ok"),
                                              message:
                                                  AppLocalizations.of(context)
                                                      .translate("Coming Soon")
                                                      .toUpperCase(),
                                              labelNo: '',
                                              titlle:
                                                  AppLocalizations.of(context)
                                                      .translate("Hello")
                                                      .toUpperCase(),
                                              onPressNo: () {},
                                              isConfirm: false,
                                              onPressYes: () {
                                                Navigator.of(context).pop();
                                              },
                                            );
                                          },
                                          icon: Icon(Icons.edit),
                                          label: Text('Edit')),
                                    ),
                                    Container(
                                      width: screenWidth * 0.35,
                                      child: FlatButton.icon(
                                        color: Colors.blue[300],
                                        icon: Icon(Icons.exit_to_app),
                                        label: Text('Log Out'),
                                        onPressed: () {
                                          _auth.singOut();
                                          Navigator.pushReplacementNamed(
                                              context, AuthScreen.route);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: languageProvider
                                                .appLocale.languageCode ==
                                            'en'
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.start,
                                    crossAxisAlignment: languageProvider
                                                .appLocale.languageCode ==
                                            'en'
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        leading: Text(
                                          AppLocalizations.of(context)
                                              .translate("Name"),
                                          style: kProfileStyle,
                                        ),
                                        title: Text(
                                              snapshot.data.getStringList(
                                                          kUserLisDataSharedPreferences)[
                                                      1] ??
                                                  "",
                                              style: kProfileStyle,
                                            ) ??
                                            "",
                                      ),
                                      ListTile(
                                        leading: Text(
                                          AppLocalizations.of(context)
                                              .translate("Email"),
                                          style: kProfileStyle,
                                        ),
                                        title: Text(
                                              snapshot.data.getStringList(
                                                          kUserLisDataSharedPreferences)[
                                                      0] ??
                                                  "",
                                              style: kProfileStyle,
                                            ) ??
                                            "",
                                      ),
                                      ListTile(
                                        leading: Text(
                                          AppLocalizations.of(context)
                                              .translate("Mobile"),
                                          style: kProfileStyle,
                                        ),
                                        title: Text(
                                              snapshot.data.getStringList(
                                                          kUserLisDataSharedPreferences)[
                                                      2] ??
                                                  "",
                                              style: kProfileStyle,
                                            ) ??
                                            "",
                                      ),
                                      // Text(
                                      //   "$kUserNameKey: ${snapshot.data.getStringList(kUserLisDataSharedPreferences)[1]}",
                                      //   style: kProfileStyle,
                                      // ),
                                      // SizedBox(height: 15),
                                      // Text(
                                      //   "$kUserEmailKey: ${snapshot.data.getStringList(kUserLisDataSharedPreferences)[0]}",
                                      //   style: kProfileStyle,
                                      // ),
                                      // SizedBox(height: 15),
                                      // Text(
                                      //   "$kUserPhoneNumberKey: ${snapshot.data.getStringList(kUserLisDataSharedPreferences)[2]}",
                                      //   style: kProfileStyle,
                                      // ),
                                      // SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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

///////////////  IMPORTANT OR ME ////////////////////

////////    GET SINGLE DATA BY USIN STREAM    ////////

//  StreamBuilder(
//     stream: _dataServices.loadedSingleUser(userId),
//     builder: (context, snapshot) {
//       if (!snapshot.hasData) {
//         return Center(child: Text("Loading"));
//       }
//       var userDocument = snapshot.data;

// return Stack(
//   children: [
//     Container(
//       decoration: SharedWidget.dialogDecoration(),
//     ),
//     ListView(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(10),
//           child: Container(
//             // height: 50,
//             // width: double.infinity,
//             child: Padding(
//               padding: const EdgeInsets.all(15),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                       child: CircleAvatar(
//                     radius: 70,
//                     // child: Image.network(
//                     //       "",
//                     //       fit: BoxFit.cover,
//                     //     ) ??
//                     //     "",
//                   )),
//                   SizedBox(height: 10),
//                   Transform.translate(
//                     offset: Offset(
//                         0, screenHeight - screenWidth * 1.69),
//                     child: Divider(
//                       color: Colors.blue[300],
//                       thickness: 2,
//                       endIndent: screenWidth * 0.25,
//                       indent: screenWidth * 0.25,
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment:
//                         MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         width: screenWidth * 0.35,
//                         child: FlatButton.icon(
//                             color: Colors.blue[300],
//                             onPressed: () {},
//                             icon: Icon(Icons.edit),
//                             label: Text('Edit')),
//                       ),
//                       Container(
//                         width: screenWidth * 0.35,
//                         child: FlatButton.icon(
//                           color: Colors.blue[300],
//                           icon: Icon(Icons.exit_to_app),
//                           label: Text('Log Out'),
//                           onPressed: () {
//                             _auth.singOut();
//                             Navigator.popAndPushNamed(
//                                 context, AuthScreen.route);
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "$kUserNameKey: ${userDocument[kUserNameKey]}",
//                           style: kProfileStyle,
//                         ),
//                         SizedBox(height: 15),
//                         Text(
//                           "$kUserEmailKey: ${userDocument[kUserEmailKey]}",
//                           style: kProfileStyle,
//                         ),
//                         SizedBox(height: 15),
//                         Text(
//                           "$kUserPhoneNumberKey: ${userDocument[kUserPhoneNumberKey]}",
//                           style: kProfileStyle,
//                         ),
//                         SizedBox(height: 15),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   ],
// );
//     }),
