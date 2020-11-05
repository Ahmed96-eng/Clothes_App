import 'package:Clothes_App/constants.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  String title;
  Function onPressed;
  IconData icon;
  CategoryWidget({
    this.title,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: GridTile(
            footer: Text(
              title,
              textAlign: TextAlign.center,
              style: kProfileStyle,
            ),
            child: Icon(icon, size: 40.0, color: Colors.black),
          ),
        ),
        margin: EdgeInsets.all(1.0),
      ),
      onTap: onPressed,
    );
  }
}
