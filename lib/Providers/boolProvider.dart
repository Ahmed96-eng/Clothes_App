import 'package:flutter/foundation.dart';

class BoolProvider extends ChangeNotifier {
  bool isLoading = false;

  changeLoadingValue(bool loadingValue) {
    isLoading = loadingValue;
    notifyListeners();
  }

  bool isAdmin = false;
  changeAdminValue(bool adminValue) {
    isAdmin = adminValue;
    notifyListeners();
  }
}
