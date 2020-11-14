import 'dart:ui';
import 'package:Clothes_App/Models/product_model.dart';
import 'package:Clothes_App/Providers/cart.dart';
import 'package:Clothes_App/Providers/favorite.dart';
import 'package:Clothes_App/Providers/language_provider.dart';
import 'package:Clothes_App/Screens/home_screen.dart';
import 'package:Clothes_App/Screens/productDetails.dart';
import 'package:Clothes_App/Services/DataServices.dart';
import 'package:Clothes_App/Widgets/appBar_widget.dart';
import 'package:Clothes_App/Widgets/appDrawerWidget.dart';
import 'package:Clothes_App/Widgets/app_localizations.dart';
import 'package:Clothes_App/Widgets/cachedImageWidget.dart';
import 'package:Clothes_App/Widgets/shared_widget.dart';
import 'package:Clothes_App/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  static const route = 'cart_screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _dataServices = DataServices();
  Position _currentPosition;
  String _currentAddress;
  final _auth = FirebaseAuth.instance;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  TextEditingController userNameControler = TextEditingController();
  TextEditingController userPhoneControler = TextEditingController();

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
    Navigator.of(context).pop();
    // Navigator.of(context).pushNamed(HomeScreen.route);

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
    // int outIndex;
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final cartItemProvider = Provider.of<Cart>(context, listen: false);
    // final favoriteProvider = Provider.of<Favorite>(context, listen: false);
    List<Product> products = Provider.of<Cart>(context).products;
    return WillPopScope(
      onWillPop: _willPopScope,
      child: Scaffold(
        drawer: AppDrawerWidget(),
        appBar: appBarWidgit(
            context, AppLocalizations.of(context).translate("My Cart")),
        body: Stack(
          children: [
            Container(
              decoration: SharedWidget.dialogDecoration(),
            ),
            products.length == 0
                ? Center(
                    child: Text(
                      AppLocalizations.of(context)
                          .translate("No Product Found"),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        // outIndex = index;
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
                                    child: CachedImageWidget(
                                      imageUrl: products[index].image,
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
              left: 10,
              right: 10,
              bottom: 5,
              child: Container(
                height: languageProvider.appLocale.languageCode == 'en'
                    ? MediaQuery.of(context).size.height / 4.5
                    : MediaQuery.of(context).size.height / 4,
                child: ListView(
                  children: [
                    Text(
                      AppLocalizations.of(context).translate("My Location"),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        _currentAddress ?? "Please Wait",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context).translate("Total Price"),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            cartItemProvider.totalPrice.toString(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          AppLocalizations.of(context).translate("EGP"),
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 3),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        // color: Colors.blueGrey[300],
                        border: Border.all(
                            color: Colors.redAccent.withOpacity(0.4)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: RaisedButton.icon(
                          icon:
                              Icon(Icons.shopping_basket, color: Colors.white),
                          label: Text(
                            AppLocalizations.of(context).translate("ADD ORDER"),
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          onPressed: cartItemProvider.products.length == 0
                              ? () {
                                  SharedWidget.showAlertDailog(
                                    context: context,
                                    labelYes: AppLocalizations.of(context)
                                        .translate("Ok"),
                                    message: AppLocalizations.of(context)
                                        .translate("No Product Found"),
                                    labelNo: '',
                                    titlle: AppLocalizations.of(context)
                                        .translate("Warning"),
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
                                    labelYes: AppLocalizations.of(context)
                                        .translate("Order Now"),
                                    labelNo: AppLocalizations.of(context)
                                        .translate("Cancel"),
                                    titlle: AppLocalizations.of(context)
                                        .translate("Confirm Order"),
                                    onPressNo: () {
                                      Navigator.of(context).pop();
                                    },
                                    isConfirm: true,
                                    contentDecoration: true,
                                    contentDecorationLabel_1:
                                        AppLocalizations.of(context)
                                            .translate("My Location"),
                                    contentDecorationMessage_1:
                                        _currentAddress ?? "Waiting",
                                    contentDecorationLabel_2:
                                        AppLocalizations.of(context)
                                            .translate("Total Price"),
                                    contentDecorationMessage_2:
                                        ' ${cartItemProvider.totalPrice}',
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
                                        kUserIdKey: _auth.currentUser.uid,
                                        kTotalPrice:
                                            cartItemProvider.totalPrice,
                                        kAddress: _currentAddress ?? "Waiting",
                                        kUserNameKey: userNameControler.text,
                                        kUserPhoneNumberKey:
                                            userPhoneControler.text,
                                        kUserEmailKey: _prefs.getString(
                                            kUserEmailSharedPreferences),
                                        kDateTime:
                                            DateFormat("dd/MM/yyyy  -  hh:mm a")
                                                .format(DateTime.now()),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
