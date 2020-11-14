import 'package:Clothes_App/Providers/boolProvider.dart';
import 'package:Clothes_App/Screens/Admin/admin_category_screen.dart';
import 'package:Clothes_App/Screens/home_screen.dart';
import 'package:Clothes_App/Services/Auth.dart';
import 'package:Clothes_App/Widgets/shared_widget.dart';
import 'package:Clothes_App/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const route = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: SharedWidget.dialogDecoration(),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: deviceSize.height * 0.2,
                    width: deviceSize.width * 0.32,
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage("assets/image/clothes_logo.png"),
                        fit: BoxFit.cover,
                        alignment: Alignment.bottomLeft,
                        // centerSlice: Rect.fromCenter(
                        //   center: Offset(0, 0),
                        //   width: deviceSize.width * 0.3,
                        //   height: deviceSize.height * 0.8,
                        // ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final adminPassword = 'admin000000';
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _checkBoxValue = false;
  final _auth = Auth();
  final _confirmPsswordFoucsNode = FocusNode();
  final _phoneNumberFoucsNode = FocusNode();
  final _emailFoucsNode = FocusNode();
  final _passwordFoucsNode = FocusNode();

  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    kUserEmailKey: '',
    kUserPasswordKey: '',
  };
  // var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.red[400].withOpacity(0.4),
        title: Text(
          'An Error Occurred!',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
              fontSize: 20),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            shape: StadiumBorder(),
            color: Colors.white,
            child: new Text(
              'Okay',
              style: TextStyle(color: Colors.black54),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }

  void rememberMeLoggedIn() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setBool(kRememberMeSharedPreferences, _checkBoxValue);
  }

  void isAdminSharedPrefernce() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    final boolProvider = Provider.of<BoolProvider>(context, listen: false);
    _pref.setBool(kUserIsAdminSharedPreferences, boolProvider.isAdmin);
  }

  Future<void> _submit() async {
    final provider = Provider.of<BoolProvider>(context, listen: false);
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    provider.changeLoadingValue(true);
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in

        if (provider.isAdmin) {
          if (_authData[kUserPasswordKey] == adminPassword) {
            await _auth.signIn(
              _authData[kUserEmailKey],
              _authData[kUserPasswordKey],
              _authData[kUserNameKey],
              _authData[kUserPhoneNumberKey],
            );

            Navigator.of(context).pushNamed(AdminCategoryScreen.route);
          } else {
            const errorMessage =
                'You Are Not Admin. Please enter correct data.';
            _showErrorDialog(errorMessage.toUpperCase());
          }
        } else {
          await _auth.signIn(
            _authData[kUserEmailKey],
            _authData[kUserPasswordKey],
            _authData[kUserNameKey],
            _authData[kUserPhoneNumberKey],
          );
          Navigator.of(context).pushNamed(HomeScreen.route);
        }
      } else {
        // Sign user up

        if (provider.isAdmin) {
          if (_authData[kUserPasswordKey] == adminPassword) {
            await _auth.signUp(
              _authData[kUserEmailKey],
              _authData[kUserPasswordKey],
              _authData[kUserNameKey],
              _authData[kUserPhoneNumberKey],
            );
            Navigator.of(context).pushNamed(AdminCategoryScreen.route);
          } else {
            const errorMessage =
                'You Are Not Admin. Please enter correct data.';
            _showErrorDialog(errorMessage.toUpperCase());
          }
        } else {
          await _auth.signUp(
            _authData[kUserEmailKey],
            _authData[kUserPasswordKey],
            _authData[kUserNameKey],
            _authData[kUserPhoneNumberKey],
          );
          Navigator.of(context).pushNamed(HomeScreen.route);
        }
      }
    } on FirebaseAuthException catch (error) {
      var errorMessage = 'Authentication failed   ';
      if (error.code.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.code.toString().contains('ERROR_USER_NOT_FOUND')) {
        errorMessage =
            'This is not a valid email address, please enter correct email';
      } else if (error.code.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.code.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.code.toString().contains('NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.code.toString().contains('ERROR_WRONG_PASSWORD')) {
        errorMessage = 'Invalid password, please enter correct password';
      } else {
        errorMessage = 'ERROR. Please try again later.';
      }
      _showErrorDialog(errorMessage);
      // } catch (error) {
      //   const errorMessage =
      //       'Could not authenticate you. Please try again later.';
      //   _showErrorDialog(errorMessage);
    }

    provider.changeLoadingValue(false);
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  // void initState() {
  //   super.initState();
  //   Firebase.initializeApp().whenComplete(() {
  //     setState(() {});
  //   });
  // }

  @override
  void dispose() {
    _confirmPsswordFoucsNode.dispose();
    _phoneNumberFoucsNode.dispose();
    _emailFoucsNode.dispose();
    _passwordFoucsNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final boolProvider = Provider.of<BoolProvider>(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup
            ? deviceSize.height * 0.60
            : deviceSize.height * 0.55,
        constraints: BoxConstraints(
            minHeight: _authMode == AuthMode.Signup
                ? deviceSize.height * 0.60
                : deviceSize.height * 0.55),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                //////////////

                (_authMode == AuthMode.Signup)
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[300],
                              border: Border.all(
                                  color: Colors.redAccent.withOpacity(0.4))),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'UserName',
                              border: InputBorder.none,
                              labelStyle: TextStyle(color: Colors.black),
                            ),
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter the userName Please!';
                              } else if (value.trim().length > 15) {
                                return 'UserName is long';
                              } else if (value.trim().length < 3) {
                                return 'UserName is short';
                              }
                            },
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_phoneNumberFoucsNode);
                            },
                            onSaved: (value) {
                              _authData[kUserNameKey] = value;
                            },
                          ),
                        ),
                      )
                    : Container(),
                (_authMode == AuthMode.Signup)
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[300],
                              border: Border.all(
                                  color: Colors.redAccent.withOpacity(0.4))),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'PhoneNumber',
                              border: InputBorder.none,
                              labelStyle: TextStyle(color: Colors.black),
                            ),
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter the phoneNumber Please!';
                                // } else if (value.trim().length >= 10) {
                                //   return 'Invalid phoneNumber!';
                              } else if (value.trim().length < 10) {
                                return 'Invalid phoneNumber!';
                              }
                            },
                            focusNode: _phoneNumberFoucsNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_emailFoucsNode);
                            },
                            onSaved: (value) {
                              _authData[kUserPhoneNumberKey] = value;
                            },
                          ),
                        ),
                      )
                    : Container(),
                /////////////////////////////////
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[300],
                        border: Border.all(
                            color: Colors.redAccent.withOpacity(0.4))),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'E-Mail',
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Invalid email!';
                        }
                      },
                      focusNode: _emailFoucsNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFoucsNode);
                      },
                      onSaved: (value) {
                        _authData[kUserEmailKey] = value;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[300],
                        border: Border.all(
                            color: Colors.redAccent.withOpacity(0.4))),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                      textInputAction: (_authMode == AuthMode.Signup)
                          ? TextInputAction.next
                          : TextInputAction.done,
                      obscureText: true,
                      controller: _passwordController,
                      validator: (value) {
                        if (value.isEmpty || value.length < 5) {
                          return 'Password is too short!';
                        }
                      },
                      focusNode: _passwordFoucsNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_confirmPsswordFoucsNode);
                      },
                      onSaved: (value) {
                        _authData[kUserPasswordKey] = value;
                      },
                    ),
                  ),
                ),
                (_authMode == AuthMode.Signup)
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[300],
                              border: Border.all(
                                  color: Colors.redAccent.withOpacity(0.4))),
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            enabled: _authMode == AuthMode.Signup,
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              border: InputBorder.none,
                              labelStyle: TextStyle(color: Colors.black),
                            ),
                            obscureText: true,
                            validator: _authMode == AuthMode.Signup
                                ? (value) {
                                    if (value != _passwordController.text) {
                                      return 'Passwords do not match!';
                                    }
                                  }
                                : null,
                            focusNode: _confirmPsswordFoucsNode,
                          ),
                        ),
                      )
                    : Container(),

                // (_authMode == AuthMode.Login)
                //     ?
                Container(
                  height: deviceSize.height * 0.05,
                  padding: EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Checkbox(
                          activeColor: Colors.redAccent.withOpacity(0.4),
                          autofocus: true,
                          checkColor: Colors.black38,
                          value: _checkBoxValue,
                          onChanged: (value) {
                            setState(() {
                              _checkBoxValue = value;
                            });
                          }),
                      Text(
                        'Remember Me',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black45),
                      ),
                    ],
                  ),
                ),
                // : Container(
                //     height: 10,
                //   ),
                Container(
                  height: deviceSize.height * 0.06,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print('000000000000000${boolProvider.isAdmin}');
                          boolProvider.changeAdminValue(false);
                          print('11111111111111111${boolProvider.isAdmin}');
                        },
                        child: Text(
                          'I\'m Admin',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: boolProvider.isAdmin
                                  ? Colors.black45
                                  : Colors.white),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print('222222222222222${boolProvider.isAdmin}');
                          boolProvider.changeAdminValue(true);
                          print('333333333333333${boolProvider.isAdmin}');
                        },
                        child: Text(
                          'I\'m User',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: boolProvider.isAdmin
                                  ? Colors.white
                                  : Colors.black45),
                        ),
                      ),
                    ],
                  ),
                ),

                // if (_isLoading)
                boolProvider.isLoading
                    ? CircularProgressIndicator()
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.grey.withOpacity(0.6),
                          border: Border.all(
                              color: Colors.redAccent.withOpacity(0.4)),
                        ),
                        child: FlatButton(
                          child: Text(_authMode == AuthMode.Login
                              ? 'LOGIN'
                              : 'SIGN UP'),
                          onPressed: () async {
                            rememberMeLoggedIn();
                            isAdminSharedPrefernce();
                            _submit();
                          },
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 8.0),
                          color: Colors.transparent,
                          textColor: Colors.black,
                        ),
                      ),
                FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} ',
                        style: TextStyle(color: Colors.blue),
                      ),
                      Text('INSTEAD'),
                    ],
                  ),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
