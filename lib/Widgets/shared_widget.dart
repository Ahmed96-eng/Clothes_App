import 'dart:ui';
import 'package:Clothes_App/Providers/language_provider.dart';
import 'package:Clothes_App/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexible_toast/flutter_flexible_toast.dart';
import 'package:provider/provider.dart';

import 'app_localizations.dart';

class SharedWidget {
  static showToastMsg(message, {int time, fontSize = 16.0}) =>
      FlutterFlexibleToast.showToast(
        message: message,
        toastLength: Toast.LENGTH_SHORT,
        toastGravity: ToastGravity.BOTTOM,
        elevation: 10,
        textColor: Colors.white,
        backgroundColor: Colors.black.withOpacity(0.5),
        timeInSeconds: time,
        fontSize: fontSize,
      );

  static showAlertDailog({
    BuildContext context,
    String titlle,
    String message,
    String labelNo,
    String labelYes,
    Function onPressNo,
    Function onPressYes,
    bool isConfirm = false,
    bool contentDecoration = false,
    String contentDecorationLabel_1,
    String contentDecorationLabel_2,
    String contentDecorationMessage_1,
    String contentDecorationMessage_2,
    String fixedEmailHint,
    TextEditingController textFieldcontroller_1,
    TextEditingController textFieldcontroller_2,
  }) =>
      showDialog(
        context: context,
        builder: (ctx) => Container(
          decoration: dialogDecoration(),
          child: AlertDialog(
            backgroundColor: Colors.blue[400].withOpacity(0.4),
            // backgroundColor: Colors.red[300],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: new Text(
              titlle,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                  fontSize: 20),
            ),

            content: contentDecoration
                ? SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment:
                          Provider.of<LanguageProvider>(context, listen: false)
                                      .appLocale
                                      .languageCode ==
                                  'en'
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                      crossAxisAlignment:
                          Provider.of<LanguageProvider>(context, listen: false)
                                      .appLocale
                                      .languageCode ==
                                  'en'
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[300],
                              border: Border.all(
                                  color: Colors.redAccent.withOpacity(0.4))),
                          child: TextField(
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: AppLocalizations.of(context)
                                    .translate("Enter your fullName please")),
                            controller: textFieldcontroller_1,
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[300],
                              border: Border.all(
                                  color: Colors.redAccent.withOpacity(0.4))),
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: AppLocalizations.of(context)
                                    .translate(
                                        "Enter your phoneNumber please")),
                            controller: textFieldcontroller_2,
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[300],
                              border: Border.all(
                                  color: Colors.redAccent.withOpacity(0.4))),
                          child: TextField(
                            decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                border: InputBorder.none,
                                hintText: fixedEmailHint),
                            enabled: false,
                          ),
                        ),
                        SizedBox(height: 5),
                        ListTile(
                          title: Text(
                            contentDecorationLabel_1,
                            overflow: TextOverflow.fade,
                            softWrap: true,
                            style: kDailogContentLabelStyle,
                          ),
                          subtitle: Text(
                            contentDecorationMessage_1,
                            overflow: TextOverflow.fade,
                            softWrap: true,
                            style: kDailogContentMessageStyle,
                          ),
                        ),
                        ListTile(
                          // contentPadding: EdgeInsets.symmetric(vertical: 0),
                          title: Text(
                            contentDecorationLabel_2,
                            overflow: TextOverflow.fade,
                            softWrap: true,
                            style: kDailogContentLabelStyle,
                          ),
                          subtitle: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  contentDecorationMessage_2,
                                  overflow: TextOverflow.fade,
                                  softWrap: true,
                                  style: kDailogContentMessageStyle,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                  AppLocalizations.of(context).translate("EGP"),
                                  style: kDailogContentMessageStyle),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    message,
                    overflow: TextOverflow.fade,
                    softWrap: true,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
            actions: <Widget>[
              FlatButton(
                shape: StadiumBorder(),
                color: Colors.white,
                child: new Text(
                  labelYes,
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: onPressYes,
              ),
              isConfirm == true
                  ? FlatButton(
                      shape: StadiumBorder(),
                      color: Colors.white,
                      child: new Text(
                        labelNo,
                        style: TextStyle(color: Colors.black54),
                      ),
                      onPressed: onPressNo,
                    )
                  : Container(),
            ],
          ),
        ),
      );

  static BoxDecoration dialogDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.white,
          Colors.cyan[300].withOpacity(0.8),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0, 1],
      ),
    );
  }

  static BoxDecoration adminDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.red.withOpacity(0.3),
          Colors.blueAccent.withOpacity(0.5),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0, 1],
      ),
      borderRadius: BorderRadius.circular(30),
    );
  }
}
