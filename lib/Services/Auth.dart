import 'package:Clothes_App/Models/http_exception.dart';
import 'package:Clothes_App/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  final _auth = FirebaseAuth.instance;
  final _authRef = FirebaseFirestore.instance;

  Future<void> signUp(String email, String password,
      [String userName, String phoneNumber, String id]) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      _authRef.collection(kUserCollection).add({
        kUserIdKey: id,
        kUserEmailKey: email,
        kUserPasswordKey: password,
        kUserNameKey: userName,
        kUserPhoneNumberKey: phoneNumber,
      }).catchError((error) {
        throw error;
      });
    });
    List<String> userData = [email, userName, phoneNumber];
    _pref.setString(kUserEmailSharedPreferences, email);
    _pref.setString(kUserIDSharedPreferences, _auth.currentUser.uid);
    print('zzzzzzzzzzzzzzzzz-> ${_pref.getString(kUserIDSharedPreferences)}');

    _pref.setStringList(kUserLisDataSharedPreferences, userData);
    // _pref.setString(kUserEmailSharedPreferences, email);
    // print('**********=>${_pref.getString(kUserEmailSharedPreferences)}');
    print(
        '****nnnnnnnnn******=>${_pref.getStringList(kUserLisDataSharedPreferences)}');
  }

  Future<void> signIn(String email, String password,
      [String name, String phone]) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print('zzzzzzzzzzzzzzzzz-> ${_auth.currentUser.uid}');
      print('zzzzzzzzzzzzzzzzz-> ${_auth.currentUser.displayName}');
      print('zzzzzzzzzzzzzzzzz-> ${_auth.currentUser.email}');

      // _pref.getStringList(kUserLisDataSharedPreferences);

      _pref.setString(kUserIDSharedPreferences, _auth.currentUser.uid);

      _pref.setString(kUserEmailSharedPreferences, email);
      print('zzzzzzzzzzzzzzzzz-> ${_pref.getString(kUserIDSharedPreferences)}');

      print('zzzzzzzzzzzzzzzzz-> ${_pref.getString(kUserIDSharedPreferences)}');
    }).catchError((error) {
      throw error;
    });

    _pref.getStringList(kUserLisDataSharedPreferences);
    _pref.setString(kUserEmailSharedPreferences, email);
    print('++++++++++++++=>${_pref.getString(kUserEmailSharedPreferences)}');
  }

  void singOut() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove(kRememberMeSharedPreferences);
    // _prefs.remove(kUserLisDataSharedPreferences);
    _auth.signOut();
  }
}
