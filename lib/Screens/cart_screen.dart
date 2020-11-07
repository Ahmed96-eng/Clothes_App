import 'dart:ui';

import 'package:Clothes_App/Models/product_model.dart';
import 'package:Clothes_App/Providers/cart.dart';
import 'package:Clothes_App/Screens/home_screen.dart';
import 'package:Clothes_App/Screens/productDetails.dart';
import 'package:Clothes_App/Screens/profile_screen.dart';
import 'package:Clothes_App/Services/DataServices.dart';
import 'package:Clothes_App/Widgets/appBar_widget.dart';
import 'package:Clothes_App/Widgets/shared_widget.dart';
import 'package:Clothes_App/constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  static const route = 'cart_screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  GlobalKey _formKey = GlobalKey<FormState>();
  final _dataServices = DataServices();
  Position _currentPosition;
  String _currentAddress;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  TextEditingController userNameControler = TextEditingController();
  TextEditingController userPhoneControler = TextEditingController();
  Map<String, String> _userData = {
    kUserNameKey: '',
    kUserEmailKey: '',
    kUserPhoneNumberKey: '',
  };

  getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      // List<Placemark> placemarks = await placemarkFromCoordinates(52.2165157, 6.9437819);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality},${place.subAdministrativeArea},${place.administrativeArea},${place.country}";
      });
      print(",,,,,,,,,,,,--_-> ${_currentAddress.characters}");
      print(",,,,,,,,,,,,--_-> ${place.position}");
      print(",,,,,,,,,,,,--_-> ${place.isoCountryCode}");
      return _currentAddress;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, getCurrentLocation());
    _currentAddress;
    super.initState();
  }

  Future<bool> _willPopScope() async {
    // Navigator.of(context).pop();
    Navigator.of(context).pushNamed(HomeScreen.route);

    return true;
  }

  @override
  void dispose() {
    userNameControler.dispose();
    userPhoneControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Product product = ModalRoute.of(context).settings.arguments;
    final cartItemProvider = Provider.of<Cart>(context, listen: false);
    List<Product> products = Provider.of<Cart>(context).products;
    return WillPopScope(
      onWillPop: _willPopScope,
      child: Scaffold(
        appBar: appBarWidgit(context, 'My Cart'),
        body: Stack(
          children: [
            Container(
              decoration: SharedWidget.dialogDecoration(),
            ),
            products.length == 0
                ? Center(
                    child: Text(
                      "No Product Found !!!!!!!!",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 5, left: 5, right: 5),
                          child: Container(
                            child: Card(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                  leading: Container(
                                    width: 50,
                                    height: 150,
                                    child: Image.network(
                                      products[index].image ?? "",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  title: Text(products[index].name),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Item Price: \$ ${products[index].price.toString()}"),
                                      Text(
                                          "Selected Quantety: x${products[index].quantity.toString()}"),
                                    ],
                                  ),
                                  trailing: Container(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              cartItemProvider
                                                  .removeProductFromCart(
                                                      products[index]);

                                              Navigator.pushNamed(
                                                  context, ProductDetails.route,
                                                  arguments: products[index]);
                                            }),
                                        IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color:
                                                  Theme.of(context).errorColor,
                                            ),
                                            onPressed: () {
                                              cartItemProvider
                                                  .removeProductFromCart(
                                                      products[index]);
                                              SharedWidget.showToastMsg(
                                                  'Product Deleted Successfully ',
                                                  time: 4);
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            Positioned(
              left: 2,
              right: 2,
              bottom: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      'MY LOCATION IS :',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      _currentAddress ?? "Please Wait",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 15, left: 15, right: 8),
                    child: Text(
                      "Total Price : \$ ${cartItemProvider.totalPrice}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      // color: Colors.blueGrey[300],
                      border:
                          Border.all(color: Colors.redAccent.withOpacity(0.4)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: RaisedButton.icon(
                        icon: Icon(Icons.shopping_basket, color: Colors.white),
                        label: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Add Order',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        onPressed: cartItemProvider.products.length == 0
                            ? () {
                                SharedWidget.showAlertDailog(
                                  context: context,
                                  labelYes: 'Ok',
                                  message: 'No Product Found !!!!!!!!',
                                  labelNo: '',
                                  titlle: 'Warning',
                                  onPressNo: () {},
                                  isConfirm: false,
                                  onPressYes: () {
                                    Navigator.of(context).pop();
                                  },
                                );
                              }
                            : () async {
                                final _prefs =
                                    await SharedPreferences.getInstance();
                                // getCurrentLocation() ??
                                //     Future.delayed(Duration.zero);
                                SharedWidget.showAlertDailog(
                                  context: context,
                                  labelYes: 'Order Now',
                                  labelNo: 'Cancel',
                                  titlle: 'CONFIRM ORDER',
                                  onPressNo: () {
                                    Navigator.of(context).pop();
                                  },
                                  isConfirm: true,
                                  contentDecoration: true,
                                  contentDecorationLabel_1: 'MY LOCATION IS : ',
                                  contentDecorationMessage_1:
                                      _currentAddress ?? "Waiting",
                                  contentDecorationLabel_2: 'TOTAL PRICE IS : ',
                                  contentDecorationMessage_2:
                                      '\$ ${cartItemProvider.totalPrice}',
                                  textFieldcontroller_1: userNameControler,
                                  textFieldcontroller_2: userPhoneControler,
                                  fixedEmailHint: _prefs
                                      .getString(kUserEmailSharedPreferences),
                                  onPressYes: () {
                                    if (userNameControler.text.isEmpty ||
                                        userPhoneControler.text.isEmpty) {
                                      return SharedWidget.showToastMsg(
                                          'Please Complete All Fields',
                                          time: 4);
                                    } else if (userPhoneControler.text
                                            .trim()
                                            .length <
                                        11) {
                                      return SharedWidget.showToastMsg(
                                          'Phone Number Not Correct, Please try again',
                                          time: 4);
                                    } else if (_currentAddress == null) {
                                      return SharedWidget.showToastMsg(
                                          'Please check your location',
                                          time: 4);
                                    }
                                    Navigator.of(context).pop();
                                    _dataServices.addOrder({
                                      kTotalPrice: cartItemProvider.totalPrice,
                                      kAddress: _currentAddress ?? "Waiting",
                                      kUserNameKey: userNameControler.text,
                                      kUserPhoneNumberKey:
                                          userPhoneControler.text,
                                      kUserEmailKey: _prefs.getString(
                                          kUserEmailSharedPreferences),
                                    }, products);

                                    products.clear();
                                    Navigator.pushNamed(
                                        context, HomeScreen.route);
                                  },
                                );
                              },
                        color: Colors.blue[300],
                        // highlightColor: Colors.black.withOpacity(0.4),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
