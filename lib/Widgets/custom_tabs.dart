import 'package:flutter/material.dart';

Widget customTabs({String id, @required String title}) {
  return Container(
    // height: MediaQuery.of(context).size.height * 0.01,
    // padding: EdgeInsets.symmetric(horizontal: 8),
    // height: 100,
    width: 120,
    decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        border: Border.all(
          width: 1.5,
          color: Colors.white24,
        ),
        borderRadius: BorderRadius.circular(15)),
    child: Tab(
      child: Text(
        title,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
