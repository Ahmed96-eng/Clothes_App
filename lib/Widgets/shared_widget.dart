import 'package:Clothes_App/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexible_toast/flutter_flexible_toast.dart';

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
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        subtitle: Text(
                          contentDecorationMessage_2,
                          overflow: TextOverflow.fade,
                          softWrap: true,
                          style: kDailogContentMessageStyle,
                        ),
                      ),
                    ],
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
          Colors.white.withOpacity(0.3),
          Colors.blueAccent.withOpacity(0.7),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0, 1],
      ),
    );
  }
}
