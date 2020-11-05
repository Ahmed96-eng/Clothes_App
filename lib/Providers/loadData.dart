import 'package:Clothes_App/Models/product_model.dart';
import 'package:Clothes_App/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class LoadData extends ChangeNotifier {
  final _fireStore = FirebaseFirestore.instance;
}
